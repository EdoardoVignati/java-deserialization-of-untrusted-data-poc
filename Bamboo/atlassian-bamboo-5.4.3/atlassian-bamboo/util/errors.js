AJS.$.namespace('Bamboo.Util.ErrorHandler');

Bamboo.Util.ErrorHandler = function(jqXHR, textStatus, errorThrown) {
    var container = AJS.$('.aui-page-panel-content');

    if (!container.find('.ajax-error').length) {
        container.prepend(bamboo.util.errors.message());
    }
};
