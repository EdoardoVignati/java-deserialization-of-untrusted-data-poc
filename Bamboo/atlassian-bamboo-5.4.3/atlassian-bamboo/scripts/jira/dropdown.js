/**
 * Creates a dropdown list from a JSON obect
 * @module dropdown
 * @author Scott Harwood
 * @requires jQuery > v1.2
 */


jQuery.namespace("jira.widget.dropdown");

/**
 * @abstract dropdown
 */
jira.widget.dropdown = function() {

    // private

    var instances = [];

    return {

        // public

        /**
         * Adds this instance to private var <em>instances</em>
         * This reference can be used to access all instances
         * @function {public} addInstance
         */
        addInstance: function() {
            instances.push(this);
        },


        /**
         * Calls the hideList method on all instances of <em>dropdown</em>
         * @function {public} hideInstances
         */
        hideInstances: function() {
            var that = this;
            jQuery(instances).each(function(){
                if (that !== this) {
                    this.hideDropdown();
                }
            });
        },

        
        getHash: function () {
            if (!this.hash) {
                this.hash = {
                    container: this.dropdown,
                    hide: this.hideDropdown,
                    show: this.displayDropdown
                };
            }
            return this.hash;
        },

        /**
         * Calls <em>hideInstances</em> method to hide all other dropdowns.
         * Adds <em>active</em> class to <em>dropdown</em> and styles to make it visible.
         * @function {public} displayDropdown
         */
        displayDropdown: function() {
            if (jira.widget.dropdown.current === this) {
                return;
            }

            this.hideInstances();
            jira.widget.dropdown.current = this;
            this.dropdown.css({display: "block"});

            this.displayed = true;

            var dd = this.dropdown;
            setTimeout(function() {
                // Scroll dropdown into view
                var win = jQuery(window);
                var minScrollTop = dd.offset().top + dd.attr("offsetHeight") - win.height() + 10;

                if (win.scrollTop() < minScrollTop) {
                    jQuery("html,body").animate({scrollTop: minScrollTop}, 300, "linear");
                }
            }, 100);
        },

        /**
         *
         * Removes <em>active</em> class from <em>dropdown</em> and styles to make it hidden.
         * @function {public} hideDropdown
         */
        hideDropdown: function() {
            if (this.displayed === false) {
                return;
            }

            jira.widget.dropdown.current = null;
            this.dropdown.css({display: "none"});

            this.displayed = false;
        },

        /**
         * Initialises instance by, applying primary handler, user options and a Internet Explorer hack.
         * function {public} init
         * @param {HTMLelement} trigger
         * @param {HTMLelement} dropdown
         */
        init: function(trigger, dropdown) {

            var that = this;

            this.addInstance(this);
            this.dropdown = jQuery(dropdown);

            this.dropdown.css({display: "none"});

            // hide dropdown on tab
            jQuery(document).keydown(function(e){
                if(e.keyCode === 9) {
                    that.hideDropdown();
                }
            });

            // this instance is triggered by a method call
            if (trigger.target) {
                jQuery.aop.before(trigger, function(){
                    if (!that.displayed) {
                        that.displayDropdown();
                    }
                });

            // this instance is triggered by a click event
            } else {
                that.dropdown.css("top",jQuery(trigger).outerHeight() + "px");
                trigger.click(function(e){
                    if (!that.displayed) {
                        that.displayDropdown();
                        e.stopPropagation();
                        // lets not follow the link (if it is a link)
                    } else {
                        that.hideDropdown();
                    }
                    e.preventDefault();
                });
            }

            // hide dropdown when click anywhere other than on this instance
            jQuery(document.body).click(function(){
                if (that.displayed) {
                    that.hideDropdown();
                }
            });
        }
    };

}();

/**
 * Standard dropdown constructor 
 * @constucter Standard
 * @param {HTMLelement} trigger
 * @param {HTMLelement} dropdown
 * @return {Object} - instance
 */
jira.widget.dropdown.Standard = function(trigger, dropdown) {

    var that = begetObject(jira.widget.dropdown);
    that.init(trigger, dropdown);

    return that;
};

/**
 * Standard dropdown constructor
 * @constucter Standard
 * @param {HTMLelement} trigger
 * @param {HTMLelement} dropdown
 * @return {Object} - instance
 */
jira.widget.dropdown.Autocomplete = function(trigger, dropdown) {

    var that = begetObject(jira.widget.dropdown);

    that.init = function(trigger, dropdown) {

        this.addInstance(this);
        this.dropdown = jQuery(dropdown).click(function(e){
            // lets not hide dropdown when we click on it
            e.stopPropagation();
        });
        this.dropdown.css({display: "none"});

        // this instance is triggered by a method call
        if (trigger.target) {
            jQuery.aop.before(trigger, function(){
                if (!that.displayed) {
                    that.displayDropdown();
                }
            });

        // this instance is triggered by a click event
        } else {
            trigger.click(function(e){
                if (!that.displayed) {
                    that.displayDropdown();
                    e.stopPropagation();
                }
            });
        }

        // hide dropdown when click anywhere other than on this instance
        jQuery(document.body).click(function(){
            if (that.displayed) {
                that.hideDropdown();
            }
        });
    };

    that.init(trigger, dropdown);

    return that;
};
