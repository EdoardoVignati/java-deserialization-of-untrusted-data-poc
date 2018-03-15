(function (BAMBOO, $) {

    function ResultList(selector, environmentId, options) {
        options = options || {};

        this.environmentId = environmentId;
        this.currentUrl = document.URL.split(AJS.contextPath())[1];

        options.url = AJS.contextPath() + '/rest/api/latest/deploy/environment/' + this.environmentId + '/results';
        BAMBOO.InfiniteTable.call(this, selector, options);
    }

    ResultList.prototype = BAMBOO.InfiniteTable.prototype;
    ResultList.prototype.attachNewContent = function (data, attachmentMethod) {
        this.$tbody[attachmentMethod](_.map(data['results'], function (result) {
            return bamboo.feature.deployment.result.resultList.item({
                'deploymentResult' : result,
                'environmentId': this.environmentId,
                'currentUrl': this.currentUrl
            });
        }).join(''));

        if ((data.size == (data['start-index'] + data['max-result']))) {
            $('<p class="no-more-results"/>').text(AJS.I18n.getText('global.results.no.more')).insertAfter(this.$table);
        }
    };

    BAMBOO.DEPLOYMENT.ResultList = ResultList;

}(window.BAMBOO = (window.BAMBOO || {}), jQuery));