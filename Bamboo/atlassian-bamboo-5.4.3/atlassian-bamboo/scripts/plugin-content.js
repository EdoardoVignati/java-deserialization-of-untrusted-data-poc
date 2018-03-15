(function ($) {
    var BAMBOO = window.BAMBOO || {};
    BAMBOO.AGGREGATE_PLUGIN_CONTENT = {};
    BAMBOO.AGGREGATE_PLUGIN_CONTENT.loadPluginContent = (function () {
        var opts = {
            pluginUrl: null,
            jobKeySelector: null,
            contentSelector: null
        },
        $content,
        $jobDropdown,
        update = function () {
            var jobKey = $jobDropdown.val(),
                buildUrl = AJS.template(opts.pluginUrl).fill({ buildKey: jobKey, planKey: jobKey }).toString(),
                $tabsContainer = $('.aui-tabs.aui-tabs-disabled').addClass('loading');

            $.ajax({
                cache: false,
                url: buildUrl,
                beforeSend: function (jqXHR) {
                    jqXHR.setRequestHeader('X-No-Decorate', true);
                },
                success: function (data, textStatus, jqXHR) {
                    // If no data is returned, or an entire web page, go directly to that page for normal error handling
                    if (!$.trim(data) || /<html/i.test(data)) {
                        return window.location = this.url;
                    }
                    $content.html(data);
                    $tabsContainer.removeClass('loading');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (textStatus != 'abort') {
                        return window.location = this.url;
                    }
                }
            });
        };

        return {
            init: function (options) {
                opts = $.extend(true, options);

                $(function () {
                    $content = $(opts.contentSelector);
                    $jobDropdown = $(opts.jobKeySelector).change(update);
                    update();
                });
            }
        }
    })();
})(jQuery);
