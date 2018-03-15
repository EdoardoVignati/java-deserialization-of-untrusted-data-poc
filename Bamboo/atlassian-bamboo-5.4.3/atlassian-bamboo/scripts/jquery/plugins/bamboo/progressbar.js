/**
 * Progress Bar jQuery plugin
 *
 * Options:
 * - value  {number}    Default: 0
 *      The value of the progressBar.
 *      Can be set when initialising (first creating) the progressBar.
 *          eg. $(".selector").progressBar({ value: 40 });
 *      Get or set the value option after initialisation:
 *          //getter
 *          var value = $(".selector").progressBar("option", "value");
 *          //setter
 *          $(".selector").progressBar("option", "value", 40);
 *
 * - text   {string}    Default: &nbsp;
 *      The text shown in the progressBar.
 *      Can be set when initialising (first creating) the progressBar.
 *          eg. $(".selector").progressBar({ text: "40% complete" });
 *      Get or set the value option after initialisation:
 *          //getter
 *          var text = $(".selector").progressBar("option", "text");
 *          //setter
 *          $(".selector").progressBar("option", "text", "40% complete");
 *
 * Initialisation:
 * $("#myBar").progressBar();
 *
 * This will turn the target element (in this case <div id="myBar"></div>) into a progress bar using the
 * default options. If the HTML for the progress bar is already contained within the target element the plugin will
 * initialise by extracting the data from the HTML, which from then onward can be updated using the plugin methods.
 *
 * You could also pass an object as the first parameter containing your own options with which to initialise the
 * progress bar. eg. $("#myBar").progressBar({ value: 40, text: "40% complete" });
 *
 * Methods:
 * - progressBar("destroy")
 *      Removes any data and bindings that were added to the element by the plugin leaving just the HTML.
 *
 * - progressBar("option", optionName, [value])
 *      Get or set any progressBar option. If no value is specified, will act as a getter.
 *
 * - progressBar("option", [options])
 *      Get or set multiple progressBar options at once by providing an options object. If options is not specified,
 *      will act as a getter.
 * 
 */
(function ($) {
    $.fn.progressBar = function (options) {
        if (typeof options == "string") {
            if (options == "option") {
                if (arguments.length == 1) { // getter
                    var retArr = [];
                    this.each(function () {
                        retArr.push($(this).data("options"));
                    });
                    return retArr;
                } else if (arguments.length == 2 && typeof arguments[1] == "string") { // individual option getter
                    var ret,
                        opt = arguments[1];
                    this.each(function () {
                        var $el = $(this);
                        ret = (typeof ret == "undefined") ? $el.data("options")[opt] : ret + $el.data("options")[opt];
                    });
                    return ret;
                } else if (arguments.length == 2 && typeof arguments[1] == "object") { // option object setter
                    var newOpts = arguments[1];
                    if (typeof newOpts.text != "undefined" && (newOpts.text == null || newOpts.text == "")) {
                        newOpts.text = $.fn.progressBar.defaults.text;
                    }
                    return this.each(function () {
                        var $el = $(this);
                        $el.data("options", $.extend($el.data("options"), newOpts)).trigger("updateProgressBar");
                    });
                } else if (arguments.length == 3 && typeof arguments[1] == "string") { // individual option setter
                    var key = arguments[1],
                        newVal = arguments[2];
                    if (key == "text" && (newVal == null || newVal == "")) {
                        newVal = $.fn.progressBar.defaults.text;
                    }
                    return this.each(function () {
                        var $el = $(this);
                        var currentOptions = $el.data("options");
                        currentOptions[key] = newVal;
                        $el.data("options", currentOptions).trigger("updateProgressBar");
                    });
                }
            } else if (options == "destroy") {
                return this.each(function () {
                    $(this).removeData("options").removeData("bar").removeData("text").unbind("updateProgressBar");
                });
            }
        } else { // init
            if (typeof options != "undefined" && typeof options.text != "undefined" && (options.text == null || options.text == "")) {
                delete options.text;
            }
            var opts = $.extend({}, $.fn.progressBar.defaults, options);
            return this.each(function () {
                var $el = $(this);
                $el.bind("updateProgressBar", function (e) {
                    var $el = $(this),
                        options = $el.data("options");
                    $el.data("bar").width(Math.max(0, Math.min(100, options.value)) + "%");
                    $el.data("text").html(options.text);
                });
                if ($(".progress-bar, .progress-text", this).length == 2) { // check if HTML for progressBar already exists
                    var bar = $(".progress-bar", this),
                        text = $(".progress-text", this),
                        optsFromExisting = {};
                    if (typeof options == "undefined") {
                        var barWidth = bar.clone().width(), // clone the element so we're working with a detached element, then get the detached element's width which won't be in px, it'll be the proper percentage
                            barText = text.text();
                        optsFromExisting.value = barWidth;
                        if (barText != null && barText != "") {
                            optsFromExisting.text = barText;
                        }
                    }
                    $el.data("options", $.extend({}, opts, optsFromExisting))
                       .data("bar", bar)
                       .data("text", text)
                       .trigger("updateProgressBar");
                } else {
                    $el.empty()
                       .data("options", opts)
                       .data("bar", $('<div class="progress-bar" style="width: ' + Math.max(0, Math.min(100, opts.value)) + '%;" />').appendTo(this))
                       .data("text", $('<div class="progress-text">' + opts.text + '</div>').appendTo(this));
                }
                if (!$el.hasClass("progress")) {
                    $el.addClass("progress");
                }
            });
        }
    };
    $.fn.progressBar.defaults = {
        value: 0,
        text: "&nbsp;"
    };
})(jQuery);