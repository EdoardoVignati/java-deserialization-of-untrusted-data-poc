BAMBOO.FilterProjectSelect = Backbone.View.extend({
    initialize: function (options) {
        this.projectSelect = new BAMBOO.ProjectSingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: 10
        });
        this.projectSelect.on('selected', this.handleSelection, this);

        this.selectedProjects = new BAMBOO.SelectedList({
            el: options.selectedPlansEl,
            bootstrap: options.bootstrap || [],
            itemTemplate: bamboo.widget.autocomplete.projectFilter.item
        });
    },
    handleSelection: function (model) {
        this.selectedProjects.addItem(model);
        this.projectSelect.singleSelect.setValue('');
    }
});