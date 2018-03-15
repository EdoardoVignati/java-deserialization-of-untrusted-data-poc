AJS.$.namespace('Bamboo.Widget.Dialog');

Bamboo.Widget.Dialog = Brace.View.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function(options) {
        this.settings = AJS.$.extend({
            templateContent: bamboo.widget.dialog.content,
            keypressListener: _.bind(this.onKeyPress, this),
            height: 400,
            width: 800,
            buttons: [{
                id: 'cancel',
                label: AJS.I18n.getText('global.buttons.close'),
                type: 'link'
            }]
        }, options || {});

        if (this.settings.$triggerEl) {
            this.settings.$triggerEl.on('click', _.bind(function(event) {
                event.preventDefault();
                this.createInstance();
            }, this));
        }
        else {
            this.createInstance();
        }
    },

    createInstance: function() {
        this.dialog = new AJS.Dialog(this.settings);

        this.proxyEvents('dialog',
            ['show.dialog', 'hide.dialog', 'remove.dialog'],
            AJS, 'bind'
        );

        this.onCreateInstance();

        // hack to remove existing css class from button (in case we are providing own)
        _.each(this.dialog.getPage(0).button, function(element) {
            if (element.item.attr('class') !== 'button-panel-button') {
                element.item.removeClass('button-panel-button');
            }
        });

        this.dialog.show();
    },

    onCreateInstance: function() {
        this.$dialogContent = AJS.$(this.settings.templateContent({
            content: bamboo.widget.dialog.loading()
        }));

        this.dialog.addPanel('', this.$dialogContent);

        if (this.settings.header) {
            this.dialog.addHeader(this.settings.header);
        }
        else if (this.settings.$triggerEl) {
            this.dialog.addHeader(this.settings.$triggerEl.attr('title'));
        }

        if (this.settings.buttons) {
            _.each(this.settings.buttons, _.bind(function(button) {
                var handler = this.dialog.addButton;

                if (button.type === 'link') {
                    handler = this.dialog.addLink;
                }

                var buttonHandler = (button.callback) ?
                    button.callback : this.onButtonClick;

                var buttonParams = (button.params) ?
                   [button.id, button.params] : [button.id];

                handler.apply(this.dialog, [
                    button.label, _.bind(function () {
                        _.bind(buttonHandler, this).apply(this, buttonParams);
                    }, this), button.cssClass
                ]);
            }, this));
        }

        if (_.isString(this.settings.content)) {
            this.$dialogContent.empty().append(this.settings.content);
        }
        else if (_.isObject(this.settings.content)) {
            this.$dialogContent.empty().append(this.settings.content.removeClass('hidden'));
        }
        else if (this.settings.$triggerEl) {
            AJS.$.ajax({
                url: this.settings.$triggerEl.attr('href'),
                data: {
                    'bamboo.successReturnMode': 'json',
                    'decorator': 'nothing',
                    'confirm': true
                },
                cache: false
            }).done(_.bind(this.onContentLoaded, this));
        }
    },

    onContentLoaded: function(response) {
        this.$dialogContent.html(response);
    },

    onButtonClick: function(id) {
        if (id === 'cancel') {
            this.dialog.remove();
        }
    },

    onKeyPress: function(event) {
        if (event.which === jQuery.ui.keyCode.ESCAPE) {
            this.dialog.remove();
        }
    }

});