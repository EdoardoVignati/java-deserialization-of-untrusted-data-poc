AJS.$.namespace('Bamboo.Util.Ajax');

Bamboo.Util.Ajax = function() {
    var url = null;
    var params = arguments[arguments.length - 1];

    if (_.isString(arguments[0])) {
        url = arguments[0];
    }

    if (!params.error) {
        params.error = Bamboo.Util.ErrorHandler;
    }

    if (url && params) {
        params.url = url;
    }

    return AJS.$.ajax(params);
};
