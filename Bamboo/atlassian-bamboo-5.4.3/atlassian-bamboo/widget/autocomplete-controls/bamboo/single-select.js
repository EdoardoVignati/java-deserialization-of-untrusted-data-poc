BAMBOO.SingleSelectResultView = AJS.ResultsList.extend({
    events: function () {
        // Required because Backbone doesn't easily support adding event to the event object when extending a View, it just replaces them
        return _.extend({}, AJS.ResultsList.prototype.events, {
            'hover [data-id]': 'setActive',
            'mouseenter': 'setContainerActive',
            'mouseleave': 'setContainerInactive'
        });
    },
    process: function () {
        if (!this.size() && !this.model.get('query')) {
            this.hide();
        } else {
            this.show();
        }
    },
    render: function() {
        var $ul = jQuery('<ul/>');
        if (this.size()) {
            this.model.each(function(model) {
                var $li = jQuery('<li/>', {
                    'data-id': model.id,
                    html: this.renderItem(model)
                });
                $li.attr('title', $li.text());
                $ul.append($li);
            }, this);
        } else {
            jQuery('<li/>', {
                'class': 'autocomplete-nomatch',
                text: AJS.I18n.getText('global.nomatches')
            }).appendTo($ul);
        }
        this.$el.html($ul);
        return this;
    },
    setActive: function (event) {
        var id = jQuery(event.target).closest('li[data-id]').data("id");
        this.model.setActive(id);
    },
    isContainerActive: function () {
        return !!this._containerActive;
    },
    setContainerActive: function () {
        this._containerActive = true;
    },
    setContainerInactive: function () {
        this._containerActive = false;
    }
});

BAMBOO.SingleSelectInputDropdown = Backbone.View.extend({
    initialize: function () {
        this.render();
    },
    _loadingClass: 'loading',
    tagName: 'span',
    className: 'icon bamboo-single-select-icon drop-menu',
    events: {
        'mouseenter': 'setActive',
        'mouseleave': 'setInactive'
    },
    render: function () {
        this.$el.html('<span>More</span>');
        return this;
    },
    isActive: function () {
        return !!this._active;
    },
    setActive: function () {
        this._active = true;
    },
    setInactive: function () {
        this._active = false;
    },
    setLoading: function (isLoading) {
        this.$el.toggleClass(this._loadingClass, isLoading);
    }
});

BAMBOO.SingleSelectField = Backbone.View.extend({
    initialize: function (options) {
        this.$original = options.$original;
        this.dropMenu = new BAMBOO.SingleSelectInputDropdown();
        this.$placeholder = jQuery('<input type="text" autocomplete="off" class="bamboo-single-select-field text" />');
        this.render();
    },
    _hasIconClass: 'bamboo-single-select-has-entity-icon',
    render: function () {
        this.$el.removeClass('text'); // remove AUI field class names
        this.dropMenu.$el.appendTo(this.$el);
        this.$placeholder
            .attr('placeholder', this.$original.attr('placeholder') || '')
            .val(this.$original.attr('data-field-text') || this.$original.val())
            .prependTo(this.$el);
        this.setIcon(this.$original.attr('data-icon'));
        jQuery('label').filter('[for="' + this.$original.attr('id') + '"]').click(_.bind(function () {
            this.$placeholder.focus();
        }, this));

        return this;
    },
    addDropMenuEvents: function (events) {
        this.dropMenu.delegateEvents(_.extend(BAMBOO.SingleSelectInputDropdown.prototype.events, events));
    },
    indicateActivity: function (ds) {
        this.dropMenu.setLoading(ds.activity);
    },
    setIcon: function (iconUrl) {
        this.$icon = this.$icon || jQuery('<div />', { 'class': 'bamboo-single-select-entity-icon' });
        if (iconUrl) {
            this.$icon.css('background-image', 'url(' + iconUrl + ')').appendTo(this.$el);
            this.$el.addClass(this._hasIconClass);
        } else {
            this.$icon.detach();
            this.$el.removeClass(this._hasIconClass);
        }
    }
});

