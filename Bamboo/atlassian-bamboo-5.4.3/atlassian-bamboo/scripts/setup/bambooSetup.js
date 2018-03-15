/**
 * Any href clicked with rel=help (e.g. our help bubbles) will open in new window.
 * Any element with id=addPlanLabel will trigger the edit labels dialog
 * Applies to all of Bamboo.
 **/
jQuery(document).delegate("a[rel~='help']", "click", function (e) {
    e.preventDefault();
    window.open(this.href);
});

// Not 100% sure what this stuff is for...

String.prototype.replaceAll = function(pcFrom, pcTo) {
    var MARKER = "js___bmbo_mrk",
        i = this.indexOf(pcFrom),
        c = this;

    while (i > -1) {
        c = c.replace(pcFrom, MARKER);
        i = c.indexOf(pcFrom);
    }

    i = c.indexOf(MARKER);
    while (i > -1) {
        c = c.replace(MARKER, pcTo);
        i = c.indexOf(MARKER);
    }

    return c;
};


if (!jQuery.generateId) {
  jQuery.generateId = function() {
    return arguments.callee.prefix + arguments.callee.count++;
  };
  jQuery.generateId.prefix = 'jq-';
  jQuery.generateId.count = 0;

  jQuery.fn.generateId = function() {
    return this.each(function() {
      this.id = jQuery.generateId();
    });
  };
}

(function (window) {
    window.BAMBOO = (window.BAMBOO || {});

    BAMBOO.SetupWait = (function ($) {
        var defaults = {
                refreshDelay: 2000,
                currentUrl: null,
                completedUrl: null,
                spinnerId: null
            },
            options,
            refreshStatus = function () {
                $.post(BAMBOO.contextPath + options.currentUrl, { "statusRequest": true }, onComplete, "json");
            },
            onComplete = function (data) {
                if (data.completed) {
                    if (options.completedUrl) {
                        window.location = BAMBOO.contextPath + options.completedUrl;
                    } else if (options.currentUrl) {
                        window.location = BAMBOO.contextPath + options.currentUrl;
                    } else {
                        window.location.reload(true);
                    }
                } else {
                    setTimeout(refreshStatus, options.refreshDelay);
                }
            };

        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);

                setTimeout(refreshStatus, options.refreshDelay);
                $(function () {
                    spinner(options.spinnerId, 40, 60, 12, 15, "#444");
                });
            }
        };
    })(jQuery);
})(window);