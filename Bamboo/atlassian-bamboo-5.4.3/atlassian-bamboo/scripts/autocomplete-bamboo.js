AJS.$.namespace("BAMBOO.widget.autocomplete");


BAMBOO.widget.autocomplete.Variables = function(options) {

    // prototypial inheritance (http://javascript.crockford.com/prototypal.html)
    var that = begetObject(jira.widget.autocomplete.REST);

    that.getAjaxParams = function(){
        return {
            url: 'rest/api/latest/plan/%PLAN%?expand=variableContext'.replace('%PLAN%', that.planKey),
            data: options.ajaxData,
            dataType: "json",
            type: "GET"
        };
    };

    that.dispatcher = function(val) {
        var that = this,
            selectionRange = that.field.selectionRange(),
            parseValue = val.substring(0, selectionRange.start),
            match = parseValue.match(that.variableRegEx);
    };

    var defaults = {
        minQueryLength: 1,
        variableRegEx: /\$\{([a-z0-9\.]*)$/i
    };

    options = AJS.$.extend(true, defaults, options);
    that.init(options);

    return that;
};

BAMBOO.widget.autocomplete.Variables.init = function(parent) {
    AJS.$(".field-group .autocomplete-variables", parent).each(function() {
        var $item = AJS.$(this);
        BAMBOO.widget.autocomplete.Variables({
            field: $item,
            planKey: BAMBOO.currentPlan.key
        });
    })
};


AJS.$(document).bind("dialogContentReady", function(e, dialog){
    BAMBOO.widget.autocomplete.Variables.init(dialog.get$popupContent());
});

AJS.$(function(){
    BAMBOO.widget.autocomplete.Variables.init();
});
