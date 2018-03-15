/*! infinite-scroller - v1.0.0 - 2012-10-21
* Copyright (c) 2012 Adam Ahmed <aahmed@atlassian.com>; Licensed  */

(function(exports) {

    /**
     * A widget for tracking which pages of items have been loaded.
     *
     * For use with InfiniteScroller
     * 
     * THIS particular implementation supports requests for data (pageRequests) that look like 
     * {
     *     start : Number (the index of the first item to retrieve)
     *     limit : Number (the maximum number of items to retrieve after the first)
     *     before : Boolean (whether we're requesting data to come before the currently loaded data)
     *     after : Boolean (whether we're requesting data to come after the currently loaded data)
     * }
     * And expects data to be returned that looks like
     * {
     *     size : Number (the number of items actually returned)
     *     isLastPage : (false if there are more items to be retrieved)
     * }
     * BUT, if you'd like to make InfiniteScroller work with different shapes of requests and returned data,
     * you can write your own implementation using this one as your interface.
     */
    function LoadedRange(pageSize, capacity) {
        //assumption: only a contiguous range of lines will ever be loaded.
        this.start = undefined;
        this.end = undefined;
        this._reachedStart = false;
        this._reachedEnd = false;
        this._reachedCapacity = false;
        this._capacity = capacity || Infinity;
        this._pageSize = pageSize;
    }


    // --- private methods ---

    LoadedRange.prototype._isBeforeStart = function(item) {
        return item < this.start;
    };

    LoadedRange.prototype._isAfterEnd = function(item) {
        return item > this.end;
    };



    // --- public methods ---

    /**
     * @return {Boolean} true if no items have been loaded
     */
    LoadedRange.prototype.isEmpty = function() {
        return this.start === undefined;
    };

    /**
     * @param item the item to check the status of
     * @return {Boolean} true if the item is included in this LoadedRange.
     */
    LoadedRange.prototype.isLoaded = function(item) {
        return !(this.isEmpty() || this._isBeforeStart(item) || this._isAfterEnd(item));
    };

    /**
     * @return whether the beginning of the range of items has been loaded.
     */
    LoadedRange.prototype.reachedStart = function() { return this._reachedStart; };
    /**
     * @return whether the end of the range of items has been loaded.
     */
    LoadedRange.prototype.reachedEnd = function() { return this._reachedEnd; };

    /**
     * @return whether the maximum number of items to load has been reached.
     */
    LoadedRange.prototype.reachedCapacity = function() { return this._reachedCapacity; };

    /**
     * @return the number of items preceding this range.
     */
    LoadedRange.prototype.itemsBefore = function() {
        return this.start || 0;
    };

    /**
     * @return the number of items loaded
     */
    LoadedRange.prototype.itemsLoaded = function() {
        return (this.end - this.start) || 0;
    };
    
    /**
     * @param item an identifier for the item you want to request
     * @return a pageRequest for the page that includes the requested item
     */
    LoadedRange.prototype.pageFor = function(item) {

        var start = item ?
            Math.floor(item / this._pageSize) * this._pageSize :
            0;

        return {
            after : this._isBeforeStart(item),
            before: this._isAfterEnd(item),
            start : start,
            limit : this._pageSize
        };
    };

    /**
     * @return a pageRequest for the page immediately preceding this loaded range.
     */
    LoadedRange.prototype.pageBefore = function() {
        if (this.reachedStart()) {
            return null;
        }

        var start = Math.max(0, this.start - this._pageSize);
        return {
            after : false,
            before: true,
            start : start,
            limit : this.start - start
        };
    };

    /**
     * @return a pageRequest for the page immediately following this loaded range.
     */
    LoadedRange.prototype.pageAfter = function() {
        if (this.reachedEnd() || this.reachedCapacity()) {
            return null;
        }

        return {
            after : true,
            before: false,
            start : this.end,
            limit : this._pageSize
        };
    };

    /**
     * Register a range of data as loaded.
     * @param pageRequest the pageRequest used to retrieve this data
     * @param data the data retrieved
     * @return this for chaining
     */
    LoadedRange.prototype.add = function(pageRequest, data) {
        var start = pageRequest.start, size = data.size, isLastPage = data.isLastPage;

        var isEmpty = this.isEmpty();
        if (isEmpty || this._isBeforeStart(start)) {
            this.start = start;
        }
        if (isEmpty || this._isAfterEnd(start + size)) {
            this.end = start + size;
        }

        this._reachedStart = this._reachedStart || start <= 0;
        this._reachedEnd = this._reachedEnd || isLastPage;
        if (this.end >= this._capacity) {
            this._reachedCapacity = true;
        }

        return this;
    };

    exports.InfiniteScroller = exports.InfiniteScroller || {};
    exports.InfiniteScroller.LoadedRange = LoadedRange;
})(window);

