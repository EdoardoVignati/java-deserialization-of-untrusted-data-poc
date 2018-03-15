(function ($, BAMBOO) {
    BAMBOO.deploymentProjectVersioning = (function () {
        var defaults = {
                deploymentProjectId: null,
                addVariableDialogUrl: null,
                versionPreviewUrl: null,
                versionVariablesUrl: null,
                versionPreviewTemplate: bamboo.page.deployment.project.versioning.preview,
                variableDialogTemplate: bamboo.page.deployment.project.versioning.variables,
                variablesToIncrementItemTemplate: bamboo.page.deployment.project.versioning.variableIncrementContents,
                currentlySelectedVariables: [],
                selectors: {
                    addVariable: null,
                    form: null,
                    nextVersion: null,
                    versionPreviewButton: null,
                    versionPreview: null,
                    variableCheckboxList: null
                }
            },
            options,
            $loading = AJS.$(widget.icons.icon({ type: 'loading aui-dialog-content-loading' })),
            showAddVariableDialog = function () {
                var $dialogContent = AJS.$('<div class="add-variable-dialog"/>').html($loading),
                    dialog = new AJS.Dialog({
                        width: 840,
                        height: 600,
                        keypressListener: function (e) {
                            if (e.which == jQuery.ui.keyCode.ESCAPE) {
                                dialog.remove();
                                $dialogContent.html($loading);
                            }
                        }
                    });

                dialog.addButton(AJS.I18n.getText('global.buttons.close'), function (dialog) {
                    dialog.remove();
                    $dialogContent.html($loading);
                });
                dialog.addPanel("", $dialogContent);
                dialog.addHeader(AJS.I18n.getText('deployment.project.version.addvariable.title'));
                AJS.$.ajax({
                    url: options.addVariableDialogUrl,
                    data: { 'bamboo.successReturnMode': 'json', decorator: 'nothing', confirm: true },
                    success: function (data) {
                        $dialogContent.empty().append(options.variableDialogTemplate(data));
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        var $message = BAMBOO.generateErrorMessages(jqXHR, textStatus, errorThrown);
                        $dialogContent.empty().append($message);
                    },
                    cache: false
                });

                $(".add-variable-dialog").on('click', '.add-variable', function (e) {
                    var $trigger = $(this),
                        $nextVersionField = $(options.selectors.nextVersion),
                        variable = '${bamboo.' + $trigger.data("variableKey") + '}';
                    $nextVersionField.val($nextVersionField.val() + variable);
                    dialog.remove();
                    $dialogContent.html($loading);
                    $nextVersionField.focus();
                    updateAll();
                });

                dialog.show();
            },
            updatePreview = function() {
                $(options.selectors.versionPreview).empty().append($loading);
                AJS.$.ajax({
                    url: options.versionPreviewUrl,
                    data: {'bamboo.successReturnMode': 'json',
                            decorator: 'nothing',
                            confirm: true,
                            nextVersionName: $(options.selectors.nextVersion).val(),
                            incrementNumbers: $('input[name=autoIncrement]').is(':checked'),
                            incrementableVariables: options.currentlySelectedVariables.join()
                    },
                    success: function (data) {
                        $(options.selectors.versionPreview).empty().append(options.versionPreviewTemplate(data));
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        var $message = BAMBOO.generateErrorMessages(jqXHR, textStatus, errorThrown);
                        $(options.selectors.versionPreview).empty().append($message);
                    },
                    cache: false
                });
            },
            updateCheckboxList = function() {
                $(options.selectors.variableCheckboxList).empty().append($loading);
                AJS.$.ajax({
                    url: options.versionVariablesUrl,
                    data: {'bamboo.successReturnMode': 'json',
                        decorator: 'nothing',
                        confirm: true,
                        nextVersionName: $(options.selectors.nextVersion).val()
                    },
                    success: function (variableNames) {
                        var variables = _.map(variableNames, function (variableName) {
                            return {value: variableName, label: variableName, checked: _.contains(options.currentlySelectedVariables, variableName)};
                        });
                        $(options.selectors.variableCheckboxList).empty().append(options.variablesToIncrementItemTemplate({variables: variables}));
                    },
                    cache: false
                });
            },
            updateCurrentlySelectedVariables = function () {
                options.currentlySelectedVariables = [];
                $('input[name=variablesToAutoIncrement]:checked', options.selectors.variableCheckboxList).each(function() {
                    options.currentlySelectedVariables.push($(this).val());
                });
            },
            updateAll = function () {
                updateCurrentlySelectedVariables();
                updateCheckboxList();
                updatePreview();
            };
        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                $(options.selectors.addVariable).on('click', showAddVariableDialog);
                $(options.selectors.versionPreviewButton).on('click', updateAll);
                $(options.selectors.form).on('change', 'input:checkbox' , function() {
                    updateCurrentlySelectedVariables();
                    updatePreview();
                });

                updatePreview();
                updateCheckboxList();
            }
        }
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));