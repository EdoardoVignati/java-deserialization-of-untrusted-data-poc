AJS.$.namespace('Bamboo.Feature.BranchLabel');

Bamboo.Feature.BranchLabel = Brace.View.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function () {
        this.onEvent('plan:selected', this.onPlanChange);
    },

    onPlanChange: function(instance, model) {
        if (model instanceof Backbone.Model) {
            this.$el.html(bamboo.widget.deployment.version.branch({
                planBranchName: model.get('branchName'),
                label: AJS.I18n.getText('deployment.trigger.branch.selection.option.INHERITED.label')
            }));
        }
    }

});