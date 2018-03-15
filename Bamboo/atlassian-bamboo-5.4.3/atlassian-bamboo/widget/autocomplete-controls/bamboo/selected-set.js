BAMBOO.SelectedSet = Backbone.Model.extend({
    initialize: function (options) {
        this.collection = new Backbone.Collection(options.bootstrap || []);
    },
    each: function () {
        return this.collection.each.apply(this.collection, arguments);
    },
    add: function (model) {
        this.collection.add(model);
    },
    remove: function (id) {
        this.collection.remove(this.collection.get(id));
    }
});
BAMBOO.SelectedList = Backbone.View.extend({
    events: {
        'click [data-id] .remove': 'removeItem'
    },
    initialize: function (options) {
        this.model = new BAMBOO.SelectedSet({ bootstrap: options.bootstrap || [] });
        this.options = options;
        if (this.model.collection.length) {
            this.render();
        }
    },
    render: function () {
        var listItems = [];
        this.model.each(function(model) {
            var li = Backbone.$('<li/>').attr('data-id', model.id).html(this.renderItem(model));
            listItems.push(li);
        }, this);
        this.$el.toggleClass('empty', (this.model.collection.length === 0)).html(listItems);
        return this;
    },
    renderItem: function (model) {
        return this.options.itemTemplate(model.attributes);
    },
    fadeout: function () {
        jQuery('.multi-select-added').animate({
             'background-color': 'transparent'
        }, 1500);
    },
    addItem: function (model) {
        this.model.add(model);
        this.render(model);
        this.fadeout();
    },
    removeItem: function (event) {
        var $item = jQuery(event.target).closest('[data-id]');
        this.model.remove($item.data("id"));
        $item.fadeOut(400, _.bind(function () {
          this.render();
        }, this));
    }

});
