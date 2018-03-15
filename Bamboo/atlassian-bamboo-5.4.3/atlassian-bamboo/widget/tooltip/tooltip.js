(function ($, BAMBOO) {
    BAMBOO.Tooltip = Tooltip;

    var isIdRegex = /^#[a-z][^\s]*/i;
    var nonAlphaNumericRegex = /[^a-z0-9]/gi;
    var firstCharacterHashOrDot = /^[#\.]/;

    /**
     * Tooltip
     * @param {selector} trigger Selector targeting the element(s) that trigger the tooltip to open when hovered
     * @param {Object} options Map of options to initialise the tooltip with
     * @constructor
     */
    function Tooltip(trigger, options) {
        this.trigger = this.sanitizeTriggerSelector(trigger);
        this.options = $.extend({}, Tooltip.defaults, options);
        if (!this.options.content && !this.options.url) {
            throw new Error('Content for the tooltip must be provided via either the content option or url option.');
        }
        this._dialogIdentifier = this.trigger.replace(firstCharacterHashOrDot, '').replace(nonAlphaNumericRegex, '-');
        this.initialize(this.options);
    }

    Tooltip.prototype = {
        _tooltipMarkerClass: 'tooltip-marker',
        _inlineDialogIdPrefix: 'inline-dialog-',
        initialize: function (options) {
            var scope = this;
            $(function () {
                if (options.addMarker) {
                    scope.addTooltipMarker(scope.trigger);
                }
                if (!scope.inlineDialogAlreadyExists()) {
                    scope._inlineDialog = AJS.InlineDialog(scope.trigger, scope._dialogIdentifier, (options.url || function () {
                        scope.setupInlineDialogContent.apply(scope, arguments);
                    }), scope.getInlineDialogOptions());
                }
            });
        },
        /**
         * Add the content to the inline dialog and trigger showing it
         * @param {jQuery} $contents jQuery object referencing the element containing content of the inline dialog
         * @param {HTMLElement} trigger Element that triggered the inline dialog
         * @param {Function} show Show function passed from inline dialog to display it
         */
        setupInlineDialogContent: function ($contents, trigger, show) {
            $contents.html(this.options.content);
            show();
        },
        /**
         * Clean trigger selector (if it's an id) of stupid characters like ":" and "." which jQuery doesn't like
         * @param {selector} trigger Selector to sanitize
         * @returns {selector}
         */
        sanitizeTriggerSelector: function (trigger) {
            return (isIdRegex.test(trigger) ? BAMBOO.escapeIdToJQuerySelector(trigger) : trigger);
        },
        /**
         * Add tooltip markers
         * @param {selector} target Selector targeting the elements to add tooltip markers to
         */
        addTooltipMarker: function (target) {
            $(target).addClass(this._tooltipMarkerClass);
        },
        /**
         * Check if the inline dialog already exists in the DOM
         * @returns {boolean}
         */
        inlineDialogAlreadyExists: function () {
            return !!document.getElementById(this._inlineDialogIdPrefix + this._dialogIdentifier);
        },
        /**
         * Get options for inline dialog
         * @returns {Object} Map of options used to intialize the inline dialog
         */
        getInlineDialogOptions: function () {
            return {
                onHover: true,
                fadeTime: 50,
                hideDelay: 0,
                showDelay: this.options.showDelay,
                width: this.options.width,
                useLiveEvents: true
            };
        }
    };

    /**
     * Tooltip default options
     * @type {Object} Map of default options for Tooltip
     */
    Tooltip.defaults = {
        /**
         * Add tooltip marker class to triggers
         * @type {boolean}
         * @default false
         */
        addMarker: false,
        /**
         * Delay (in ms) before tooltip should display
         * @type {Number}
         * @default 500
         */
        showDelay: 500,
        /**
         * Width (in px) of the tooltip
         * @type {Number}
         * @default 300
         */
        width: 300,
        /**
         * Content of the tooltip (required if url not specified)
         * @type {String}
         */
        content: null,
        /**
         * URL to location of the content for the tooltip (required if content not specified)
         * @type {String}
         */
        url: null
    };

}(AJS.$, window.BAMBOO = (window.BAMBOO || {})));