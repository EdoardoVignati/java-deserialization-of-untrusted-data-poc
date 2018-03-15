AJS.$.namespace('Bamboo.Feature.Deployment.TasksDialog');

Bamboo.Feature.Deployment.TasksDialog = Bamboo.Widget.Dialog.extend({
    initialize: function (options) {
        var buttonArray = [];
        if (options.editTasksRedirect) {
            buttonArray.push({
                id: 'editTasks',
                label: AJS.I18n.getText('deployment.project.environment.tasks.edit'),
                type: 'button'
            });
        }
        buttonArray.push(
            {
                id: 'cancel',
                label: AJS.I18n.getText('global.buttons.close'),
                type: 'button'
            }
        );
        var settings = AJS.$.extend({
            buttons: buttonArray,
            header: AJS.I18n.getText('deployment.execute.preview.execution.tasks.title'),
            $triggerEl: AJS.$('#view-tasks'),
            width: 500,
            height: 300
        }, options || {});

        this.constructor.__super__.initialize.apply(this, [settings]);
    },

    onButtonClick: function (id) {
        if (id === 'editTasks') {
            window.location = this.settings.editTasksRedirect;
        } else if (id === 'cancel') {
            this.dialog.remove();
        }
    }
});