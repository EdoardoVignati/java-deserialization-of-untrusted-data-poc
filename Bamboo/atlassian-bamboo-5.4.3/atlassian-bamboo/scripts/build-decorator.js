(function ($, BAMBOO) {
    BAMBOO.BUILDRESULT = {};
    BAMBOO.PLAN = {};

    BAMBOO.BUILDRESULT.StatusRibbon = function (opts) {
        var defaults = {
                ribbonSelector: null,
                key: null,
                progressBarContainerSelector: '.status-ribbon-progress-bar'
            },
            options = $.extend(true, defaults, opts),
            isJobResult,
            $ribbon,
            $progressBar,
            $buildingForText,
            updateProgressBar = function (progress) {
                var progressPercentage = Math.ceil(100 - (progress['percentageCompleted'] * 100));
                if (!$progressBar.length) {
                    $progressBar = $('<div />', { id: 'sr-pb-' + options.key }).progressBar().appendTo($ribbon.find(options.progressBarContainerSelector));
                    $ribbon.trigger('createprogressbar.buildresult', [ progress ]);
                }
                if (progressPercentage < $progressBar.progressBar('option', 'value')) { // this progress bar works backwards
                    $progressBar.progressBar('option', 'value', progressPercentage);
                }
                updateBuildTime(progress[(progress['averageBuildDuration'] > 0 ? 'prettyTimeRemaining' : 'prettyBuildTime')], { prefix: '&ndash; ' });
                $ribbon.trigger('updateprogressbar.buildresult', [ progress ]);
            },
            updateBuildTime = function (time, options) {
                options || (options = {});
                var prefix = options['prefix'] || '';
                var suffix = options['suffix'] || '';

                if (!$buildingForText.length) { return; }
                if (time) {
                    $buildingForText.text(time + suffix).prepend(prefix).show();
                } else {
                    $buildingForText.hide();
                }
            },
            res = {
                refresh: function (e, json) {
                    var progress, stages = json['stages']['stage'];

                    if (isJobResult) {
                        if (stages.length) {
                            for (var i = 0, ii = stages.length; i < ii && !progress; i++) {
                                var jobs = stages[i]['results']['result'];

                                for (var j = 0, jj = jobs.length; j < jj; j++) {
                                    var job = jobs[j];

                                    if (job['key'] == options.key) {
                                        progress = job['progress'];
                                        if (job['queued']) {
                                            updateBuildTime(job['prettyQueuedTime']);
                                        } else if (job['updatingSource']) {
                                            updateBuildTime(job['prettyVcsUpdateDuration']);
                                        } else if (progress) {
                                            updateProgressBar(progress);
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    } else {
                        progress = json['progress'];
                        if (!progress['buildTime']) {
                            updateBuildTime(json['prettyQueuedTime']);
                        } else {
                            updateProgressBar(progress);
                        }
                    }
                }
            };

        $(function () {
            $ribbon = $(options.ribbonSelector);
            $progressBar = $ribbon.find('.progress');
            $buildingForText = $ribbon.find('.operation-time');
            isJobResult = $ribbon.hasClass('has-job');
            $(document).bind('update.buildresult', res.refresh);
        });

        return res;
    };

    BAMBOO.BUILDRESULT.PlanNavigator = function (opts) {
        var defaults = {
                planNavigatorSelector: null,
                key: null
            },
            options = $.extend(true, defaults, opts),
            $planNavigator,
            $stageElements,
            hiddenClass = 'collapsed',
            updateIcon = function ($icon, iconType) {
                var fullIconType = 'icon-' + iconType;

                if (!$icon.hasClass(fullIconType)) {
                    $icon.attr('class', 'icon ' + fullIconType);
                }
            },
            togglePlanNav = function () {
                if ($planNavigator.parent().hasClass(hiddenClass)) {
                    $planNavigator.parent().removeClass(hiddenClass);
                    $(this).attr('title', AJS.I18n.getText('global.buttons.hide'));
                } else {
                    $planNavigator.parent().addClass(hiddenClass);
                    $(this).attr('title', AJS.I18n.getText('global.buttons.show'));
                }
            },
            addPlanNavToggle = function () {
                $('<button />', { title: ($planNavigator.parent().hasClass(hiddenClass) ? AJS.I18n.getText('global.buttons.show') : AJS.I18n.getText('global.buttons.hide')), id: 'plan-nav-toggle', click: togglePlanNav }).insertAfter($planNavigator);
            },
            res = {
                refresh: function (e, json) {
                    var jobs = [], stages = json['stages']['stage'];

                    if (stages.length) {
                        for (var i = 0, ii = stages.length, k = stages[0].index; i < ii; i++, k++) {
                            var stage = stages[i],
                                $stageElement = $($stageElements[k]),
                                $stageIcon = $('.stageIcon', $stageElement);

                            jobs = jobs.concat(stage['results']['result']);
                            if (stage['isBuilding']) {
                                $stageElement.removeClass('Pending').addClass('InProgress');
                                if ($stageIcon.length) {
                                    updateIcon($stageIcon, 'stage-InProgress stageIcon');
                                }
                            } else if (stage['isCompleted']) {
                                $stageElement.removeClass('Pending InProgress').addClass(stage['isSuccessful'] ? 'Successful' : 'Failed');
                                if ($stageIcon.length) {
                                    updateIcon($stageIcon, stage['isSuccessful'] ? 'stage-Successful stageIcon' : 'stage-Failed stageIcon');
                                }
                            } else {
                                $stageElement.addClass('Pending');
                                if ($stageIcon.length) {
                                    updateIcon($stageIcon, 'stage-Pending stageIcon');
                                }
                            }
                        }
                        for (var j = 0, jj = jobs.length; j < jj; j++) {
                            var job = jobs[j],
                                $job = $('#job-' + job['key']),
                                $icon = $job.find('.icon'),
                                $progress = $job.find('.progress'),
                                progressPercentage;

                            $job.trigger('updatejob.buildresult', [ job ]);
                            
                            if (job['finished']) {
                                updateIcon($icon, job['state']);
                                if ($progress.length) {
                                    $progress.remove();
                                }
                            } else if (job['progress'] && !job['queued']) {
                                progressPercentage = Math.ceil(100 - (job['progress']['percentageCompleted'] * 100));
                                updateIcon($icon, 'InProgress');
                                if (!$progress.length) {
                                    $progress = $('<div />', { id: 'navPb' + job['key'] }).progressBar().prependTo($job);
                                }
                                if (progressPercentage < $progress.progressBar('option', 'value')) { // this progress bar works backwards
                                    $progress.progressBar('option', 'value', progressPercentage);
                                }
                            } else {
                                updateIcon($icon, 'Queued');
                            }
                        }
                    }
                }
            };

        $(function () {
            $planNavigator = $(options.planNavigatorSelector);
            $stageElements = $planNavigator.find("> ul > li");
            addPlanNavToggle();
            $(document).bind('update.buildresult', res.refresh);
        });

        return res;
    };

    BAMBOO.BUILDRESULT.BuildResult = (function () {
        var opts = {
                currentKey: null,
                getStatusUrl: null,
                jobStatus: null,
                isActive: false,
                ribbonSelector: '#status-ribbon'
            },
            planNavigator,
            statusRibbon,
            getJobStatus = function (job) {
                if (job['finished']) {
                    return job['state'];
                } else if (job['waiting']) {
                    return "Pending";
                } else if (job['progress'] && !job['queued']) {
                    if (job['updatingSource']) {
                        return "updatingSource";
                    } else {
                        return "InProgress";
                    }
                } else {
                    return "Queued";
                }
            },
            updateTimeout,
            update = function () {
                $.ajax({
                    url: opts.getStatusUrl,
                    cache: false,
                    data: {
                        expand: "stages.stage.results.result"
                    },
                    dataType: "json",
                    contentType: "application/json",
                    success: function (json) {
                        if (json['finished']) {
                            reloadThePage();
                            return;
                        }

                        $(document).trigger('update.buildresult', [ json ]);

                        // Update again in 5 seconds
                        updateTimeout = setTimeout(update, 5000);
                    },
                    error: function (XMLHttpRequest) {
                        // 404 for status means either no such result key exists OR build is not executing
                        // both cases are a good reason to reload, otherwise just wait
                        if (XMLHttpRequest.status == 404) {
                            reloadThePage();
                            return;
                        }
                        // Error occurred when doing the update, try again in 30 sec
                        updateTimeout = setTimeout(update, 30000);
                    }
                });
            },
            refreshDetails = function (e, progress) {
                if (progress) {
                    $(".started + dd > time").attr("datetime", progress['startedTimeFormatted']).html(progress['startedTime'] + ' &ndash; <span>' + progress['prettyStartedTime'] + '</span>');
                }
            },
            onJobUpdated = function (e, job) {
                if (opts.jobStatus && job['key'] == opts.currentKey && opts.jobStatus != getJobStatus(job)) {
                    reloadThePage();
                }
            };

        return {
            init: function (options) {
                $.extend(true, opts, options);

                if ($.browser.msie && parseInt($.browser.version, 10) <= 8) {
                    $(function () {
                        $(opts.ribbonSelector).prepend('<span class="before"></span>').append('<span class="after"></span>');
                    });
                }

                planNavigator = new BAMBOO.BUILDRESULT.PlanNavigator({ planNavigatorSelector: '#plan-navigator', key: opts.currentKey });

                if (opts.isActive) {
                    $(document)
                        .bind('updateprogressbar.buildresult', refreshDetails)
                        .bind('updatejob.buildresult', onJobUpdated)
                        .bind('createprogressbar.buildresult', function () { reloadThePage(); }); // TODO: Remove this when we can update the build results page dynamically without needing to refresh manually

                    statusRibbon = new BAMBOO.BUILDRESULT.StatusRibbon({ ribbonSelector: opts.ribbonSelector, key: opts.currentKey });

                    update();
                }
            }
        }
    }());

    BAMBOO.PLAN.LinkedJiraIssueDescription = (function (opts) {
        var options = $.extend(true, {
                planKey: null,
                issueSelector: '.plan-description'
            }, opts),
            $description = $(options.issueSelector),
            issueKey = $description.data('jiraIssueKey'),
            keyLink = AJS.contextPath() + '/project/jiraRedirect.action?jiraIssueKey=' + issueKey,
            remoteJiraLinkRequired = $description.data('remoteJiraLinkRequired');

        $(bamboo.feature.jiraIssueList.singleIssueLoading({
            key: issueKey,
            keyLink: keyLink
        })).appendTo($description);
        $.ajax({
            url: AJS.contextPath() + '/rest/api/latest/plan/' + options.planKey + '/issue/' + issueKey,
            cache: false,
            dataType: 'json'
        }).done(update).fail(error);

        function update(issue, textStatus, jqXHR) {
            var summary = issue['summary'];

            if (summary) {
                $description.html(bamboo.feature.jiraIssueList.singleIssue(issue));
                if (remoteJiraLinkRequired) {
                    showRemoteJiraLinkButton();
                }
            } else {
                error(jqXHR);
            }
        }
        function error(jqXHR) {
            var response, authUrl, authInstance;

            try {
                response = $.parseJSON(jqXHR.responseText);
                authUrl = response['authenticationRedirectUrl'];
                authInstance = response['authenticationInstanceName'] || AJS.I18n.getText('jira.title');
            }
            catch (e) {}
            if (authUrl) {
                $description.html(bamboo.feature.jiraIssueList.singleIssueOAuth({
                    key: issueKey,
                    keyLink: keyLink,
                    authenticationRedirectUrl: authUrl + '&redirectUrl=' + encodeURIComponent(document.location.href),
                    authenticationInstanceName: authInstance
                }));
            } else {
                $description.html(bamboo.feature.jiraIssueList.singleIssueRetrievalError({
                    key: issueKey,
                    keyLink: keyLink
                }));
            }
        }
        function showRemoteJiraLinkButton() {
            var disabledProperty = 'aria-disabled',
                $button = $('<button/>', { 'class': 'aui-button aui-style', text: AJS.I18n.getText('issue.link.creation.button') }).click(initiateLink).insertAfter($description),
                $icon = $(widget.icons.icon({ type: 'loading' }));

            function initiateLink() {
                if (!$button.attr(disabledProperty)) {
                    $button.attr(disabledProperty, true).append($icon);

                    $.ajax({
                        url: AJS.contextPath() + '/ajax/createRemoteIssueLink.action',
                        cache: false,
                        dataType: 'json',
                        data: {
                            planKey: options.planKey,
                            issueKey: issueKey
                        }
                    }).done(linkCreated).fail(linkFailed);
                }
            }
            function linkCreated(response, textStatus, jqXHR) {
                if (response['status'] == "ERROR") {
                    linkFailed(jqXHR);
                } else {
                    $icon.replaceWith(widget.icons.icon({ type: 'tick-agent' }));
                    setTimeout(function () {
                        $button.fadeOut(function () { $(this).remove(); });
                    }, 1500);
                }
            }
            function linkFailed(jqXHR) {
                var response, authUrl, authInstance, authMessage, errors;

                try {
                    response = $.parseJSON(jqXHR.responseText);
                    errors = response['errors'];
                    authUrl = response['authorisationURI'];
                    authInstance = response['context'] || AJS.I18n.getText('jira.title');
                    authMessage = response['message'];
                }
                catch (e) {}

                if (authUrl) {
                    showMessageDialog(authMessage, BAMBOO.buildAUIMessage([ bamboo.feature.jiraIssueList.linkedIssueOAuth({
                        authenticationRedirectUrl: authUrl + '&redirectUrl=' + encodeURIComponent(document.location.href),
                        authenticationInstanceName: authInstance,
                        reason: 'in order to create a remote issue link'
                    }) ], 'warning', { escapeTitle: false }));
                } else {
                    if (!errors || !errors.length) {
                        errors = [ AJS.I18n.getText('issue.link.creation.error.generic.description') ];
                    }
                    showMessageDialog(AJS.I18n.getText('issue.link.creation.error.generic.title'), BAMBOO.buildAUIErrorMessage(errors));
                }
                $button.removeAttr(disabledProperty);
                $icon.remove();
            }
            function showMessageDialog(title, content) {
                var dialog = new AJS.Dialog({
                    width: 600
                }).addHeader(title).addPanel('', content).addButton(AJS.I18n.getText('global.buttons.close'), function () { dialog.remove(); });

                dialog.show().updateHeightProperly();
            }
        }
    });
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));