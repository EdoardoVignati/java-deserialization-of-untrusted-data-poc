/* Chain Log Tables */
(function ($) {
    var BAMBOO = window.BAMBOO || {};
    BAMBOO.LOGS = {};
    BAMBOO.LOGS.chainTableLiveView = (function () {
        var opts = {
            getBuildUrl: null,
            chainStatus: "",
            noLogsFound: 'No logs were found for this Job',
            templates: {
                logTableRow: null
            }
        },
        updateTimeout,
        update = function () {
            clearTimeout(updateTimeout);
            updateLogDisplay();

            //If build not finished update again in 5 seconds
            if (opts.chainStatus != "Finished" && opts.chainStatus != "NotBuilt") {
                updateTimeout = setTimeout(update, 5000);
            }
        },
        updateLogDisplay = function() {
            $(".chain-logs-table > tbody > tr.log-trace > td.code table").each(function() {
                var $logContainer = $(this),
                    $tr = $logContainer.closest("tr").prev();

                if ($tr.hasClass("expanded")) {
                    updateSingleLog($tr.find(".twixie > span"));
                }
            });
        },
        updateSingleLog = function ($twixie) {
            var $tr = $twixie.closest("tr"),
                $stack = $tr.next(),
                $logContainer = $stack.find("table"),
                $loading = $('<span />', { 'class': 'icon icon-loading' });

            if ($logContainer.data('dontUpdate')) {
                return;
            }
            $twixie.hide().before($loading);

            $.ajax({
                url: opts.getBuildUrl.replace("@KEY@", $logContainer.attr("id")),
                data: {
                    expand: 'logEntries[-' + 25 + ':]',
                    'max-results': 25
                },
                dataType: "json",
                contentType: "application/json",
                cache: false,
                success: function (buildResult) {
                    var newLogBody = '';

                    if (buildResult.lifeCycleState == "Finished" || buildResult.lifeCycleState == "NotBuilt") {
                        //if build result is finished there will be no more log changes
                        $logContainer.data('dontUpdate', true);
                    }
                    if (buildResult.logEntries && typeof(buildResult.logEntries.logEntry) != "undefined") {
                        for (var i = 0, ii = buildResult.logEntries.logEntry.length; i < ii; i++) {
                            var logEntry = buildResult.logEntries.logEntry[i];

                            newLogBody += AJS.template.load(opts.templates.logTableRow)
                                .fill({ time: logEntry.formattedDate })
                                .fillHtml({ log: logEntry.log }).toString();
                        }
                    }

                    if ($.trim(newLogBody).length) {
                        $logContainer.html(newLogBody);
                    } else {
                        $logContainer.html(AJS.template.load(opts.templates.logTableRow)
                            .fill({time : ''})
                            .fillHtml({ log: opts.noLogsFound }).toString());
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // Error occurred when doing the update, try again in 30 sec
                    $logContainer.html(opts.noLogsFound);
                },
                complete: function (jqXHR, textStatus) {
                    $loading.remove();
                    $twixie.show();
                }
            });
        };

        return {
            init: function(options) {
                var twixieSelector = ".chain-logs-table > tbody > tr > .twixie > span",
                    twixieAllSelector = ".chain-logs-table > thead > tr > .twixie span[role]";

                $.extend(true, opts, options);

                $(document)
                    .undelegate(twixieSelector, "click")
                    .delegate(twixieSelector, "click", function (e) {
                        var $twixie = $(this),
                                $tr = $twixie.closest("tr"),
                                $stack = $tr.next(),
                                newTwixieText = !$twixie.hasClass("icon-collapse") ? "Collapse" : "Expand"; //negated because we toggle the class later

                        $stack[$tr.hasClass("collapsed") ? "show" : "hide"]();
                        $tr.toggleClass("collapsed expanded");
                        $twixie.toggleClass("icon-collapse icon-expand").attr("title", newTwixieText).html("<span>" + newTwixieText + "</span>");
                        if ($tr.hasClass("expanded")) {
                            updateSingleLog($twixie);
                        }
                    })
                    .undelegate(twixieAllSelector, "click")
                    .delegate(twixieAllSelector, "click", function (e) {
                        var $trigger = $(this),
                                $li = $trigger.closest("li"),
                                $table = $trigger.closest("table");

                        if ($li.hasClass("expand-all")) {
                            $table.find("tbody > .collapsed .twixie > span").click();
                        } else if ($li.hasClass("collapse-all")) {
                            $table.find("tbody > .expanded .twixie > span").click();
                        }
                    });

                update();
            }
        }
    })();
})(jQuery);
