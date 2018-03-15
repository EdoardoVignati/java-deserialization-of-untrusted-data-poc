AJS.ProgressiveDataSet = Backbone.Collection.extend({
    initialize: function(models, options) {
        options || (options = {});
        if (options.matcher) this.matcher = options.matcher;
        if (options.model) this.model = options.model; // Fixed in backbone 0.9.2
        this._idAttribute = (new this.model()).idAttribute;
        this._maxResults = options.maxResults || 5;
        this._queryData = options.queryData || {};
        this._queryParamKey = options.queryParamKey || "q";
        this._queryEndpoint = options.queryEndpoint || "";
        this._allowEmptyQuery = (typeof options.allowEmptyQuery != 'undefined' ? options.allowEmptyQuery : false);
        this._matchAnyOnEmptyQuery = (typeof options.matchAnyOnEmptyQuery != 'undefined' ? options.matchAnyOnEmptyQuery : true);
        this.value = null;
        this.queryCache = {};
        this.activeQueryCount = 0;
        _.bindAll(this, 'query', 'respond');
    },

    url: function() {
        return this._queryEndpoint;
    },

    query: function(query) {
        var remote, results;

        this.value = query;
        results = this.getFilteredResults(query);
        this.respond(query, results);

        if (!this._queryEndpoint ||
            (query && (this.hasQueryCache(query) || !this.shouldGetMoreResults(results))) ||
            (!query && !(this._allowEmptyQuery && this.shouldGetMoreResults(results)))
            ) {
            return;
        }

        remote = this.fetch(query);

        this.activeQueryCount++;
        this.trigger('activity', { activity: true });
        remote.always(_.bind(function() {
            this.activeQueryCount--;
            this.trigger('activity', { activity: !!this.activeQueryCount });
        }, this));

        remote.done(_.bind(function(resp, succ, xhr) {
            this.addQueryCache(query, resp, xhr);
        }, this));
        remote.done(_.bind(function() {
            query = this.value;
            results = this.getFilteredResults(query);
            this.respond(query, results);
        }, this));
    },

    getQueryData: function(query) {
        var params = _.isFunction(this._queryData) ? this._queryData(query) : this._queryData;
        var data = _.extend({}, params);
        data[this._queryParamKey] = query;
        return data;
    },

    fetch: function(query) {
        var data = this.getQueryData(query);
        // {add: true} for Backbone <= 0.9.2
        // {update: true, remove: false} for Backbone >= 0.9.9
        var params = { add : true, update : true, remove : false, data : data };
        var remote = Backbone.Collection.prototype.fetch.call(this, params);
        return remote;
    },

    respond: function(query, results) {
        this.trigger('respond', {
            query: query,
            results: results
        });
        return results;
    },

    matcher: function(item, query) { },

    getFilteredResults: function(query) {
        var results = [];
        if (!query && !this._matchAnyOnEmptyQuery) return results;
        results = this.filter(function(item) {
            return (true == this.matcher(item, query) || !query && this._matchAnyOnEmptyQuery);
        }, this);
        if (this._maxResults) {
            results = _.first(results, this._maxResults);
        }
        return results;
    },

    addQueryCache: function(query, response, xhr) {
        var cache = this.queryCache;
        var results = this.parse(response, xhr);
        cache[query] = _.pluck(results, this._idAttribute);
    },

    hasQueryCache: function(query) {
        return this.queryCache.hasOwnProperty(query);
    },

    findQueryCache: function(query) {
        return this.queryCache[query];
    },

    shouldGetMoreResults: function(results) {
        return results.length < this._maxResults;
    },

    setMaxResults: function(number) {
        this._maxResults = number;
        this.value && this.respond(this.value, this.getFilteredResults(this.value));
    }
});