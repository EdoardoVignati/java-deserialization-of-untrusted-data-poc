AJS.ResultSet = Backbone.Model.extend({
    initialize: function(options) {
        this.set('active', null, {silent: true});
        this.collection = new Backbone.Collection();
        this.collection.bind('reset', this.setActive, this);
        this.source = options.source;
        this.source.bind('respond', this.process, this);
    },

    url: false,

    process: function(response) {
        this.set('query', response.query);
        this.collection.reset(response.results);
        this.set('length', response.results.length);
        this.trigger('update', this);
    },

    setActive: function() {
        var id = (arguments[0] instanceof Backbone.Collection) ? false : arguments[0];
        var model = (id) ? this.collection.get(id) : this.collection.first();
        this.set('active', model || null);
        return this.get('active');
    },

    next: function() {
        var current = this.collection.indexOf(this.get('active'));
        var i = (current + 1) % this.get('length');
        var next = this.collection.at(i);
        return this.setActive(next && next.id);
    },

    prev: function() {
        var current = this.collection.indexOf(this.get('active'));
        var i = ((current === 0) ? this.get('length') : current) - 1;
        var prev = this.collection.at(i);
        return this.setActive(prev && prev.id);
    },

    each: function() {
        return this.collection.each.apply(this.collection, arguments);
    }
});

AJS.ResultsList = Backbone.View.extend({
    events: {
        "click [data-id]": "setSelection"
    },

    initialize: function (options) {
        if (!this.model) {
            this.model = new AJS.ResultSet({ source: options.source });
        }
        if (!(this.model instanceof AJS.ResultSet)) {
            throw new Error('model must be set to a ResultSet');
        }
        this.model.bind('update', this.process, this);

        this.render = _.wrap(this.render, function(func) {
            this.trigger('rendering');
            func.apply(this, arguments);
            this.trigger('rendered');
        });
    },

    process: function() {
        if (!this._shouldShow(this.model.get('query'))) return;
        this.show();
    },

    render: function() {
        var ul, listItems = [];
        this.model.each(function(model) {
            var li = Backbone.$('<li/>').attr('data-id', model.id).html(this.renderItem(model));
            listItems.push(li);
        }, this);
        ul = Backbone.$('<ul/>').html(listItems);
        this.$el.html(ul);
        return this;
    },

    renderItem: function() {
        return;
    },

    setSelection: function(event) {
        var id = Backbone.$(event.target).closest('li[data-id]').data("id");
        var selected = this.model.setActive(id);
        this.trigger('selected', selected);
    },

    show: function() {
        this.lastQuery = this.model.get('query');
        this._hiddenQuery = null;
        this.render();
        this.$el.show();
        this.trigger('shown');
    },

    hide: function() {
        this.$el.hide();
        this._hiddenQuery = this.lastQuery;
        this.trigger('hidden');
    },

    size: function() {
        return this.model.get('length');
    },

    _shouldShow: function(query) {
        return query === '' || !(this._hiddenQuery && this._hiddenQuery === query);
    }

});