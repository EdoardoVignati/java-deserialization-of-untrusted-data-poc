BAMBOO.ADMIN = (BAMBOO.ADMIN || {});
BAMBOO.ADMIN.SERVERSTATE = {};

BAMBOO.ADMIN.SERVER_STATUS_UPDATED_EVENT = "serverStatusChangedEvent";
BAMBOO.ADMIN.SERVER_STATUS_POLLING_EVENT = "serverStatusPollingEvent";
BAMBOO.ADMIN.SERVER_STATUS_ACTION_EVENT = "serverStatusActionEvent";

BAMBOO.ADMIN.STATUS_RUNNING = "RUNNING";
BAMBOO.ADMIN.STATUS_PAUSED = "PAUSED";
BAMBOO.ADMIN.STATUS_PAUSING = "PAUSING";
BAMBOO.ADMIN.STATUS_POLLING = "POLLING";
BAMBOO.ADMIN.STATUS_ERROR = "ERROR";

BAMBOO.ADMIN.ACTION_PAUSE = "ACTION_PAUSE";
BAMBOO.ADMIN.ACTION_RESUME = "ACTION_RESUME";

BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater = (function ($) {
    var defaults = {
            statusUrl: AJS.contextPath() + "/rest/api/latest/server",
            pauseUrl: AJS.contextPath() + "/rest/api/latest/server/pause",
            resumeUrl: AJS.contextPath() + "/rest/api/latest/server/resume"
        },
        options,
        serverState,
        $statusElement,
        doPoll = true,
        doRequest = function (type, url) {
            statusPolling();
            $.ajax({
                type: type,
                url: url,
                cache: false,
                dataType: "json",
                success: function (json) {
                    if (json && json.state) {
                        updateStatus(json, null);
                    } else {
                        updateStatus({state: BAMBOO.ADMIN.STATUS_ERROR}, null);
                    }
                },
                error: function (request, textStatus, errorThrown) {
                    updateStatus({state: BAMBOO.ADMIN.STATUS_ERROR}, textStatus + ": " + errorThrown);
                }
            });
        },
        update = function () {
            doRequest("GET", options.statusUrl);
        },
        statusPolling = function () {
            $statusElement.attr("data-server-state", BAMBOO.ADMIN.STATUS_POLLING);
            $statusElement.trigger(BAMBOO.ADMIN.SERVER_STATUS_POLLING_EVENT);
        },
        updateStatus = function (newState, additionalInfo) {
            var oldState = serverState;
            serverState = newState;
            $statusElement.attr("data-server-state", newState.state);
            if (additionalInfo) {
                $statusElement.attr("data-additional-info", additionalInfo);
            } else {
                $statusElement.removeAttr("data-additional-info");
            }
            $statusElement.trigger(BAMBOO.ADMIN.SERVER_STATUS_UPDATED_EVENT, [oldState, serverState, additionalInfo]);
        },
        pollInterval = function () {
            if (serverState && (serverState.state == BAMBOO.ADMIN.STATUS_RUNNING || serverState.state == BAMBOO.ADMIN.STATUS_PAUSED || serverState.state == BAMBOO.ADMIN.STATUS_ERROR)) {
                return 30000;
            } else {
                return 5000;
            }
        },
        poll = function (interval) {
            setTimeout(function () {
                if (doPoll) {
                    update();
                    poll(pollInterval());
                }
            }, interval);
        };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);
            $(function ($){
                $statusElement = $("<input id='bamboo-server-status' type='hidden'>").appendTo("body");
                if (doPoll) {
                    update();
                    poll(pollInterval());
                }
            });
        },

        pause: function () {
            $statusElement.trigger(BAMBOO.ADMIN.SERVER_STATUS_ACTION_EVENT, BAMBOO.ADMIN.ACTION_PAUSE);
            doRequest("POST", options.pauseUrl);
            poll(1000);
        },

        resume: function () {
            $statusElement.trigger(BAMBOO.ADMIN.SERVER_STATUS_ACTION_EVENT, BAMBOO.ADMIN.ACTION_RESUME);
            doRequest("POST", options.resumeUrl);
        },

        onServerStatusPolling: function (callback) {
            $statusElement.bind(BAMBOO.ADMIN.SERVER_STATUS_POLLING_EVENT, callback);
        },

        onServerStatusUpdated: function (callback) {
            $statusElement.bind(BAMBOO.ADMIN.SERVER_STATUS_UPDATED_EVENT, callback);
        },

        onServerStatusAction: function (callback) {
            $statusElement.bind(BAMBOO.ADMIN.SERVER_STATUS_ACTION_EVENT, callback);
        },

        stopPolling: function () {
            doPoll = false;
        }
    }
})(AJS.$);

BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.init();

BAMBOO.ADMIN.SERVERSTATE.serverState = (function ($) {
    var defaults = {
            control: null,
            statusInfo: null,
            button: null,
            pausedMessage: AJS.I18n.getText('serverstate.pausedMessage'),
            pausedButtonLabel: AJS.I18n.getText('serverstate.pausedButtonLabel'),
            pausingMessage: AJS.I18n.getText('serverstate.pausingMessage'),
            pausingButtonLabel: AJS.I18n.getText('serverstate.pausingButtonLabel'),
            reindexInProgressMessage: AJS.I18n.getText('serverstate.reindexInProgress.message'),
            serverRunningCallback: null,
            pollError: AJS.I18n.getText('serverstate.pollError'),
            reloadPage: AJS.I18n.getText('serverstate.reloadPage')
        },
        options,
        lifecycleState,
        $control,
        $button,
        $statusInfo,
        updateStatus = function (event, oldState, newState) {
            if (lifecycleState) {
                $control.removeClass("server-status-" + lifecycleState.toLowerCase());
            }
            lifecycleState = newState.state;
            $control.addClass("server-status-" + lifecycleState.toLowerCase());

            var oldLifecycleState = oldState ? oldState.state : undefined;

            if (lifecycleState == BAMBOO.ADMIN.STATUS_RUNNING) {
                if (oldLifecycleState != BAMBOO.ADMIN.STATUS_RUNNING && options.serverRunningCallback) {
                    options.serverRunningCallback();
                }
                if (newState.reindexInProgress) {
                    $statusInfo.html(options.reindexInProgressMessage);
                    $button.hide();
                    $control.show();
                } else {
                    $control.hide();
                }
                return;
            } else if (lifecycleState == BAMBOO.ADMIN.STATUS_ERROR) {
                if (oldLifecycleState == BAMBOO.ADMIN.STATUS_PAUSED || oldLifecycleState == BAMBOO.ADMIN.STATUS_PAUSING) {
                    if ($button && $button.length) {
                        $button.text(options.reloadPage).click(function () {
                            window.location.reload();
                        });
                    }
                    $statusInfo.html(options.pollError);
                    $control.show();
                } else if (oldLifecycleState != BAMBOO.ADMIN.STATUS_ERROR) {
                    $control.hide();
                }
                return;
            } else {
                $control.show();
            }

            if (lifecycleState == BAMBOO.ADMIN.STATUS_PAUSED || lifecycleState == BAMBOO.ADMIN.STATUS_PAUSING) {
                if ($button && $button.length) {
                    $button.show();
                }
            }

            if (lifecycleState == BAMBOO.ADMIN.STATUS_PAUSING) {
                if ($button && $button.length) {
                    $button.text(options.pausingButtonLabel);
                }
                $statusInfo.html(options.pausingMessage);
            } else if (lifecycleState == BAMBOO.ADMIN.STATUS_PAUSED) {
                if ($button && $button.length) {
                    $button.text(options.pausedButtonLabel);
                }
                $statusInfo.html(options.pausedMessage);
            }
        };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);

            $(function () {
                $control = $(options.control);
                $statusInfo = $(options.statusInfo, $control);
                $button = $(options.button, $control);

                if ($button && $button.length) {
                    $button.click(BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.resume);
                }
                BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.onServerStatusUpdated(updateStatus);
            });
        }
    }
})(AJS.$);