(function(exports, console, $, LoadedRange, triggerFunc) {

    var isIE = $.browser.msie;

    function debounced(millis, func) {
        var timeoutId;
        return millis ? function () {
                clearTimeout(timeoutId);
                timeoutId = setTimeout(func, millis);
            } :
            function() {
                func();
            };
    }

    /**
     * An abstract widget that will handle scroll events and load new data as the user scrolls to the end of the content.
     *
     * To extend InfiniteScroller, you must implement:
     * this.requestData(pageRequest) : given a pageRequest from LoadedRange, must return a promise with a RestPage object as the first done() argument.
     * this.attachNewContent(data, attachmentMethod) : given your retrieved data and an attachmentMethod ('prepend', 'append', or 'html'),
     *              should add new content somewhere within the element specified by scrollPaneSelector (where exactly is up to you)
     * this.handleErrors : will be passed the result of your requestData promise's fail handler and should handle that case.
     *
     * @param scrollPaneSelector - the element with (overflow: auto | scroll) which contain the pages of items
     * @param options see <code>InfiniteScroller.defaults</code>.
     */
    function InfiniteScroller(scrollPaneSelector, options) {
        if (!(this instanceof InfiniteScroller)) {
            return new InfiniteScroller(scrollPaneSelector, options);
        }

        options = this.options = $.extend({}, InfiniteScroller.defaults, options);

        // Allow setting of the abstract methods through the options object.
        this.requestData = options.requestData || this.requestData;
        this.attachNewContent = options.attachNewContent || this.attachNewContent;
        this.handleErrors = options.handleErrors || this.handleErrors;

        this.$scrollElement = $(scrollPaneSelector || window);

        // Use window instead of document or body.
        if (this.$scrollElement[0] === document || this.$scrollElement[0] === document.body) {
            this.$scrollElement = $(window);
        }

        if ($.isWindow(this.$scrollElement[0])) {
            // we still want to attach to window.scroll, but documentElement has the properties we need to look at.
            var docEl = window.document.documentElement;
            this.getPaneHeight = function() { return docEl.clientHeight; };
            this.getContentHeight = function() { return docEl.scrollHeight; };
        }
    }
    /**
     * pageSize: used as the limit parameter to requestData,
     * loadAutomatically : When true, the next/previous page will be loaded as soon as the user scrolls it into view. Set this false if you prefer to trigger loads with a button.
     *              To trigger a load manually, call InfiniteScroller.load(pageRequest, shouldLoadAbove)
     * bufferPixels: load more data if the user scrolls within this many pixels of the edge of the loaded data.
     * debounceDelay: the number of milliseconds to debounce before handling a scroll or resize event.
     * precedingSpaceMaintained: Set this to true if your implementation will add blank space above the loaded content as a placeholder for content
     *              that will be loaded as the user scrolls up.
     *
     *              Setting this to <code>true</code> means InfiniteScroller will load a previous page when
     *              the proportion of the content scrolled is less than the start of your loaded range (i.e., wandering into the 'placeholder' territory you've created.)
     *              <code>scrollElement.scrollTop < bufferPixels + (loadedRange.start / loadedRange.end) * scrollContent.height</code>
     *
     *              Setting it <code>false</code> means a previous page will be loaded when
     *              <code>scrollElement.scrollTop < bufferPixels</code>
     * suspendOnFailure : When enabled, the infinite-scroller will enter a suspended mode, as if InfiniteScroller.suspend() was called after a data request fails.
     *              To resume requesting data, call InfiniteScroller.resume().
     * eventBus : a function for triggering events, of the form function(string eventName, InfiniteScroller context, ...arguments);
     */
    InfiniteScroller.defaults = {
        pageSize: 50,
        debounceDelay : 250,
        bufferPixels : 0,
        precedingSpaceMaintained : true,
        suspendOnFailure : true,
        loadAutomatically : true,
        eventBus : triggerFunc
    };

    /**
     * Begin infinite scrolling.
     *
     * @param targetedItem An identifier for the item to load initially. When using the default LoadedRange implementation, this is
     *                     an index where 0 is the topmost item to be displayed.
     * @param loadedRange Optional. Can be used to provide a pre-filled LoadedRange if some data is already loaded, or to provide a
                          custom LoadedRange implementation. Default is an empty LoadedRange.
     * @return {Object} promise for loading the first page of data.
     */
    InfiniteScroller.prototype.init = function(targetedItem, loadedRange) {
        InfiniteScroller.prototype.reset.call(this);

        this.loadedRange = loadedRange || new LoadedRange(this.options.pageSize);

        var self = this,
            pageSize = this.options.pageSize;

        // if the start item is already loaded we probably don't have to load any more.
        if (this.loadedRange.isLoaded(targetedItem)) {

            // but it's possible the window is larger than the page size, so trigger a fake scroll anyway just to see if that causes any new loads.
            return (this.loadIfRequired() || $.Deferred().resolve()).done(function() {
                // do our onFirstDataLoaded call now if we can, or after whatever loads next.
                self.onFirstDataLoaded();
            });
        }

        return loadInternal(this, this.loadedRange.pageFor(targetedItem, pageSize), false).pipe(undefined, function() {

            var possiblyPastEnd = !!targetedItem;

            // if we fail due to being past the end of the list of items, try just loading from the beginning instead.
            if (possiblyPastEnd) {
                // fallback to loading the first page.
                return loadInternal(self, self.loadedRange.pageFor(null, pageSize), false);

            } else {
                // nfi what happened - fail the same way as before.
                return $.Deferred().rejectWith(this, arguments);
            }
        }).fail(function() {
            if (!self._cancelling) {
                self.handleErrors.apply(self, arguments);
            }
        });
    };

    InfiniteScroller.prototype.reset = function() {
        if (this.currentXHR) {
            this.cancelRequest();
        }

        this.clearScrollListeners();
        $(window).off('resize', this._resizeHandler);
        this._resizeHandler = null;

        // must happen after this.cancelRequest() to avoid the scrollable becoming suspended on a reinit.
        this._suspended = false;
    };

    /**
     * Stop requesting new data.  Any requests already in the pipeline will complete.
     * To resume requesting data, call InfiniteScroller.resume();
     */
    InfiniteScroller.prototype.suspend = function () {
        this._suspended = true;
    };

    /**
     * Resume requesting new data.
     */
    InfiniteScroller.prototype.resume = function () {
        this._suspended = false;

        // if they are near the top/bottom of the page, request the data they need immediately.
        this.loadIfRequired();
    };

    InfiniteScroller.prototype.isSuspended = function() {
        return this._suspended;
    };

    InfiniteScroller.prototype.getScrollTop = function() { return this.$scrollElement.scrollTop(); };
    InfiniteScroller.prototype.setScrollTop = function(scrollTop) { this.$scrollElement.scrollTop(scrollTop); };

    InfiniteScroller.prototype.getPane = function() {
        return this.$scrollElement;
    };
    InfiniteScroller.prototype.getPaneHeight = function() {
        return this.$scrollElement[0].clientHeight;
    };
    InfiniteScroller.prototype.getContentHeight = function() {
        return this.$scrollElement[0].scrollHeight;
    };

    InfiniteScroller.prototype.addScrollListener = function(func) {
        this.$scrollElement.bind('scroll.infinite-scroller', debounced(this.options.debounceDelay, func));
    };
    InfiniteScroller.prototype.clearScrollListeners = function() {
        this.$scrollElement.unbind('scroll.infinite-scroller');
    };

    InfiniteScroller.prototype.loadIfRequired = function() {

        // if the dev doesn't want us loading, don't load.
        if (this.isSuspended() || !this.options.loadAutomatically) {
            return;
        }

        // if the container is hidden, don't try anything
        if (!$.isWindow(this.getPane()[0]) && (this.getPane().is(":hidden") || !this.getPaneHeight())) {
            return;
        }

        var scrollTop = this.getScrollTop(),
            scrollPaneHeight = this.getPaneHeight(),
            contentHeight = this.getContentHeight(),
            scrollBottom = scrollPaneHeight + scrollTop;

        var itemsBefore = this.loadedRange.itemsBefore(),
            itemsLoaded = this.loadedRange.itemsLoaded(),
            emptyAreaRatio = (itemsBefore / (itemsBefore + itemsLoaded));

        if (scrollTop  < (emptyAreaRatio * contentHeight) + this.options.bufferPixels) {
            var pageBefore = this.loadedRange.pageBefore(this.options.pageSize);
            if (pageBefore) {
                return this.load(pageBefore, true);
            }
        }

        // In Chrome on Windows at some font sizes (Ctrl +), the scrollPaneHeight is rounded down, but contentHeight is
        // rounded up (I think). This means there is a 1px difference between them and the event won't fire.
        var chromeWindowsFontChangeBuffer = 1;

        if (scrollBottom + chromeWindowsFontChangeBuffer >= contentHeight - this.options.bufferPixels) {
            var pageAfter = this.loadedRange.pageAfter(this.options.pageSize);
            if (pageAfter) {
                return this.load(pageAfter, false);
            }
        }
    };

    function loadInternal(self, pageRequest, shouldLoadAbove) {

        if (self.currentXHR) {
            return $.Deferred().reject();
        }

        self.currentXHR = self.requestData(pageRequest);

        return self.currentXHR.always(function () {
                self.currentXHR = null;
            })
            .done(function(data) {
                self.onDataLoaded(pageRequest, data, shouldLoadAbove);
            })
            .fail(function() {
                if (self.options.suspendOnFailure) {
                    self.suspend();
                }
            });
    }

    InfiniteScroller.prototype.load = function(pageRequest, shouldLoadAbove) {
        var self = this;
        return loadInternal(this, pageRequest, shouldLoadAbove).fail(function() {
            if (!self._cancelling) {
                self.handleErrors.apply(self, arguments);
            }
        });
    };

    InfiniteScroller.prototype.onDataLoaded = function(pageRequest, data, isLoadedAbove) {
        var firstLoad = this.loadedRange.isEmpty(),
            attachmentMethod = this.loadedRange.isEmpty() ?
                                    'html' :
                               isLoadedAbove ?
                                    'prepend' :
                                    'append',
            isPrepend = attachmentMethod === 'prepend';

        this.loadedRange.add(pageRequest, data);

        var oldHeight,
            oldScrollTop;
        if (isPrepend || isIE) { // values for calculating offset
            oldScrollTop = this.getScrollTop();
            oldHeight = this.getContentHeight();
        }

        this.attachNewContent(data, attachmentMethod);

        // scroll to where the user was before we added new data.  IE reverts to the initial position (top or line
        // specified in hash) when you append content, so we need to always rescroll in IE.
        if (isPrepend || isIE) {
            var heightAddedAbove = isPrepend ? this.getContentHeight() - oldHeight : 0;
            this.setScrollTop(oldScrollTop + heightAddedAbove);
        }

        if (firstLoad) {
            this.onFirstDataLoaded(pageRequest, data);
        }

        this.options.eventBus('aui.infinitescroller.dataLoaded', this, pageRequest, data );

        //retrigger scroll - load more if we're still at the edges.
        this.loadIfRequired();
    };

    InfiniteScroller.prototype.onFirstDataLoaded = function(pageRequest, data) {
        var self = this;
        this.addScrollListener(function() { self.loadIfRequired(); });

        $(window).on('resize', this._resizeHandler = debounced(this.options.debounceDelay, function() {
            self.loadIfRequired();
        }));
    };


    InfiniteScroller.prototype.attachNewContent = function(data, attachmentMethod) {
        throw new Error('attachNewContent is abstract and must be implemented.');
    };

    InfiniteScroller.prototype.requestData = function(pageRequest) {
        throw new Error('requestData is abstract and must be implemented.  It must return a promise. It is preferred to return a jqXHR.');
    };

    InfiniteScroller.prototype.cancelRequest = function() {
        if (this.currentXHR) {
            this._cancelling = true;
            if (this.currentXHR.abort) {
                this.currentXHR.abort();

            } else if (this.currentXHR.reject) {
                this.currentXHR.reject();

            } else {
                console.log("Couldn't cancel the current request.");
            }
            this._cancelling = false;
            this.currentXHR = null;
        }
    };

    InfiniteScroller.prototype.handleErrors = function(/* arguments */) {
        throw new Error("handleErrors is abstract and must be implemented. It is called by your promise's fail handler, except when the request was cancelled by InfiniteScroller.");
    };


    exports.InfiniteScroller = InfiniteScroller;
    exports.InfiniteScroller.LoadedRange = LoadedRange;
})(
    window,
    {
        log :
            typeof AJS !== 'undefined'     ? AJS.log :
            typeof console !== 'undefined' ? function() {
                        Function.prototype.apply.call(console.log, console, arguments);
                    } :
            function() {}
    },
    window.jQuery,
    window.InfiniteScroller.LoadedRange,
    function(eventName, context /*, arguments */) {
        window.jQuery(context).trigger(eventName, Array.prototype.slice.call(arguments, 2));
    }
);