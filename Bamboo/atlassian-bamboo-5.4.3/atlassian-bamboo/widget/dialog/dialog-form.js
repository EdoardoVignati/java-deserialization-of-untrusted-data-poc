AJS.$.namespace('Bamboo.Widget.DialogForm');

Bamboo.Widget.DialogForm = Bamboo.Widget.Dialog.extend({

    initialize: function(options) {
        var settings = AJS.$.extend({
            templateContent: bamboo.widget.dialog.form.content,
            submitMode: 'ajax',
            buttons: [],
        }, options || {});

        Bamboo.Widget.Dialog.initialize.apply(this, [settings]);
    },

    onContentLoaded: function(content) {
        Bamboo.Widget.Dialog.onContentLoaded.apply(this, arguments);

        BAMBOO.asyncForm({
            success: _.bind(this.onFormSuccess, this),
            cancel: _.bind(this.onFormCancel, this),
            $delegator: this.$dialogContent,
            target: 'form'
        });
    },

    onFormSuccess: function(response) {
        window.location.reload(true);
    },

    onFormCancel: function(event) {
        this.dialog.remove();
    }

});
