AJS.$.namespace('Bamboo.Widget.AutocompleteAjax');

Bamboo.Widget.AutocompleteAjax = Bamboo.Widget.Autocomplete.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function (options) {
        this.params = AJS.$.extend({
            'max-results': 10
        }, this.params || {});

        if (_.isFunction(this.onFormatSelection)) {
            options.formatSelection = _.bind(this.onFormatSelection, this);
        }

        if (_.isFunction(this.onFormatResult)) {
            options.formatResult = _.bind(this.onFormatResult, this);
        }

        if (_.isUndefined(options.cache) || !!options.cache) {
            options.ajax.quietMillis = options.ajax.quietMillis || 140;
            options.ajax.resultsCallback = options.ajax.results;
            options.ajax.results = null;

            options.query = _.debounce(
                _.bind(this.queryAjaxCache, this),
                options.ajax.quietMillis
            );

            if (!options.ajax.params) {
                options.ajax.params = {
                    error: _.bind(function(jqXHR, textStatus, errorThrown) {
                        this.$el.auiSelect2('close');
                        Bamboo.Util.ErrorHandler(
                            jqXHR, textStatus, errorThrown
                        );
                    }, this)
                };
            }
        }

        Bamboo.Widget.Autocomplete.prototype.initialize.apply(
            this, [ options || {} ]
        );
    },

    queryAjaxCache: function(query) {
        this.cache = this.cache || {
            initial: {},
            term: {}
        };

        var term = AJS.$.trim(query.term);

        query.key = JSON.stringify(
            this.settings.ajax.data(term, query.page || 1)
        );

        var cache = (term.length) ?
            this.cache.term[query.key] :
            this.cache.initial[query.key];

        if (!_.isEmpty(cache)) {
            query.callback(cache);
            return;
        }

        this.settings.ajax.results = _.bind(function (data, page) {
            var results = this.settings
                .ajax.resultsCallback(data, page);

            if (term) {
                this.cache.term[query.key] = results;
            }
            else {
                this.cache.initial[query.key] = results;
            }

            return results;
        }, this);

        window.Select2.query.ajax(AJS.$.extend({
            transport: Bamboo.Util.Ajax
        }, this.settings.ajax))(query);
    }

});