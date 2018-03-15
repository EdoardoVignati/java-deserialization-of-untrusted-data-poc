AJS.$.namespace('Bamboo.Widget.Autocomplete');

Bamboo.Widget.Autocomplete = Brace.View.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function(options) {
        this.data = [];

        options.initialValue = AJS.$.parseJSON(
            options.initialValue || null
        );

        if (this.$el.val() && this.onInitSelection) {
            options.initSelection = _.bind(this.onInitSelection, this);
        }

        this.settings = AJS.$.extend({
            escapeMarkup: function (m) { return m; },
            placeholder: ' '
        }, options || {});

        if (!this.$el.val()) {
            if (!options.initialValue && options.loadAndProcess && this.onLoadAndProcess) {
                this.settings.initSelection = _.bind(this.onLoadAndProcess, this);
                this.$el.val('__LOADING__');
            }
        }

        this.$el.auiSelect2(this.settings);
        this.$el.on('change', _.bind(function() {
            AJS.$('#select2-drop-mask').hide();

            this.$el.auiSelect2('dropdown').hide();
            this.$el.auiSelect2('container')
                .removeClass('select2-dropdown-open')
                .removeClass('select2-container-active');
        }, this));

        this.onRegisterEvents();
    },

    onRegisterEvents: function() {
        this.proxyEvents('select',
            ['change', 'select2-open', 'select2-blur'],
            this.$el
        );
    },

    getContainer: function() {
        return this.$el.auiSelect2('container');
    },

    getSelectedData: function(callback) {
        var selected = this.$el.auiSelect2('data');

        if (!selected) {
            selected = _.find(this.data.results, _.bind(callback || function (item) {
                return item.id === this.$el.val();
            }, this));
        }

        return selected;
    },

    clearValue: function () {
        this.$el.auiSelect2('data', null);
    },

    processData: function(data) {
        this.data = data;
        return this.data;
    },

    disable: function() {
        this.$el.auiSelect2("enable", false);
    },

    enable: function() {
        this.$el.auiSelect2("enable", true);
    }

});
