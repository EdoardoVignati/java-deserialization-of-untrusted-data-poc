BAMBOO.VersionSingleSelect = Brace.View.extend({
    mixins: [BAMBOO.EventBusMixin],
    initialize: function (options) {
        options || (options = {});

        this.deploymentProjectId = options.deploymentProjectId;
        this.branchKey = options.branchKey;
        this.singleSelect = new BAMBOO.SingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: options.maxResults || 5,
            matcher: _.bind(this.matcher, this),
            parser: this.parser,
            resultItemTemplate: bamboo.feature.version.autocomplete.versionItemResult,
            queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/versions',
            queryParamKey: 'searchTerm',
            queryData: _.bind(this.generateAdditionalQueryData, this)
        });

        this.singleSelect.on('reset', this.handleReset, this);
        this.singleSelect.on('selected', this.handleSelection, this);
        this.singleSelect.queryInput.on('change', this.handleSelection, this);

        if (options.branchPicker) {
            this.onEvent('branch:change', this.onBranchChange, this);
        }
    },
    containsMatch: function (str, find) {
        return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
    },
    matcher: function (version, query) {
        var matches = false;
        matches = matches || this.containsMatch(version.get("name"), query);

        return matches;
    },
    parser: function (response) {
        return _.map(response.searchResults, function (result) {
            return result.searchEntity;
        });
    },
    handleReset: function () {
        this.trigger('reset');
    },
    handleSelection: function (model) {
        this.trigger('selected', model);
    },
    generateAdditionalQueryData: function () {
        var data = {
            deploymentProjectId: this.deploymentProjectId
        };

        if (this.options.branchPicker) {
            data.branchKey = this.options.branchPicker.val();
        } else if (this.branchKey) {
            data.branchKey = this.branchKey;
        }

        return data;
    },
    onBranchChange: function() {
        this.singleSelect.reset();
    }
});