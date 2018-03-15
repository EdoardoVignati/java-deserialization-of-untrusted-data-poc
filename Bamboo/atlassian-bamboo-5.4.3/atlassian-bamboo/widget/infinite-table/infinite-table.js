(function(BAMBOO, $, _, InfiniteScroller) {

    function LoadedRange(pageSize, capacity) {
        InfiniteScroller.LoadedRange.call(this, pageSize, capacity);
    }
    LoadedRange.prototype = InfiniteScroller.LoadedRange.prototype;

    LoadedRange.prototype.pageFor = function(item) {

        var start = item ?
                    Math.floor(item / this._pageSize) * this._pageSize :
                    0;

        return {
            after: this._isBeforeStart(item),
            before: this._isAfterEnd(item),
            'start-index': start,
            'max-result': this._pageSize
        };
    };

    LoadedRange.prototype.pageBefore = function() {
        if (this.reachedStart()) {
            return null;
        }

        var start = Math.max(0, this.start - this._pageSize);
        return {
            after: false,
            before: true,
            'start-index': start,
            'max-result': this.start - start
        };
    };

    LoadedRange.prototype.pageAfter = function() {
        if (this.reachedEnd() || this.reachedCapacity()) {
            return null;
        }

        return {
            after: true,
            before: false,
            'start-index': this.end,
            'max-result': this._pageSize
        };
    };

    LoadedRange.prototype.add = function(pageRequest, data) {
        var start = pageRequest['start-index'], size = data['max-result'], isLastPage = (data.size == (data['start-index'] + data['max-result']));

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

    function InfiniteTable(selector, options) {
        options = this.options = $.extend({}, InfiniteTable.defaults, options);

        if (!options.url) {
            throw new Error('url must be specified.');
        }

        this.scrollable = new InfiniteScroller(window, {
            requestData: _.bind(this.requestData, this),
            attachNewContent: _.bind(this.attachNewContent, this),
            handleErrors: _.bind(this.handleErrors, this)
        });

        this.$table = $(selector).addClass('infinite-table');
        this.$tbody = this.$table.children('tbody');

        this.scrollable.init(options.startIndex, new BAMBOO.LoadedRange(options.pageSize).add({ 'start-index': options.startIndex }, {
            size: options.size,
            'start-index': options.startIndex,
            'max-result': options.maxResult
        }));
    }

    InfiniteTable.prototype.requestData = function (pageRequest) {
        var $spinner = $('<div class="spinner"/>');

        this.$table.after($spinner);
        $spinner.spin('large');

        return $.ajax({
            url: this.options.url,
            data: pageRequest
        }).always(function() {
            $spinner.spinStop();
            $spinner.remove();
        });
    };

    InfiniteScroller.prototype.attachNewContent = function(data, attachmentMethod) {
        throw new Error('attachNewContent is abstract and must be implemented.');
    };

    InfiniteTable.prototype.handleErrors = function(/* arguments */) {
        throw new Error("handleErrors is abstract and must be implemented. It is called by your promise's fail handler, except when the request was cancelled by InfiniteTable.");
    };


    InfiniteTable.defaults = {
        url: undefined,
        startIndex: 0,
        size: 0,
        maxResult: 0,
        pageSize: 10
    };

    BAMBOO.LoadedRange = LoadedRange;
    BAMBOO.InfiniteTable = InfiniteTable;
}(window.BAMBOO = (window.BAMBOO || {}), jQuery, window._, window.InfiniteScroller));