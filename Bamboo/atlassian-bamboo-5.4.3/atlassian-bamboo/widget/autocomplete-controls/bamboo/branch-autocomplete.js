BAMBOO.BranchSingleSelect = Brace.View.extend({
    mixins: [BAMBOO.EventBusMixin],
    initialize: function (options) {
        options || (options = {});

        var BranchSingleSelect = BAMBOO.SingleSelect.extend({
            getDisplayValue: this.getFilterValue
        });

        this.singleSelect = new BranchSingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: options.maxResults || 10,
            matcher: _.bind(this.matcher, this),
            parser: this.parser,
            resultItemTemplate: bamboo.widget.autocomplete.branchItemResult,
            queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/branches',
            queryParamKey: 'searchTerm',
            queryData: _.bind(this.generateAdditionalQueryData, this)
        });

        this.singleSelect.on('selected', this.handleSelection, this);
        this.singleSelect.queryInput.on('change', this.handleSelection, this);

        if (options.masterPlanKey) {
            this.masterPlanKey = options.masterPlanKey;
        }
        else if (options.masterPlanField) {
            this.masterPlanKey = options.masterPlanField.val();
        }
        else if (options.masterPlanPicker) {
            this.onEvent('plan:selected', this.onMasterPlanChange);
            this.masterPlanKey = options.masterPlanPicker.val();
        }

        if (!this.masterPlanKey) {
            this.singleSelect.$el.parent().hide();
        }
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
    handleSelection: function (model) {
        this.trigger('selected', model);
    },
    getFilterValue: function (model) {
        return model.get('branchName');
    },
    generateAdditionalQueryData: function () {
        return { masterPlanKey: this.masterPlanKey, includeMasterBranch: this.options.includeMasterBranch };
    },
    onMasterPlanChange: function(masterModel) {
        this.singleSelect.reset();

        if (!(masterModel instanceof Backbone.Model)) {
            this.singleSelect.$el.parent().hide();
        }
        else {
            this.singleSelect.$el.parent().filter(":hidden").show();
            this.masterPlanKey = masterModel.get('key');

            var branchPickerContainer = this.options.branchPickerContainer;

            if (branchPickerContainer) {
                this.singleSelect.requestMatchesQuietly(_.bind(function() {
                    var numberOfBranches = this.singleSelect.datasource.length;
                    if (this.options.includeMasterBranch) numberOfBranches--;
                    if (numberOfBranches) {
                        branchPickerContainer.show();

                        // select master branch
                        if (this.options.includeMasterBranch) {
                            this.singleSelect.setValue(this.singleSelect.datasource.models[0]);
                        }
                    } else {
                        branchPickerContainer.hide();
                    }
                }, this));
            }
        }
    }
});