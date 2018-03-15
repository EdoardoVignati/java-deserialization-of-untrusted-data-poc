BAMBOO.PageVisibilityManager = (function ($) {
    var
            visibilityStatePropertyName, visibilityChangeEventName,
            HIDDEN = "hidden", VISIBLE = "visible", atlvisibilitychange = "atlvisibilitychange";

    function setVisibilityValue(value) {
        $(document).attr("atlHidden", value);
    }

    if (typeof document.hidden !== "undefined") {
        visibilityChangeEventName = "visibilitychange";
        visibilityStatePropertyName = "visibilityState";
    } else if (typeof document.mozHidden !== "undefined") {
        visibilityChangeEventName = "mozvisibilitychange";
        visibilityStatePropertyName = "mozVisibilityState";
    } else if (typeof document.msHidden !== "undefined") {
        visibilityChangeEventName = "msvisibilitychange";
        visibilityStatePropertyName = "msVisibilityState";
    } else if (typeof document.webkitHidden !== "undefined") {
        visibilityChangeEventName = "webkitvisibilitychange";
        visibilityStatePropertyName = "webkitVisibilityState";
    } else {
        visibilityChangeEventName = atlvisibilitychange;
        visibilityStatePropertyName = "atlVisibilityState";
        if ( document.createEvent ) {
            var event = document.createEvent("Event");
            event.initEvent(visibilityChangeEventName, false, false);
            $(window).focus(function() {
                setVisibilityValue(VISIBLE);
                document.dispatchEvent(event);
            });

            $(window).blur(function() {
                setVisibilityValue(HIDDEN);
                document.dispatchEvent(event);
            });
        }
    }

    var syncAtlHiddenValue = function() {
        setVisibilityValue(document[visibilityStatePropertyName]);
    };
    if (visibilityChangeEventName != atlvisibilitychange) {
        syncAtlHiddenValue();
        $(document).on(visibilityChangeEventName, syncAtlHiddenValue);
    } else {
        if (document.hasFocus) {
            setVisibilityValue(document.hasFocus() ? VISIBLE : HIDDEN);
        } else {
            setVisibilityValue(VISIBLE);
        }
    }

    return {
        HIDDEN: HIDDEN,
        VISIBLE: VISIBLE,
        isPageVisible: function() {
            return $(document).attr("atlHidden")==VISIBLE;
        },
        addVisibilityChangeEventListener: function(handler) {
            $(document).on(visibilityChangeEventName, handler);
        }
    }
})(AJS.$);
