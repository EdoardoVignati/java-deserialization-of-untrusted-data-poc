(function ($, BAMBOO) {
    BAMBOO.PlanStatusHistory = {};

    BAMBOO.PlanStatusHistory.ResultSummary = Backbone.Model.extend({
        idAttribute: 'buildNumber'
    });

    BAMBOO.PlanStatusHistory.ResultSummaries = Backbone.Collection.extend({
        model: BAMBOO.PlanStatusHistory.ResultSummary,
        initialize: function (models, options) {
            options || (options = {});
            this.planKey = options.planKey;
        },
        url: function () {
            return AJS.contextPath() + '/ajax/planStatusHistoryNeighbouringSummaries.action?planKey=' + this.planKey;
        },
        parse: function (response) {
            return response['navigableSummaries'];
        },
        comparator: function (model) {
            return model.id;
        }
    });

    BAMBOO.PlanStatusHistory.Navigator = Backbone.View.extend({
        id: 'plan-status-history',
        initialize: function (options) {
            options || (options = {});
            this.buildNumber = options.buildNumber;
            this.returnUrl = options.returnUrl || '';
            this.keyToNavigate = options.keyToNavigate;
            this._firstBuildNumber = options.firstBuildNumber;
            this._lastBuildNumber = options.lastBuildNumber;
            this._updateTimeoutSuccess = options.updateTimeoutSuccess || 15000;
            this._updateTimeoutFailure = options.updateTimeoutFailure || 20000;
            this.collection = new BAMBOO.PlanStatusHistory.ResultSummaries(options.bootstrap || [], {
                planKey: options.planKey
            });
            $(document).on('statechange.historyxhr', _.bind(this.updateReturnUrls, this));
            this.scheduleNextUpdate();

            this._inlineDialog = AJS.InlineDialog('#' + this.el.id + ' li > *', 'plan-status-history-info', _.bind(this.showInlineDialog, this), {
                onHover: true,
                fadeTime: 50,
                hideDelay: 50,
                showDelay: 0,
                useLiveEvents: true,
                container: '#content'
            });

            BAMBOO.PageVisibilityManager.addVisibilityChangeEventListener(_.bind(this.onPageVisibilityChange, this));
        },
        render: function () {
            this.$el.html(bamboo.widget.planStatusHistory.navigator({
                "builds": this.collection.toJSON(),
                "currentBuildNumber": this.buildNumber,
                "firstBuildNumber": this._firstBuildNumber,
                "lastBuildNumber": this._lastBuildNumber,
                "keyToNavigate": this.keyToNavigate,
                "returnUrl": this.returnUrl
            }));
            return this;
        },
        update: function () {
            var data = {};
            if (this.buildNumber) {
                data.buildNumber = this.buildNumber;
            }
            return this.collection.fetch({
                cache: false,
                dataType: 'json',
                data: data
            })
                    .done(_.bind(this.updateBuildNumberDetails, this))
                    .done(_.bind(this.render, this))
                    .always(_.bind(this.recordLastUpdateTime, this))
                    .always(_.bind(this.scheduleNextUpdate, this));
        },
        updateBuildNumberDetails: function () {
            var lastBuildNumber = (this.collection.length ? this.collection.last().id : null);
            if (lastBuildNumber > this._lastBuildNumber) {
                this._lastBuildNumber = lastBuildNumber;
            }
        },
        recordLastUpdateTime: function () {
            this._lastUpdateTime = new Date();
        },
        cancelNextUpdate: function () {
            clearTimeout(this._timeout);
        },
        scheduleNextUpdate: function (jqXHR) {
            this.cancelNextUpdate();
            if (!BAMBOO.PageVisibilityManager.isPageVisible()) {
                return;
            }
            var delayBeforeUpdate = ((typeof jqXHR === 'undefined' || jqXHR.status == 'OK') ? this._updateTimeoutSuccess : this._updateTimeoutFailure);
            if (this._lastUpdateTime) {
                delayBeforeUpdate -= (new Date().getTime() - this._lastUpdateTime.getTime());
                if (delayBeforeUpdate<0) {
                    delayBeforeUpdate = 0;
                }
            }
            this._timeout = setTimeout(_.bind(this.update, this), delayBeforeUpdate);
        },
        updateReturnUrls: function (event, newReturnUrl) {
            this.returnUrl = encodeURIComponent(this.cleanReturnUrl(newReturnUrl));
            this.render();
        },
        cleanReturnUrl: function (url) {
            var a = document.createElement('a');
            a.href = url;
            return (AJS.contextPath().length ? a.pathname.replace(AJS.contextPath(), '') : a.pathname) + a.search;
        },
        onPageVisibilityChange: function() {
            if (BAMBOO.PageVisibilityManager.isPageVisible()) {
                this.scheduleNextUpdate();
            } else {
                this.cancelNextUpdate();
            }
        },
        showInlineDialog: function (contents, trigger, doShowPopup) {
            var $li = $(trigger).parent(),
                $contents = $('<div/>'),
                buildNumber = $li.data('buildNumber');

            if (this._inlineDialog.data('buildNumber') != buildNumber) {
                $li.find('.icon').clone().appendTo($contents);
                $('<strong/>', { text: '#' + buildNumber }).appendTo($contents);
                if ($li.data('onceOff')) {
                    $(widget.lozenges.lozenge({ colour: 'complete', text: AJS.I18n.getText('buildResult.flags.customRevision') })).appendTo($contents);
                }
                if ($li.data('rebuild')) {
                    $(widget.lozenges.lozenge({ colour: 'moved', text: AJS.I18n.getText('buildResult.flags.rebuild') })).appendTo($contents);
                }
                if ($li.data('customBuild')) {
                    $(widget.lozenges.lozenge({ colour: 'current', text: AJS.I18n.getText('buildResult.flags.customBuild') })).appendTo($contents);
                }
                $('<p/>', { html: $li.data('trigger') }).appendTo($contents);
                if ($li.hasClass('Failed')) {
                    $('<p/>', { text: $li.data('failedTestCaseCount') + ' tests failed' }).appendTo($contents);
                }
                contents.html($contents.html());

                this._inlineDialog.refresh();
                this._inlineDialog.data('buildNumber', buildNumber);
            }

            doShowPopup();
        }
    });
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));