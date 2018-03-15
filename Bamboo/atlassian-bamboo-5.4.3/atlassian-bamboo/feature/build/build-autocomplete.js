AJS.$.namespace('Bamboo.Feature.BuildAutocomplete');

Bamboo.Feature.BuildAutocomplete = Bamboo.Widget.AutocompleteAjax.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function(options) {
        options = AJS.$.extend({
            // disable/hide search input
            'minimumResultsForSearch': -1
        }, options || {});

        this.params = options.params || {};

        if (options.params) {
            delete options.params;
        }

        var dataCallback = _.bind(function (term, page) {
            return AJS.$.extend({
                'searchTerm': term,
                'start-index': Math.max(
                    (page - 1) * this.params['max-results'], 0
                )
            }, this.params);
        }, this);

        var settings = {
            minimumInputLength: 0,
            ajax: {
                url: AJS.contextPath() + '/rest/api/latest/deploy/preview/possibleResults',
                dataType: 'json',
                data: dataCallback,
                results: _.bind(function (data, page) {
                    return this.processData({
                        results: data,
                        more: data ? data.length >= this.params['max-results'] : false
                    });
                }, this)
            },
            id: function (object) {
                return object.planResultKey.key;
            }
        };

        Bamboo.Widget.AutocompleteAjax.prototype.initialize.apply(
            this, [AJS.$.extend(settings, options || {})]
        );
    },

    onRegisterEvents: function() {
        this.proxyEvents(
            'build', ['change'], this.$el
        );

        var events = ['branch:change'];

        if (!this.$el.val()) {
            events.push('branch:change:initial');
        }

        this.onEvent(events, this.onMasterChange);
        this.onEvent('build:hide', this.onHide);
        this.onEvent('build:show', this.onShow);
    },

    onInitSelection: function (element, callback) {
        AJS.$(document).ready(_.bind(function() {
            var key = AJS.$(element).val();

            if (_.isString(key) && key.length) {
                this.$el.auiSelect2('data', this.settings.initialValue);
                this.processData({ results: [ this.settings.initialValue ] });

                this.params.planKey = this.settings.initialValue
                    .planResultKey.entityKey.key;

                this.triggerEvent('build:change:initial');
                callback(this.settings.initialValue);
            }
        }, this));
    },

    onLoadAndProcess: function (element, callback) {
        var settings = _.defaults({
            data: this.settings.ajax.data('', 1)
        }, this.settings.ajax);

        Bamboo.Util.Ajax(settings)
            .done(_.bind(function (data) {
                if (_.isEmpty(data)) {
                    this.$el.val(null);
                    this.$el.auiSelect2('data', null);
                    this.params.planKey = null;
                }
                else {
                    var selected = data[0];

                    this.$el.val(this.settings.id(selected));
                    this.$el.auiSelect2('data', selected);

                    this.processData({
                        results: data,
                        more: data ? data.length >= this.params['max-results'] : false
                    });

                    this.params.planKey = selected
                        .planResultKey.entityKey.key;

                    if (callback) {
                        callback(selected);
                    }
                }

                this.triggerEvent('build:change');
                this.triggerEvent('deploy:release:warning');
            }, this));
    },

    onFormatResult: function(item) {
        if (!_.isEmpty(item)) {
            return bamboo.feature.build.autocomplete.result({
                resultSummary: item
            });
        }
    },

    onFormatSelection: function(item) {
        if (!_.isEmpty(item)) {
            return bamboo.feature.build.autocomplete.selection({
                resultSummary: item
            });
        }
    },

    onMasterChange: function(instance) {
        if (
            !this.settings.masterPickerId ||
            instance.$el.attr('id') !== this.settings.masterPickerId
        ) {
            return;
        }

        this.clearValue();
        var value = instance.getSelectedData();

        if (value) {
            this.params.planKey = value.searchEntity.key;
            this.onLoadAndProcess();
            this.enable();
        }
        else {
            this.disable();
        }
    },

    onHide: function(instance, container) {
        if (!container || container.find(this.$el).length) {
            this.$el.parents('.field-group:first').hide();
        }
    },

    onShow: function (instance, container) {
        if (!container || container.find(this.$el).length) {
            this.$el.parents('.field-group:first').show();
        }
    }

});