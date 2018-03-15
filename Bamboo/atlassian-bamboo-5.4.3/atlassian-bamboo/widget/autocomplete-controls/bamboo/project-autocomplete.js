BAMBOO.ProjectSingleSelect = Backbone.View.extend({
    initialize: function (options) {
        options || (options = {});
        this.singleSelect = new BAMBOO.SingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: options.maxResults || 5,
            matcher: _.bind(this.matcher, this),
            parser: this.parser,
            resultItemTemplate: bamboo.widget.autocomplete.projectItemResult,
            queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/projects',
            queryParamKey: 'searchTerm'
        });
        this.singleSelect.on('selected', this.handleSelection, this);
    },
    containsMatch: function (str, find) {
        return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
    },
    matcher: function (plan, query) {
        var matches = false;
        matches = matches || this.containsMatch(plan.get("projectName"), query);
        return matches;
    },
    parser: function (response) {
        return _.map(response.searchResults, function (result) {
            return result.searchEntity;
        });
    },
    handleSelection: function (model) {
        this.trigger('selected', model);
    }
});