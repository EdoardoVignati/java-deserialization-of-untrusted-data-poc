BAMBOO.TASKS = {};

BAMBOO.TASKS.tasksConfig = function ($) {
    var defaults = {
        addTaskTrigger: null,
        taskSetupContainer: null,
        taskConfigContainer: null,
        taskList: null,
        defaultTaskToSelect: null,
        taskTypeCategories: { categories: [] },
        taskTypesDialog: {
            id: "task-types-dialog",
            header: AJS.I18n.getText("tasks.types.title"),
            width: 865,
            height: 530,
            filterForm: null
        },
        templates: {
            taskListItem: null,
            lozengeDisabled: null,
            iconTemplate: null,
            getMoreOnPac: null
        },
        i18n: {
            cancel: AJS.I18n.getText("global.buttons.cancel"),
            confirmAbandonTask: AJS.I18n.getText("tasks.add.abandon"),
            tasksAddSuccess: AJS.I18n.getText("tasks.add.success"),
            tasksAddSuccessWarning: AJS.I18n.getText("tasks.add.success.warning"),
            tasksEditSuccess: AJS.I18n.getText("tasks.edit.success"),
            tasksEditSuccessWarning: AJS.I18n.getText("tasks.edit.success.warning"),
            tasksDeleteSuccess: AJS.I18n.getText("tasks.delete.success"),
            sortingHasUnsavedTaskError: AJS.I18n.getText("tasks.sort.error.hasUnsavedTask"),
            sortingHasUnspecifiedError: AJS.I18n.getText("tasks.sort.error.hasUnspecifiedError.description"),
            sortingErrorDialogHeader: AJS.I18n.getText("tasks.sort.error.hasUnspecifiedError.title"),
            defaultDisplayText: AJS.I18n.getText("tasks.config.noTaskSelected"),
            defaultDisplayTextDescription: AJS.I18n.getText("tasks.config.noTaskSelected.help")
        },
        agentAvailabilityDescriptionContainer: null,
        agentAvailabilityDescriptionUrl: null,
        moveTaskUrl: null,
        moveFinalBarUrl: null
    },
    options,
    editor = new BAMBOO.ConfigPanelEditor(),
    $filterForm,
    $taskTypesDialog,
    $taskSetupContainer,
    $taskConfigContainer,
    $taskList,
    $loadingIndicator,
    $finalTasksBar,
    taskTypesDialog,
    updateAgentAvailabilityDescription = function () {
        $.ajax({
            url: options.agentAvailabilityDescriptionUrl,
            data: { decorator: "nothing", confirm: true },
            cache: false
          }).done(function (data) {
                $(options.agentAvailabilityDescriptionContainer).html(data);
          });
    },
    displaySuccessMessageAndPossibleWarning = function (isNew, data) {
        var list,
            messages = [{ title: (isNew ? options.i18n.tasksAddSuccess : options.i18n.tasksEditSuccess) }];

        if (data.taskResult.warning.requirementsConflicts) {
            list = ["<ul>"];
            for (var r = 0, rr = data.taskResult.warning.requirementsConflicts.length; r < rr; r++) {
                var req = data.taskResult.warning.requirementsConflicts[r],
                    reqKey = req.group,
                    conflicts = req.labels;

                list.push("<li>", reqKey, "</li><ul>");
                for (var i = 0, ii = conflicts.length; i < ii; i++) {
                    list.push("<li>", conflicts[i], "</li>");
                }
                list.push("</ul>");
            }
            list.push("</ul>");
            messages.unshift({ title: (isNew ? options.i18n.tasksAddSuccessWarning : options.i18n.tasksEditSuccessWarning), type: "warning", body: list.join("") });
        }
        editor.displayMessages(messages);
    },
    configFormSuccess = function (data, isUnsaved) {
        updateAgentAvailabilityDescription();
        displaySuccessMessageAndPossibleWarning(isUnsaved, data);
        var taskItem = $(AJS.template.load(options.templates.taskListItem).fill({ name: data.taskResult.task.name, description: data.taskResult.task.description, id: data.taskResult.task.id, valid : data.taskResult.task.valid }).toString()).addClass("active");
        if (data.taskResult.task.isEnabled === false) {
            $(AJS.template.load(options.templates.lozengeDisabled).toString()).insertBefore(taskItem.find(".delete"));
        }
        return taskItem;
    },
    addTask = function (e) {
        var $taskTypeListItem = $(this).append($(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString())),
            $taskConfigLink = $taskTypeListItem.find(".task-type-title > a"),
            $taskListItem = $(AJS.template.load(options.templates.taskListItem).fill({ name: $taskConfigLink.text(), description: "", id: "" , valid : true }).toString());

        e.preventDefault();

        editor.add($taskConfigLink.attr("href"), $taskListItem, "insertBefore", $finalTasksBar).success(function () {
            taskTypesDialog.remove();
        });
    },
    setupTaskTypesDialogContent = function (html) {
        var $html = $(html);

        $loadingIndicator.hide();

        taskTypesDialog.addPanel("All", $html);
        for (var i = 0, ii = options.taskTypeCategories.length; i < ii; i++) {
            var category = options.taskTypeCategories[i],
                $categoryTasks = $html.clone();
            $categoryTasks.children(":not(.task-type-category-" + category.key + ")").remove();
            if ($categoryTasks.children().length) {
                taskTypesDialog.addPanel(category.label, $categoryTasks);
            }
        }

        taskTypesDialog.show().gotoPanel(0);

        $taskTypesDialog = $("#" + options.taskTypesDialog.id).delegate(".task-type-list > li", "click", addTask);

        if (options.taskTypesDialog.filterForm) {
            $filterForm.find("> input").focus();
        }
    },
    showTaskTypesPicker = function (e) {
        var $addTaskTrigger = $(this),
            header = options.taskTypesDialog.header ? options.taskTypesDialog.header : $addTaskTrigger.text();

        e.preventDefault();

        if (!editor.isOkayToProceedWithUnsavedItem()) {
            editor.setFocus();
            return false;
        }

        if (!$loadingIndicator) {
            $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addTaskTrigger.closest(".aui-toolbar"));
        } else {
            $loadingIndicator.show();
        }

        taskTypesDialog = new AJS.Dialog({
            id: options.taskTypesDialog.id,
            width: options.taskTypesDialog.width,
            height: options.taskTypesDialog.height,
            keypressListener: function (e) {
                if (e.which == jQuery.ui.keyCode.ESCAPE) {
                    taskTypesDialog.remove();
                }
            }
        });

        if (header) {
            taskTypesDialog.addHeader(header);

            if (options.taskTypesDialog.filterForm) {
                $filterForm = $(options.taskTypesDialog.filterForm).appendTo(taskTypesDialog.page[0].header);

                $filterForm.submit(function (e) { e.preventDefault(); }).find("> input").bind("keypress keyup click", function (e) {
                    var textToLookFor = $(this).val().toUpperCase();

                    e.stopPropagation();
                    $taskTypesDialog.find(".task-type-list > li").each(function () {
                        var $li = $(this);

                        $li[( $li.text().toUpperCase().indexOf(textToLookFor) >= 0 ? "show" : "hide" )]();
                    });
                });
            }
        }
        taskTypesDialog.addCancel(options.i18n.cancel, function () { taskTypesDialog.remove(); });
        if (options.templates.getMoreOnPac) {
            taskTypesDialog.addHelpText(options.templates.getMoreOnPac, {});
        }

        $.ajax({
            url: $addTaskTrigger.attr("href"),
            data: { decorator: "nothing", confirm: true },
            success: setupTaskTypesDialogContent,
            cache: false
        });
    },
    moveTask = function ($taskListItem) {
        var isMovedToFinal, status,
            requestComplete = function () {
                if (!status || status == "ERROR") {
                    triggerReflowOnPrompt();
                }
            };

        triggerReflowOnPrompt();

        if ($taskListItem.hasClass("final-tasks-bar")) {
            editor.updateUnspecifiedSortingErrorText("There was a problem moving the final tasks bar.");

            return $.ajax({
                type: "POST",
                url: options.moveFinalBarUrl,
                data: {
                    afterId: $taskListItem.nextAll(".item:first").data("item-id"),
                    beforeId: $taskListItem.prevAll(".item:first").data("item-id")
                },
                dataType: "json",
                complete: requestComplete
            }).done(function (json) {
                status = json.status;
                if (status != "ERROR") {
                    $taskListItem.nextAll(".item").addClass("final").end().prevAll(".item").removeClass("final");
                }
            });
        } else {
            isMovedToFinal = !!$taskListItem.prevAll(".final-tasks-bar").length;
            editor.updateUnspecifiedSortingErrorText(options.i18n.sortingHasUnspecifiedError);

            return $.ajax({
                type: "POST",
                url: options.moveTaskUrl,
                data: {
                    taskId: $taskListItem.data("item-id"),
                    afterId: $taskListItem.nextAll(".item:first").data("item-id"),
                    beforeId: $taskListItem.prevAll(".item:first").data("item-id"),
                    finalising: isMovedToFinal
                },
                dataType: "json",
                complete: requestComplete
            }).done(function (json) {
                status = json.status;
                if (status != "ERROR") {
                    $taskListItem.toggleClass("final", isMovedToFinal);
                }
            });
        }
    },
    triggerReflowOnPrompt = function () {
        var prompt;

        if ($.browser.msie && parseInt($.browser.version, 10) <= 8) {
            prompt = $("#final-tasks-prompt")[0];
            prompt.style.zoom = "100%";
            prompt.style.zoom = "normal";
        }
    };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);

            editor.init({
                editor: options.taskSetupContainer,
                configContainer: options.taskConfigContainer,
                itemList: options.taskList,
                deleteItemKey: "taskResult",
                configFormSuccess: configFormSuccess,
                templates: {
                    item: options.templates.taskListItem,
                    icon: options.templates.iconTemplate
                },
                i18n: {
                    confirmAbandonItem: options.i18n.confirmAbandonTask,
                    itemDeleteSuccess: options.i18n.tasksDeleteSuccess,
                    sortingHasUnsavedItemError: options.i18n.sortingHasUnsavedTaskError,
                    sortingHasUnspecifiedError: options.i18n.sortingHasUnspecifiedError,
                    sortingErrorDialogHeader: options.i18n.sortingErrorDialogHeader,
                    defaultDisplayText: options.i18n.defaultDisplayText,
                    defaultDisplayTextDescription: options.i18n.defaultDisplayTextDescription
                },
                sortable: {
                    items: "> li:not(#final-tasks-prompt)",
                    moveItem: moveTask
                }
            });

            $(document)
                    .delegate(options.addTaskTrigger, "click", showTaskTypesPicker);

            BAMBOO.simpleDialogForm({
                trigger: options.taskConfigContainer + " .delete .toolbar-trigger, " + options.taskConfigContainer + " .aui-message .delete",
                dialogWidth: 540,
                dialogHeight: 160,
                success: function (data) {
                    updateAgentAvailabilityDescription();
                    editor.displayMessages([{ title: options.i18n.tasksDeleteSuccess }]);
                    $taskList.find(".active").remove();
                    editor.checkListHasItems();
                },
                cancel: null
            });

            $(function () {
                $taskSetupContainer = $(options.taskSetupContainer);
                $taskList = $(options.taskList);
                $taskConfigContainer = $(options.taskConfigContainer);
                $finalTasksBar = $taskList.find(".final-tasks-bar");

                options.defaultTaskToSelect && $taskList.find("#item-" + options.defaultTaskToSelect).click();
            });
        }
    }
}(jQuery);
