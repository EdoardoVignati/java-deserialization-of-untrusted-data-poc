(function ($, BAMBOO) {
    BAMBOO.DEPLOYMENT.Config = DeploymentConfig;

    /**
     * DeploymentConfig View
     * @param {Object=} options Map of options to initialise the view with
     * @constructor
     */
    function DeploymentConfig(options) {
        this.options = options || {};
        this.initialize(this.options);
    }

    DeploymentConfig.prototype = {
        _collapsedClass: 'collapsed',
        _selectedClass: 'selected',
        _overviewSelector: '.configure-project-environment-overview',
        _fullInfoSelector: '.configure-project-environment-details, .configure-project-environment-tasks, .configure-project-environment-other',
        initialize: function (options) {
            var self = this;
            $(function () {
                $('.configure-project-environment')
                    .on('click', '.toggle', function () { self.toggleExpandCollapse.apply(self, arguments); })
                    .each(function () {
                        var $el = $(this);
                        self.setInitialDisplay.apply(self, arguments);
                        if ($el.hasClass(self._selectedClass)) {
                            self.scrollTo.call(self, $el, function () {
                                self.fadeBackground.call(self, $el);
                            });
                        }
                    });
            });
        },
        toggleExpandCollapse: function (e) {
            var self = this;
            var $env = $(e.delegateTarget);
            var shouldExpand = $env.hasClass(this._collapsedClass);
            $env.find(this._overviewSelector)[shouldExpand ? 'slideUp' : 'slideDown']();
            $env.find(this._fullInfoSelector)[shouldExpand ? 'slideDown' : 'slideUp'](function () {
                $env.toggleClass(self._collapsedClass, !shouldExpand);
                $env.find('.overview').toggleClass("hidden", shouldExpand);
                $env.find('.full-info').toggleClass("hidden", !shouldExpand);
                $env.find('.environment-edit').toggleClass("hidden", !shouldExpand);
            });
        },
        setInitialDisplay: function (i, element) {
            var $env = $(element);
            $env.find($env.hasClass(this._collapsedClass) ? this._fullInfoSelector : this._overviewSelector).hide();
        },
        /**
         * Scrolls to the element specified
         * @param {HTMLElement|selector} element DOM element to scroll to
         * @param {Function=} callback Function to execute after animation finishes
         */
        scrollTo: function (element, callback) {
            $('html, body').animate({
                scrollTop: $(element).offset().top
            }, 1000, callback);
        },
        /**
         * Fades to transparent the background of the element specified
         * @param {HTMLElement|selector} element DOM element to fade background
         */
        fadeBackground: function (element) {
            $(element).animate({
                'background-color': 'transparent'
            }, 1500);
        }
    };

}(AJS.$, window.BAMBOO = (window.BAMBOO || {})));
