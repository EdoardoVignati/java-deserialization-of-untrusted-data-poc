(function ($, BAMBOO) {
    BAMBOO.REPOSITORY = {};

    BAMBOO.REPOSITORY.repositoryConfig = (function () {
        var defaults = {
                addRepositoryTrigger: null,
                repositorySetupContainer: null,
                repositoryConfigContainer: null,
                repositoryList: null,
                selectRepositorySelector: "#selectedRepository",
                templates: {
                    repositoryListItem: null,
                    repositoryListItemDefaultMarker: null,
                    iconTemplate: null
                },
                i18n: {
                    cancel: AJS.I18n.getText("global.buttons.cancel"),
                    confirmAbandonRepository: AJS.I18n.getText("repository.add.abandon"),
                    repositoryAddSuccess: AJS.I18n.getText("repository.add.success"),
                    repositoryEditSuccess: AJS.I18n.getText("repository.edit.success"),
                    repositoryDeleteSuccess: AJS.I18n.getText("repository.delete.success"),
                    sortingHasUnsavedRepositoryError: AJS.I18n.getText("repository.sort.error.hasUnsavedRepository"),
                    defaultDisplayText: AJS.I18n.getText("repository.config.noRepositorySelected"),
                    defaultDisplayTextDescription: AJS.I18n.getText("repository.config.noRepositorySelected.help"),
                    repositoryMovingError: AJS.I18n.getText("There was a problem moving your repository."),
                    repositoryMovingFailure: AJS.I18n.getText("Repository move failed")
                },
                moveRepositoryUrl: null,
                markDefault: true,
                getRepoConfigUrl: null,
                preselectItemId: null
            },
            options,
            editor = new BAMBOO.ConfigPanelEditor(),
            $repositorySetupContainer,
            $repositoryConfigContainer,
            $repositoryList,
            $loadingIndicator,
            checkListHasItems = function(hasItems) {
                if (hasItems) {
                    markDefaultRepository();
                }
            },
            configFormSuccess = function (data, isUnsaved) {
                editor.displayMessages([{ title: (isUnsaved ? options.i18n.repositoryAddSuccess : options.i18n.repositoryEditSuccess) }]);
                return $(AJS.template.load(options.templates.repositoryListItem).fill({ name: data.repositoryResult.name, id: data.repositoryResult.id }).toString()).addClass("active");
            },
            configFormWarnings = function (warnings) {
                for (var i = 0, ii = warnings.length; i < ii; i++) {
                    editor.displayMessages([{ type: "warning", title: warnings[i] }]);
                }
            },
            markDefaultRepository = function() {
                if (options.markDefault) {
                    $repositoryList.find(".item-default").removeClass("item-default").find(".item-default-marker").remove();
                    $repositoryList.find(".item:first").addClass("item-default").find(".item-title").append(
                        AJS.template.load(options.templates.repositoryListItemDefaultMarker).toString()
                    );
                }
            },
            addRepository = function (e) {
                var $addRepositoryTrigger = $(this),
                    $repositoryListItem = $(AJS.template.load(options.templates.repositoryListItem).fill({ name: "New Repository", id: "" }).toString());

                e.preventDefault();

                if (!editor.isOkayToProceedWithUnsavedItem()) {
                    editor.setFocus();
                    return false;
                }

                if (!$loadingIndicator) {
                    $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addRepositoryTrigger.closest(".aui-toolbar"));
                } else {
                    $loadingIndicator.show();
                }

                editor.add($addRepositoryTrigger.attr("href"), $repositoryListItem, "appendTo", $repositoryList).success(function () {
                    $loadingIndicator.hide();
                });

                markDefaultRepository();
            },
            moveRepository = function ($repositoryListItem) {
                return $.post(options.moveRepositoryUrl, {
                    repositoryId: $repositoryListItem.data("item-id"),
                    afterPosition: $repositoryListItem.nextAll(".item:first").data("item-id"),
                    beforePosition: $repositoryListItem.prevAll(".item:first").data("item-id"),
                    "bamboo.successReturnMode": "json"
                }).done(markDefaultRepository);
            },
            loadRepoConfigJqXHR,
            selectRepositoryType = function (e) {
                var $selectRepository = $(this),
                    $selectRepositoryFieldGroup = $selectRepository.closest(".field-group"),
                    $selectRepositoryError = $selectRepositoryFieldGroup.next(".aui-message.error"),
                    val = $selectRepository.val(),
                    $loading = $selectRepository.next(".icon-loading"),
                    $repoConfig = $("#repository-configuration"),
                    $repoAdvanced = $repoConfig.find('.collapsible-section'),
                    $repoEdit = $("#repository-edit-" + BAMBOO.escapeIdToJQuerySelector(val)),
                    isGlobal = $.isNumeric(val),
                    data = {
                        decorator: "nothing",
                        confirm: true,
                        selectedRepository: val // this makes the dependsOn stuff on the ui.bambooSection not add display:none; to the fieldset
                    };

                if ($selectRepositoryError.length) {
                    $selectRepositoryError.remove();
                }
                if (!$repoEdit.length) {
                    e && e.stopPropagation();

                    if ($loading.length) {
                        $loading.show();
                    } else {
                        $loading = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($selectRepository);
                    }

                    data[(isGlobal ? "globalRepositoryId" : "repositoryPluginKey")] = val;

                    // Cancel pending request (if applicable)
                    if (loadRepoConfigJqXHR && loadRepoConfigJqXHR.readyState < 4) {
                        loadRepoConfigJqXHR.abort();
                    }

                    loadRepoConfigJqXHR = $.get(options.getRepoConfigUrl, data).done(function (html) {
                        var $html = $(html),
                            $basic = $html.filter("#repository-edit-html").children(),
                            $advanced = $html.filter("#repository-advanced-edit-html").children(),
                            $scripts = $html.filter("script");

                        if ($basic.length) {
                            $repoAdvanced.before($basic.hide());
                        }
                        if ($advanced.length) {
                            $repoAdvanced.children(".collapsible-details").prepend($advanced.hide());
                        }
                        if ($basic.length || $advanced.length) {
                            BAMBOO.DynamicFieldParameters.syncFieldShowHide($repositoryConfigContainer, true);
                        }

                        // If any scripts were returned append them to the <head> so that they get executed
                        if ($scripts.length) {
                            $scripts.appendTo("head");
                        }
                    }).fail(function (jqXHR, textStatus) {
                        if (textStatus != "abort") {
                            $selectRepositoryError = BAMBOO.buildAUIErrorMessage([ "An error occurred while retrieving the configuration for " + $selectRepository.find(":selected").text() ])
                                .append('<p>Try to <a class="try-again">load the configuration</a> again, or if the problem persists please <a href="' + AJS.contextPath() + '/viewAdministrators.action">contact your administrators</a>.</p>')
                                .delegate("a.try-again", "click", function () { selectRepositoryType.call($selectRepository[0]); })
                                .insertAfter($selectRepositoryFieldGroup);
                        }
                    }).always(function (jqXHR, textStatus) {
                        if (textStatus != "abort") {
                            $loading.hide();
                        }
                    });
                }
            };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                editor.init({
                    editor: options.repositorySetupContainer,
                    configContainer: options.repositoryConfigContainer,
                    itemList: options.repositoryList,
                    deleteItemKey: "repositoryResult",
                    checkListHasItems: checkListHasItems,
                    configFormSuccess: configFormSuccess,
                    configFormWarnings: configFormWarnings,
                    templates: {
                        item: options.templates.repositoryListItem,
                        icon: options.templates.iconTemplate
                    },
                    i18n: {
                        confirmAbandonItem: options.i18n.confirmAbandonRepository,
                        itemDeleteSuccess: options.i18n.repositoryDeleteSuccess,
                        sortingHasUnsavedItemError: options.i18n.sortingHasUnsavedRepositoryError,
                        sortingHasUnspecifiedError: options.i18n.repositoryMovingError,
                        sortingErrorDialogHeader: options.i18n.repositoryMovingFailure,
                        defaultDisplayText: options.i18n.defaultDisplayText,
                        defaultDisplayTextDescription: options.i18n.defaultDisplayTextDescription
                    },
                    sortable: {
                        enabled: !!options.moveRepositoryUrl,
                        items: "> li:not(#repository-trigger-item)",
                        moveItem: moveRepository
                    },
                    deleteDialogHeight: 540
                });

                $(function () {
                    $repositorySetupContainer = $(options.repositorySetupContainer)
                        .delegate(options.addRepositoryTrigger, "click", addRepository)
                        .delegate(options.selectRepositorySelector, "change", selectRepositoryType);
                    $repositoryList = $(options.repositoryList);
                    $repositoryConfigContainer = $(options.repositoryConfigContainer);

                    editor.checkListHasItems();

                    if (options.preselectItemId) {
                        $(options.repositoryList).children("#item-" + options.preselectItemId).click();
                    }
                });
            }
        }
    }());


    BAMBOO.REPOSITORY.buildStrategyToggle = (function () {
        var defaults = {
                noVcsStrategyOptions : null,
                vcsStrategyOptions : null,
                strategyList: null
            },
            options,
            $strategyList,
            toggleStrategiesForCreate = function () {
                if (!$strategyList) {
                    $strategyList = $(options.strategyList);
                }
                var value = $strategyList.val();
                $strategyList.attr("disabled", "disabled");
                if ($(this).val() == "nullRepository") {
                    $strategyList.html(options.noVcsStrategyOptions);
                } else {
                    $strategyList.html(options.vcsStrategyOptions);
                }
                $strategyList.removeAttr("disabled").val(value).change();
            };
        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);
                $(document).delegate("#selectedRepository", "change", toggleStrategiesForCreate);
            }
        }
    }());

    BAMBOO.REPOSITORY.CheckoutTaskConfiguration = (function () {
        var defaults = {
                addCheckoutSelector: null,
                removeCheckoutSelector: '.toolbar-trigger',
                checkoutListSelector: null,
                checkoutDirectorySelector: null,
                selectedRepositorySelector: 'select[name^="selectedRepository_"]',
                templates: {
                    checkoutListItem: null
                },
                i18n: {
                    checkoutDirectoryInUse: null
                }
            },
            options,
            $list,
            $form,
            addCheckoutListItem = function () {
                var newIndex, $lastCheckout;

                $lastCheckout = $list.children(':last');
                newIndex = ($lastCheckout.length ? (parseInt($lastCheckout.attr('data-checkout-id'), 10) + 1) : 0);

                $(AJS.template.load(options.templates.checkoutListItem).fill({ index: newIndex }).toString())
                    .hide().appendTo($list)
                    .find(options.selectedRepositorySelector).end()
                    .slideDown();

                BAMBOO.DynamicFieldParameters.syncFieldShowHide($list);
            },
            removeCheckoutListItem = function () {
                $(this).closest('.aui-toolbar').closest('li').slideUp(function () { $(this).remove(); });
            },
            validateForm = function (e) {
                var checkoutDirectories = {},
                    hasError = false,
                    checkField = function () {
                        var $field = $(this),
                            val = $field.val();

                        if (checkoutDirectories.hasOwnProperty(val)) {
                            $('<div/>', { 'class': 'error', text: options.i18n.checkoutDirectoryInUse }).insertAfter($field.next('.description'));
                            hasError = true;
                        } else {
                            checkoutDirectories[val] = true;
                        }
                    },
                    $trigger = $(this),
                    $fieldsToCheck = $form.find(options.checkoutDirectorySelector);

                $form.find('.error').remove();

                if ($trigger.is(':text')) {
                    $fieldsToCheck = $fieldsToCheck.not($trigger);
                    $fieldsToCheck.each(checkField);
                    checkField.apply(this);
                } else {
                    $fieldsToCheck.each(checkField);
                    if (hasError) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                }
            };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                $(function () {
                    $list = $(options.checkoutListSelector)
                        .delegate(options.removeCheckoutSelector, 'click', removeCheckoutListItem)
                        .delegate(options.checkoutDirectorySelector, 'blur', validateForm);

                    $form = $list.closest('form').submit(validateForm);
                    $(options.addCheckoutSelector).click(addCheckoutListItem);
                });
            }
        };
    }());

    BAMBOO.REPOSITORY.viewUsages = (function () {
        var defaults = {
                trigger: ".viewRepositoryUsagesTrigger",
                labelsDialog: {
                    id: "repositoryUsagesDialog",
                    header: null,
                    width: 600,
                    height: 300
                },
                i18n: {
                    close: AJS.I18n.getText("global.buttons.close")
                },
                templates: {
                    iconTemplate: '<span class="icon icon-{type}"></span>'
                }
            },
            options,
            dialog,
            initialised = false,
            setupDialogContent = function (html) {
                var $html = $(html);
                dialog.addPanel("All", $html).show();
                $("#viewRepositoryUsagesForm .buttons-container").hide();
            },
            showDialog = function (e) {
                e.preventDefault();
                var $trigger = $(this);

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

                dialog.addCancel(options.i18n.close, function () { dialog.remove(); })
                    .addHeader(options.labelsDialog.header);

                $.ajax({
                    url: $trigger.attr("href"),
                    data: { decorator: 'nothing', confirm: true },
                    success: setupDialogContent,
                    cache: false
                });
            };
        return {
            init: function (opts) {
                if (!initialised) {
                    options = $.extend(true, defaults, opts);

                    $(document).undelegate("." + options.labelsDialog.id)
                        .delegate(options.trigger, "click." + options.labelsDialog.id, showDialog);
                    initialised = true;
                }
            }
        };
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));