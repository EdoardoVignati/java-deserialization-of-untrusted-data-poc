BAMBOO.UserSingleSelect = Backbone.View.extend({
    initialize: function (options) {
        options || (options = {});
        var SingleSelectWrapper = BAMBOO.SingleSelect.extend({
            getDisplayValue: this.getFilterValue,
            getIconValue: this.getIconValue
        });
        this.singleSelect = new SingleSelectWrapper({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: options.maxResults || 5,
            matcher: _.bind(this.matcher, this),
            parser: this.parser,
            resultItemTemplate: bamboo.widget.autocomplete.userItemResult,
            queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/users?includeAvatars=true',
            queryParamKey: 'searchTerm',
            allowEmptyQuery: false
        });
        this.singleSelect.on('selected', this.handleSelection, this);
    },
    lCasePrefixMatch: function (str, prefix) {
        return (str.toLowerCase().indexOf(prefix.toLowerCase()) === 0);
    },
    matcher: function (user, query) {
        var matches = false;
        matches = matches || this.lCasePrefixMatch(user.get('username'), query);
        if (user.has('fullName')) {
            matches = matches || this.lCasePrefixMatch(user.get('fullName'), query);
        }
        if (user.has('displayableEmail')) {
            matches = matches || this.lCasePrefixMatch(user.get('displayableEmail'), query);
        }
        return matches;
    },
    parser: function (response) {
        return _.map(response.searchResults, function (result) {
            return result.searchEntity;
        });
    },
    handleSelection: function (user) {
        this.trigger('selected', user);
    },
    getFilterValue: function (user) {
        return user.get('fullName');
    },
    getIconValue: function (user) {
        return user.get('avatarUrl');
    }
});