BAMBOO.SingleSelect = Backbone.View.extend({
    initialize: function (options) {
        this._chosen = !!this.$el.data('chosen');
        this._activeClass = options.activeClass || 'active';
        this.datasource = new AJS.ProgressiveDataSet(options.bootstrap || [], {
            queryEndpoint: options.queryEndpoint,
            queryParamKey: options.queryParamKey,
            maxResults: options.maxResults,
            allowEmptyQuery: (typeof options.allowEmptyQuery != 'undefined' ? options.allowEmptyQuery : true),
            matchAnyOnEmptyQuery: options.matchAnyOnEmptyQuery,
            queryData: options.queryData
        });
        this.datasource.matcher = options.matcher;
        this.datasource.parse = options.parser;

        this.field = new BAMBOO.SingleSelectField({
            className: 'bamboo-single-select ' + this.$el.attr('class'),
            $original: this.$el
        });

        this.queryInput = new AJS.QueryInput({ el: this.field.$placeholder });
        this.queryInput
            .on('change', this.datasource.query)
            .on('change', this.handleInputChange, this)
            .delegateEvents(_.extend(AJS.QueryInput.prototype.events || {}, {
                'keydown': _.bind(this.handleInputKeydown, this),
                'blur': _.bind(this.handleInputBlur, this),
                'focus': _.bind(this.handleInputFocus, this),
                'click': _.bind(this.requestMatches, this)
            }));

        var singleSelect = this;

        var ResultView = BAMBOO.SingleSelectResultView.extend({
            renderItem: function (model) {
                return options.resultItemTemplate(model.attributes);
            },
            process: function() {
                if (!singleSelect.disableRendering)
                {
                    BAMBOO.SingleSelectResultView.prototype.process.call(this);
                }
                singleSelect.disableRendering = false;
            }
        });

        this.field.addDropMenuEvents({
            'click': _.bind(function () {
                this.queryInput.$el.focus();
                if (this.queryResult.$el.is(':visible')) {
                    this.queryResult.hide();
                } else {
                    this.requestMatches();
                }
            }, this)
        });

        this.datasource.on('activity', this.field.indicateActivity, this.field);

        this.queryResult = new ResultView({ source: this.datasource });
        this.queryResult
            .on('selected', this.setValue, this)
            .on('rendered', this.highlightActive, this)
            .on('shown', this.indicateActive, this)
            .on('hidden', this.indicateInactive, this)
            .model.on('change:active', this.highlightActive, this);

        this.render();
    },
    render: function () {
        this.field.$el.insertBefore(this.$el.hide());
        this.queryResult.hide();
        this.queryResult.$el.addClass('autocomplete').appendTo(document.body);

        return this;
    },
    highlightActive: function () {
        var active = this.queryResult.model.get('active');
        var id = active && active.id;
        this.queryResult.$('li[data-id]').filter(function (i, li) {
            var $li = jQuery(li);
            var method = (id == $li.attr('data-id')) ? 'addClass' : 'removeClass';
            $li[method]('active');
        });
    },
    reset: function() {
        this.datasource.reset();
        this.setValue(null);
        this.trigger('reset');
    },
    setValue: function (model) {
        this.$el.val(model ? model.id : '');
        this.queryInput.val(model ? this.getDisplayValue(model) : '');
        this.field.setIcon(model ? this.getIconValue(model) : null);
        this.queryResult.hide();
        if (model) {
            this.queryInput.$el.focus();
            this._chosen = true;
            this.trigger('selected', model);
        } else {
            this._chosen = false;
        }
        // QueryResult and dropmenu being active prevents blurring the field, so ensure we set them inactive if an option is chosen to allow taking focus from field
        this.queryResult.setContainerInactive();
        this.field.dropMenu.setInactive();
    },
    getDisplayValue: function (model) {
        return model.id;
    },
    getIconValue: function () {
        return null;
    },
    indicateActive: function () {
        this.queryInput.$el.addClass(this._activeClass);
    },
    indicateInactive: function () {
        this.queryInput.$el.removeClass(this._activeClass);
    },
    requestMatchesQuietly: function (callback) {
        this.requestMatches();

        this.datasource.once('sync',
                _.bind(function()
                {
                    callback();
                    this.disableRendering = true;
                }, this));
    },
    requestMatches: function () {
        this.datasource.query(this._chosen ? '' : this.queryInput.val());
    },
    handleInputKeydown: function (e) {
        var active;
        if (this.queryResult.$el.is(':visible')) {
            switch (e.which) {
                case jQuery.ui.keyCode.UP:
                    e.preventDefault();
                    this.queryResult.model.prev();
                    break;
                case jQuery.ui.keyCode.DOWN:
                    e.preventDefault();
                    this.queryResult.model.next();
                    break;
                case jQuery.ui.keyCode.ENTER:
                case jQuery.ui.keyCode.TAB:
                    e.preventDefault();
                    active = this.queryResult.model.get('active');
                    if (active) {
                        this.queryResult.trigger('selected', active);
                    }
                    break;
                case jQuery.ui.keyCode.ESCAPE:
                    e.stopPropagation();
                    this.queryResult.hide();
                    break;
            }
        } else if (e.which == jQuery.ui.keyCode.DOWN) {
            this.requestMatches();
        }
    },
    handleInputBlur: function () {
        if (this.field.dropMenu.isActive() || this.queryResult.isContainerActive()) {
            this.queryInput.$el.focus();
        } else {
            if (this.queryResult.$el.is(':visible')) {
                this.queryResult.hide();
            }
        }
    },
    handleInputFocus: function () {
        var $input = this.queryInput.$el;
        var inputOffset = $input.offset();
        var inputWidth = $input.outerWidth();
        var inputHeight = $input.outerHeight();
        this.queryResult.$el.css({
            width: inputWidth,
            top: inputOffset.top + inputHeight,
            left: inputOffset.left
        });
        // setTimeout will fire after user has clicked in field to give it focus, ensures text is always selected on focus
        setTimeout(function () {
            $input.select();
        });
    },
    handleInputChange: function () {
        this.$el.val(this.queryInput.val());
        this.field.setIcon(null);
        this._chosen = false;
    }
});