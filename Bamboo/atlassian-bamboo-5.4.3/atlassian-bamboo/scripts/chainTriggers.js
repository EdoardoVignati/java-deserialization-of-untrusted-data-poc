(function ($, BAMBOO) {
    BAMBOO.TRIGGER = {};

    BAMBOO.TRIGGER.chainTriggerConfig = (function () {
        var defaults = {
                    addTriggerTrigger: null,
                    triggerSetupContainer: null,
                    triggerConfigContainer: null,
                    triggerList: null,
                    templates: {
                        triggerListItem: null,
                        triggerListItemDefaultMarker: null,
                        iconTemplate: null
                    },
                    i18n: {
                        cancel: AJS.I18n.getText("global.buttons.cancel"),
                        confirmAbandonTrigger: AJS.I18n.getText("chain.trigger.add.abandon"),
                        triggerAddSuccess: AJS.I18n.getText("chain.trigger.add.success"),
                        triggerEditSuccess: AJS.I18n.getText("chain.trigger.edit.success"),
                        triggerDeleteSuccess: AJS.I18n.getText("chain.trigger.delete.success"),
                        defaultDisplayText: AJS.I18n.getText("chain.trigger.config.noTriggerSelected"),
                        defaultDisplayTextDescription: AJS.I18n.getText("chain.trigger.config.noTriggerSelected.help")
                    },
                    preselectItemId: null
                },
                options,
                editor = new BAMBOO.ConfigPanelEditor(),
                $triggerSetupContainer,
                $triggerConfigContainer,
                $triggerList,
                $loadingIndicator,
                checkListHasItems = function(hasItems) {
                },
                configFormSuccess = function (data, isUnsaved) {
                    editor.displayMessages([{ title: (isUnsaved ? options.i18n.triggerAddSuccess : options.i18n.triggerEditSuccess) }]);
                    return $(AJS.template.load(options.templates.triggerListItem).fill({ name: data.triggerResult.name, id: data.triggerResult.id, description: data.triggerResult.description }).toString()).addClass("active");
                },
                configFormWarnings = function (warnings) {
                    for (var i = 0, ii = warnings.length; i < ii; i++) {
                        editor.displayMessages([{ type: "warning", title: warnings[i] }]);
                    }
                },
                addTrigger = function (e) {
                    var $addTriggerTrigger = $(this),
                            $triggerListItem = $(AJS.template.load(options.templates.triggerListItem).fill({ name: "New trigger", id: "", description: "" }).toString());

                    e.preventDefault();

                    if (!editor.isOkayToProceedWithUnsavedItem()) {
                        editor.setFocus();
                        return false;
                    }

                    if (!$loadingIndicator) {
                        $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addTriggerTrigger.closest(".aui-toolbar"));
                    } else {
                        $loadingIndicator.show();
                    }

                    editor.add($addTriggerTrigger.attr("href"), $triggerListItem, "appendTo", $triggerList).success(function () {
                        $loadingIndicator.hide();
                    });

                };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                editor.init({
                                editor: options.triggerSetupContainer,
                                configContainer: options.triggerConfigContainer,
                                itemList: options.triggerList,
                                deleteItemKey: "triggerResult",
                                checkListHasItems: checkListHasItems,
                                configFormSuccess: configFormSuccess,
                                configFormWarnings: configFormWarnings,
                                templates: {
                                    item: options.templates.triggerListItem,
                                    icon: options.templates.iconTemplate
                                },
                                i18n: {
                                    confirmAbandonItem: options.i18n.confirmAbandonTrigger,
                                    itemDeleteSuccess: options.i18n.triggerDeleteSuccess,
                                    defaultDisplayText: options.i18n.defaultDisplayText,
                                    defaultDisplayTextDescription: options.i18n.defaultDisplayTextDescription
                                },
                                sortable: {
                                    enabled: false
                                }
                            });

                $(function () {
                    $triggerSetupContainer = $(options.triggerSetupContainer)
                            .delegate(options.addTriggerTrigger, "click", addTrigger);
                    $triggerList = $(options.triggerList);
                    $triggerConfigContainer = $(options.triggerConfigContainer);

                    editor.checkListHasItems();

                    if (options.preselectItemId) {
                        $(options.triggerList).children("#item-" + options.preselectItemId).click();
                    }
                });
            }
        }
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));