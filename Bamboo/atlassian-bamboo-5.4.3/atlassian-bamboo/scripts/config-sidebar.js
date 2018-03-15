BAMBOO.ConfigSidebar = (function ($) {
    var classes = {
            animating: "animating",
            collapsed: "collapsed",
            expanded: "expanded",
            icons: {
                collapse: "icon-collapse",
                expand: "icon-expand"
            }
        },
        toggleState = function (shouldExpand) {
            var $h2 = $(this),
                $icon = $h2.children(".icon").addClass(classes.animating),
                $listOrMessage = $h2.next();

            $listOrMessage[shouldExpand ? "slideDown" : "slideUp"](function () {
                $h2.removeClass(shouldExpand ? classes.collapsed : classes.expanded).addClass(shouldExpand ? classes.expanded : classes.collapsed);
                $icon
                    .removeClass(classes.animating)
                    .removeClass(shouldExpand ? classes.icons.expand : classes.icons.collapse)
                    .addClass(shouldExpand ? classes.icons.collapse : classes.icons.expand);
                AJS.Cookie.save("config.sidebar." + $h2.data("sidebarSection") + ".expanded", shouldExpand, 365);
            });
        };

    return {
        init: function () {
            $(function () {
                var $configSidebar = $("#config-sidebar")
                    .delegate("." + classes.collapsed, "click", function () { toggleState.call(this, true); })
                    .delegate("." + classes.expanded, "click", function () { toggleState.call(this, false); });

                $configSidebar.find("ul a").each(function () {
                    var $a = $(this);

                    if ($a.isClipped() && !$a.attr("title")) {
                        $a.attr("title", $a.text());
                    }
                });
                $configSidebar.children("." + classes.collapsed).each(function () {
                    $(this).next().hide();
                });
            });
        }
    };
})(AJS.$);
