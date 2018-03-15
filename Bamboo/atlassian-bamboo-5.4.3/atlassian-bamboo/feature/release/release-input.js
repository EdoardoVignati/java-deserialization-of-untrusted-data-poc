AJS.$.namespace('Bamboo.Feature.ReleaseInput');

Bamboo.Feature.ReleaseInput = Brace.View.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function (options) {
        this.params = null;
        this.data = null;

        this.$el.on('keyup', _.bind(_.debounce(
            this.onContentChange, 320 || options.timeout
        ), this));

        this.settings = {
            masterPickerId: options.masterPickerId
        };

        this.$icon = AJS.$(bamboo.feature.release.input.icon());
        this.$el.parent().append(this.$icon);

        this.dialog = AJS.InlineDialog(
            this.$icon, this.$icon.attr('id'),
            _.bind(this.onDialogShow, this), {
                hideDelay: null,
                offsetX: -60,
                arrowOffsetX: -7,
                width: 420
            }
        );

        this.model = new Bamboo.Feature.ReleaseInputModel(options.params);

        this.onEvent('build:change', this.onMasterChange);
        this.onEvent('build:change:initial', this.onMasterChangeInitial);
        this.onEvent('build:hide', this.onHide);
        this.onEvent('build:show', this.onShow);
    },

    onContentChange: function() {
        this.triggerEvent('release:change');
    },

    onMasterChange: function(instance) {
        if (
            this.settings.masterPickerId &&
            instance.$el.attr('id') !== this.settings.masterPickerId
        ) {
            return;
        }

        this.data = null;
        this.params = null;
        this.$el.val('');

        if (instance.$el.val()) {
            this.params = {
                resultKey: instance.$el.val()
            };

            this.loadData(_.bind(function() {
                this.$el.val(this.data.nextVersionName);
                this.onContentChange();
            }, this));
        }
    },

    onMasterChangeInitial: function (instance) {
        if (
            this.settings.masterPickerId &&
            instance.$el.attr('id') !== this.settings.masterPickerId
        ) {
            return;
        }

        if (instance.$el.val()) {
            this.params = {
                resultKey: instance.$el.val()
            };

            this.loadData();
        }
    },

    onDialogShow: function (content, trigger, showPopup) {
        content.css({'padding': '20px'});

        var handler = _.bind(function() {
            content.html(bamboo.feature.release.input.content({
                item: this.data
            }));

            showPopup();
        }, this);

        if (this.data) {
            handler();
        }
        else {
            this.loadData(handler);
        }

        return false;
    },

    onHide: function (instance, container) {
        if (!container || container.find(this.$el).length) {
            this.$el.parents('.field-group:first').hide();
        }
    },

    onShow: function (instance, container) {
        if (!container || container.find(this.$el).length) {
            this.$el.parents('.field-group:first').show();
        }
    },

    loadData: function(callback) {
        if (this.params) {
            this.model.fetch({
                data: this.params,
                error: Bamboo.Util.ErrorHandler,
                success: _.bind(function(instance, data) {
                    this.data = this.model.toJSON();

                    if (callback) {
                        callback();
                    }
                }, this)
            });
        }
        else if (callback) {
            callback();
        }
    }

});

Bamboo.Feature.ReleaseInputModel = Backbone.Model.extend({

    url: [
        BAMBOO.contextPath,
        'rest/api/latest/deploy/preview/versionName'
    ].join('/'),

    initialize: function(params) {
        this.initialParams = params || {};
    },

    fetch: function (options) {
        options.data = _.extend(
            this.initialParams,
            options.data
        );

        return Backbone.Model.prototype.fetch.call(this, options);
    }

});
