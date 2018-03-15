AJS.$.namespace('Bamboo.Widget.HelpDialog');

Bamboo.Widget.HelpDialog = Brace.View.extend({

    mixins: [BAMBOO.EventBusMixin],

    initialize: function () {
        AJS.InlineDialog(
            this.$el, this.$el.attr('id'),
            _.bind(this.onDialogShow, this), {
                hideDelay: null,
                offsetX: -60,
                arrowOffsetX: -7,
                width: 420
            }
        );
    },

    onDialogShow: function(content, trigger, showPopup) {
        content.css({'padding': '20px'})
            .html(this.$el.find('span:first').html());

        showPopup();
        return false;
    }
});