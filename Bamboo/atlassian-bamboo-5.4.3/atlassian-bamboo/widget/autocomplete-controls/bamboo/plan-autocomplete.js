BAMBOO.PlanSingleSelect = Brace.View.extend({
    mixins: [BAMBOO.EventBusMixin],
    initialize: function (options) {
        options || (options = {});

        var PlanSingleSelect = BAMBOO.SingleSelect.extend({
            getDisplayValue: this.getFilterValue
        });

        this.singleSelect = new PlanSingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: options.maxResults || 10,
            matcher: _.bind(this.matcher, this),
            parser: this.parser,
            resultItemTemplate: bamboo.widget.autocomplete.planItemResult,
            queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/plans',
            queryParamKey: 'searchTerm'
        });

        if (this.singleSelect.queryInput.val()) {
            this.singleSelect.requestMatchesQuietly(_.bind(function () {
                if (this.singleSelect.datasource.length) {
                    this.singleSelect.setValue(this.singleSelect.datasource.models[0]);
                }
            }, this));
        }

        this.onEvent('branch:empty', this.onHideBranchOptions);
        this.singleSelect.on('selected', this.onHandleSelection, this);
        this.singleSelect.queryInput.on('change', this.onHandleSelection, this);
    },
    containsMatch: function (str, find) {
        return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
    },
    matcher: function (plan, query) {
        return this.containsMatch(this.getFilterValue(plan), query);
    },
    parser: function (response) {
        return _.map(response.searchResults, function (result) {
            return result.searchEntity;
        });
    },
    getFilterValue: function (model) {
        // > character is not escaped for a reason
        return model.get('projectName') + ' › ' + model.get('planName');
    },
    onHandleSelection: function (model) {
        this.triggerEvent('plan:selected', model);

        if (model instanceof Backbone.Model) {
            this.$el.parents('.field-group').next().show();
        }
    },
    onHideBranchOptions: function() {
        this.$el.parents('.field-group').next().hide();
    }
});