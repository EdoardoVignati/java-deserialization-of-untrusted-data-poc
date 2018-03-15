(function ($) {
    BAMBOO.JIRAISSUES = (function () {
        var opts = {
                resultSummaryKey: null,
                getIssuesUrl: null,
                currentFullUrl: null,
                defaultIssueIconUrl: null,
                defaultIssueType: null,
                defaultIssueDetails: null,
                newIssueKey: null,
                jiraTabUrl: null,
                maxIssues: null,
                hideStatus: null,
                templates: {
                    authenticationRequiredTemplate: null
                }
            },
            $issuesPanel,
            refresh = function () {
                opts.newIssueKey = (arguments.length ? arguments[0] : null);

                return ($issuesPanel && $issuesPanel.length ? $.ajax({
                    url: opts.getIssuesUrl + opts.resultSummaryKey,
                    cache: false,
                    data: {
                        expand: "jiraIssues[0:" + (opts.maxIssues - 1) + "]",
                        returnUrl: opts.currentFullUrl
                    },
                    dataType: "json",
                    contentType: "application/json"
               }).done(update).fail(error) : false);
            },
            update = function (json) {
                if (json.jiraIssues && json.jiraIssues.issue && json.jiraIssues.issue.length) {
                    $issuesPanel
                        .find('> table')
                        .replaceWith(bamboo.feature.jiraIssueList.jiraIssueList({
                            issues: json.jiraIssues.issue,
                            defaultIssueType: opts.defaultIssueType,
                            defaultIssueIconUrl: opts.defaultIssueIconUrl,
                            hideStatus: opts.hideStatus,
                            jiraTabUrl: opts.jiraTabUrl,
                            maxIssues: opts.maxIssues,
                            issuesCount: json.jiraIssues.size
                        }));

                    $issuesPanel.removeClass('hidden').show();
                    if (opts.newIssueKey) {
                        highlightIssue($issuesPanel.find("tr:contains('" + opts.newIssueKey + "')"));
                    }
                } else {
                    $issuesPanel.hide();
                }
            },
            error = function (jqXHR, textStatus, errorThrown) {
                var response, authUrl, authInstance,
                    $issueTable = $issuesPanel.find('> table');

                try {
                    response = $.parseJSON(jqXHR.responseText);
                    authUrl = response['authenticationRedirectUrl'];
                    authInstance = response['authenticationInstanceName'] || AJS.I18n.getText('jira.title');
                }
                catch (e) {}

                $issueTable.removeClass('loading');
                if (authUrl) {
                    $(AJS.template.load(opts.templates.authenticationRequiredTemplate).fill({ authenticationUrl: authUrl, authenticationInstanceName: authInstance }).toString()).insertBefore($issueTable);
                }
            };
        
        function highlightIssue($newIssue) {
            if ($newIssue.length) {
                var oldColor = $newIssue.css("backgroundColor");
                $newIssue.css("backgroundColor", "#FFFFDD").delay(3000).animate({ backgroundColor:oldColor }, 1500, "swing");
            }
        }
        
        return {
            /**
             * @param options - Object containing the options to overwrite our defaults
             */
            init: function (options) {
                $.extend(true, opts, options);
                $(function () {
                    $issuesPanel = $(".issueSummary");
                    refresh();
                });
            },
            refresh: refresh,
            highlightIssue: highlightIssue
        }
    })();

    BAMBOO.JIRATEASER = (function () {
        var jiraTeaserPopup,
            dialogOptions = {
                width: 420,
                hideDelay: 36e5
            },
            generatePopup = function ($contents, trigger, doShowPopup) {
                // hide popup hooks
                var doHidePopup = function () {
                    jiraTeaserPopup.hide();
                    return false;
                };

                $(document).keyup(function (e) {
                    if (e.which == jQuery.ui.keyCode.ESCAPE) {
                        doHidePopup();
                        $(document).unbind("keyup", arguments.callee);
                        return false;
                    }
                    return true;
                });

                // replace container contents with teaser
                $contents
                    .html(AJS.template.load("jira-teaser-popup").fill())
                    .find(".close-dialog").click(doHidePopup).end()
                    .find(".jiraTeaserCheckbox").change(function (e) {
                        var val = $(this).is(":checked");
                        $.ajax({
                            url: AJS.contextPath() + "/rest/pref/latest/user",
                            type: "post",
                            data: {
                                "bamboo.user.jira.teaser.hide" : val
                            }
                        });
                    });

                doShowPopup();
            };

        $(function ($) {
            if ($("#jira-teaser-template").length) {
                jiraTeaserPopup = AJS.InlineDialog($("#changesSummary .jiraIssueLink:last"), "jiraChangesSummary", generatePopup, dialogOptions);
                jiraTeaserPopup.show();
            }
        });
    }());
})(AJS.$);

var JiraIssueLinkManager = (function ($) {
    var globalBambooProjectKey,
        addLink = function () {
            var $this = $(this),
                jiraIssueKey = $this.data("issue-key"),
                bambooProjectKey = $this.data("bamboo-project-key") || globalBambooProjectKey,
                href = AJS.contextPath() + "/project/jiraRedirect.action?jiraIssueKey=" + jiraIssueKey;

            if (bambooProjectKey) {
                href += "&bambooProjectKey=" + bambooProjectKey;
            }
            $this.attr("href", href);
        };

    return {
        init: function (bambooProjectKey) {
            globalBambooProjectKey = bambooProjectKey;
            $(function () {
                $("a.jiraIssueLink").each(addLink);
           });
        }
    };
})(AJS.$);

var JiraRelatedIssues = (function ($) {
    return {
        init: function() {
            BAMBOO.JIRAISSUES.highlightIssue($(".newJiraIssue"));
        }
    }
})(AJS.$);
