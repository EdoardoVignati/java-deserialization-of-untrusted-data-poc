BAMBOO.VariableMultiSelect = Backbone.View.extend({
    initialize: function (options) {
        this.variableSelect = new BAMBOO.VariableSingleSelect({
            el: this.$el,
            bootstrap: options.bootstrap || [],
            maxResults: 10
        });
        this.variableSelect.on('selected', this.handleSelection, this);

        this.selectedVariables = new BAMBOO.SelectedList({
            el: options.selectedVariablesEl,
            bootstrap: options.selectedVariables ? _.map(options.selectedVariables, function (variable) {
                return AJS.$.extend(true, variable, {id: variable.key});
            }) : [],
            itemTemplate: bamboo.widget.autocomplete.variableSelect.item
        });
    },
    handleSelection: function (model) {
        this.selectedVariables.addItem(model);
        this.variableSelect.singleSelect.setValue('');
    }
});