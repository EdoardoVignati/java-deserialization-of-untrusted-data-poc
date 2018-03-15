(function ($, BAMBOO) {
    BAMBOO.LABELS = {};
    BAMBOO.LABELS.LabelDialog = LabelDialog;

    function LabelDialog(opts) {
        var defaults = {
                trigger: '.labels-edit',
                labelView: '.label-list, .label-none',
                labelsDialog: {
                    id: 'labels-dialog',
                    header: null,
                    width: 550,
                    height: 250,
                    shortcutKey: AJS.I18n.getText('global.key.label')
                },
                removeUrl: ''
            },
            options = $.extend(true, defaults, opts),
            $loadingIndicator,
            dialog,
            setupDialogContent = function (html) {
                var $html = $(html);
                $loadingIndicator.hide();

                dialog.addPanel('All', $html).show();
            },
            showDialog = function (e) {
                e.preventDefault();
                var $trigger = $(this);

                if (!$loadingIndicator) {
                    $loadingIndicator = $(widget.icons.icon({ type: 'loading' })).insertAfter($trigger);
                } else {
                    $loadingIndicator.show();
                }

                dialog = new AJS.Dialog({
                    id: options.labelsDialog.id,
                    width: options.labelsDialog.width,
                    height: options.labelsDialog.height,
                    keypressListener: function (e) {
                        if (e.which == jQuery.ui.keyCode.ESCAPE) {
                            dialog.remove();
                        }
                    }
                });

                dialog.addCancel(AJS.I18n.getText('global.buttons.close'), function () { dialog.remove(); })
                      .addHeader(options.labelsDialog.header);

                if (options.labelsDialog.shortcutKey) {
                    dialog.addHelpText(AJS.I18n.getText('labels.edit.shortcut', options.labelsDialog.shortcutKey));
                }

                $.ajax({
                    url: $trigger.attr('href'),
                    data: { decorator: 'nothing', confirm: true },
                    success: setupDialogContent,
                    cache: false
                });
                $('#' + options.labelsDialog.id).addClass('labels-dialog');
            },
            addLabels = function (e) {
                e.preventDefault();

                var $form = $(this),
                    $input = $form.find('input:text').attr('readonly', 'readonly'),
                    $submit = $form.find('input:submit').attr('disabled', 'disabled'),
                    $loading = $(widget.icons.icon({ type: 'loading' })).insertAfter($submit);

                $.post($form.attr('action'), $form.serialize(), function (data) {
                    var fieldErrors;
                    $form.find('.error,.aui-message').remove();
                    if (typeof data == 'object') {
                        // Returned data is JSON
                        fieldErrors = data.fieldErrors;
                        if (fieldErrors) {
                            for (var fieldName in fieldErrors) {
                                if (fieldErrors.hasOwnProperty(fieldName)) {
                                    BAMBOO.addFieldErrors($form, fieldName, fieldErrors[fieldName]);
                                }
                            }
                        }
                        if (data.errors) {
                            $form.prepend(BAMBOO.buildAUIErrorMessage(data.errors));
                        }
                    } else {
                        // Returned data isn't JSON, assume it's HTML
                        updateDisplay(data);
                        $form.find('input:text').val('');
                    }
                    $input.removeAttr('readonly');
                    $submit.removeAttr('disabled');
                    $loading.remove();
                    $form.find('input:text').focus();
                });
            },
            deleteLabel = function (e) {
                e.preventDefault();

                $.post(options.removeUrl, { selectedLabel: $(this).closest('.aui-label').attr('data-label') }).done(updateDisplay);
            },
            updateDisplay = function (data) {
                var $html = $(data),
                    edit = $html.filter('.label-edit-mode').html(),
                    view = $html.filter('.label-view-mode').html();

                $(options.labelView).each(function () {
                    var $replaceTarget = $(this);
                    $replaceTarget.replaceWith($replaceTarget.closest('#' + options.labelsDialog.id).length ? edit : view);
                });
            },
            handlersBoundKey = options.labelsDialog.id + 'handlersBound';

        if (!$(document).data(handlersBoundKey)) {
            $(document)
                .undelegate('.' + options.labelsDialog.id)
                .delegate(options.trigger, 'click.' + options.labelsDialog.id, showDialog)
                .delegate('#' + options.labelsDialog.id + ' form', 'submit.' + options.labelsDialog.id, addLabels)
                .delegate('#' + options.labelsDialog.id + ' .aui-icon-close', 'click.' + options.labelsDialog.id, deleteLabel);

            if (options.labelsDialog.shortcutKey) {
                $(function(){
                    AJS.whenIType(options.labelsDialog.shortcutKey).click(options.trigger);
                });
            }
            $(document).data(handlersBoundKey, true);
        }
    }
}(AJS.$, window.BAMBOO = (window.BAMBOO || {})));
