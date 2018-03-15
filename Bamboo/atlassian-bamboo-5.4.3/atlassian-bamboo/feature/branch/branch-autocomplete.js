AJS.$.namespace('Bamboo.Feature.BranchAutocomplete');

Bamboo.Feature.BranchAutocomplete = Bamboo.Widget.AutocompleteAjax.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function(options) {
        options = AJS.$.extend({
            'placeholder': AJS.I18n.getText('deployment.project.plan.branch.placeholder')
        }, options || {});

        this.params = AJS.$.extend({
            'includeMasterBranch': false
        }, options.params || {});

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
                url: AJS.contextPath() + '/rest/api/latest/search/branches',
                dataType: 'json',
                data: dataCallback,
                results: _.bind(function(data, page) {
                    return this.processData({
                        results: data.searchResults,
                        more: data.size ? data.size > (page * this.params['max-results']) : false
                    });
                }, this)
            }
        };

        Bamboo.Widget.AutocompleteAjax.prototype.initialize.apply(
            this, [AJS.$.extend(settings, options || {})]
        );
    },

    onRegisterEvents: function() {
        this.onEvent('plan:selected', this.onMasterChange);
        this.proxyEvents('branch', ['change'], this.$el);
    },

    onInitSelection: function(element, callback) {
        AJS.$(document).ready(_.bind(function () {
            var key = AJS.$(element).val();

            if (_.isString(key) && key.length) {
                Bamboo.Util.Ajax(this.settings.ajax.url, {
                    dataType: this.settings.ajax.dataType,
                    data: {
                        'includeMasterBranch': true,
                        'masterPlanKey': key,
                        'start-index': 0,
                        'max-results': 1
                    }
                })
                .done(_.bind(function(data) {
                    var selected = data.searchResults[0];

                    this.$el.auiSelect2('data', selected);
                    this.processData({ results: data.searchResults });

                    this.triggerEvent('branch:change:initial');
                    callback(selected);
                }, this));
            }
        }, this));
    },

    onFormatResult: function (item) {
        if (!_.isEmpty(item)) {
            return bamboo.feature.branch.autocomplete.result({
                label: item.searchEntity.branchName
            });
        }
    },

    onFormatSelection: function (item) {
        if (!_.isEmpty(item)) {
            return bamboo.feature.branch.autocomplete.result({
                label: item.searchEntity.branchName
            });
        }
    },

    onMasterChange: function(instance, model) {
        if (
            this.settings.masterPickerId &&
            instance.$el.attr('id') !== this.settings.masterPickerId
        ) {
            return;
        }

        this.clearValue();

        if (!(model instanceof Backbone.Model)) {
            this.triggerEvent('branch:empty');
        }
        else {
            var value = AJS.$.trim(model.get('key'));

            if (value.length) {
                this.params.masterPlanKey = value;
            }
        }
    }

});