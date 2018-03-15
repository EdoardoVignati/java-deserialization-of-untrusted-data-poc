(function ($) {
    $.fn.reloadImage = function (options) {
        var defaults = {
            text: "Reload image",
            cssClass: "image-reload"
        };
        var opts = $.extend(defaults, options);

        return this.each(function () {
            var $this = $(this);
            $('<span class="' + opts.cssClass + '" title="' + opts.text + '" />').insertAfter($this).click(function (e) {
                var src = $this.attr("src"),
                    pos = src.indexOf("?"),
                    date = new Date();
                if (pos >= 0) {
                    src = src.substr(0, pos);
                }
                $this.attr("src", src + "?v=" + date.getTime());
                e.preventDefault();
            });
        });
    }
})(jQuery);
