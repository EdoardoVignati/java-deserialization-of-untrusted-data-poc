/**
 * Quarantined Tests Tab - removes the test row with ajax when 'unleash' is clicked
 * Test results tables - executes unleash/quarantine action as an ajax call instead of reloading page
 */
BAMBOO.TESTACTIONS = (function ($) {
    var toggleFail = function (jqXHR) {
        var json,
                message = 'An error occurred while connecting to Bamboo server. Please refresh the page and try again.';

        try {
            json = $.parseJSON(jqXHR.responseText);
            if (json.errors && json.errors.length) {
                message += "\n\n" + json.errors.join("\n");
            }
        }
        catch (e) {}
        alert(message); //todo: ask Matty how to better present error message
    };

    $(document).delegate(".quarantine-action", "click", function (e) {
        var $button = $(this),
                $testsTable = $button.closest(".tests-table"),
                $row,
                isQuarantinedClass = "quarantined",
                disabledAttr = "aria-disabled",
                jqXHR;

        e.preventDefault();

        if ($button.attr(disabledAttr) !== 'true') {
            $button.attr(disabledAttr, 'true');
            jqXHR = $.post($button.attr("href"), { "bamboo.successReturnMode": "json" }).fail(toggleFail).always(function () { $button.removeAttr(disabledAttr); });

            if (!$("#testsSummary").length && $("#quarantined-tests").length) {
                $row = $button.closest("tr");
                jqXHR.done(function (json) {
                    if (json && json.status && json.status == "OK") {
                        $row.fadeOut(function () {
                            $(this).remove();
                            if (!$testsTable.find("tbody > tr").length) {
                                $testsTable.replaceWith($("<p/>", { text: AJS.I18n.getText("chain.quarantine.test.none") }));
                            }
                        });
                    } else {
                        toggleFail(jqXHR);
                    }
                });
            } else {
                jqXHR.done(function (json) {
                    var $actionsCell = $button.closest(".actions"),
                            $quarantinedByCell = $button.closest("tr").find(".quarantine-data"),
                            isQuarantined = $button.hasClass(isQuarantinedClass),
                            newActionText = isQuarantined ? AJS.I18n.getText("builder.common.tests.quarantine") : AJS.I18n.getText("builder.common.tests.unquarantine"),
                            unleashURL = $actionsCell.data("unleashUrl"),
                            quarantineURL = $actionsCell.data("quarantineUrl");

                    if (json && json.status && json.status == "OK") {
                        $button.attr({href: (isQuarantined ? quarantineURL : unleashURL)});
                        $button.html("<span class=\"icon icon-quarantine\"></span>" + newActionText);
                        if (isQuarantined) { //this is throw-away if-statement, see https://extranet.atlassian.com/jira/browse/BDEV-2074
                            $quarantinedByCell.html("<em class=\"disabled\">" + AJS.I18n.getText("builder.common.tests.unleashed") + "</em>");
                        } else {
                            $quarantinedByCell.html(AJS.I18n.getText("builder.common.tests.quarantinedByYou"));
                        }
                        $button.toggleClass(isQuarantinedClass, !isQuarantined);
                    } else {
                        toggleFail(jqXHR);
                    }
                });
            }
        }
    });

    $(document).delegate(".unlink-test-to-jira-action", "click", function (e) {
        var $button = $(this),
                $toolbarItem = $button.closest(".toolbar-item"),
                isDisabledClass = "disabled",
                jqXHR;

        e.preventDefault();

        if (!$toolbarItem.hasClass(isDisabledClass)) {
            $toolbarItem.addClass(isDisabledClass);
            jqXHR = $.post($button.attr("href"), { "bamboo.successReturnMode": "json" }).fail(toggleFail).always(function () { $toolbarItem.removeClass(isDisabledClass); });

            jqXHR.done(function (json) {
                if (json && json.status && json.status == "OK") {
                    var $tableRows = AJS.$(".test-case-row-"+$button.data('testCaseId'));
                    $tableRows.find(".linked-jira-issue").html('');

                    $tableRows.find(".link-test-to-jira-action").toggleClass("hidden", false);
                    $tableRows.find(".create-jira-issue-for-test-action").toggleClass("hidden", false);
                    $tableRows.find(".unlink-test-to-jira-action").toggleClass("hidden", true);
                } else {
                    toggleFail(jqXHR);
                }
            });
        }
    });

    var renderLinkedJiraIssue = function ($element, issue) {
        $element.html(bamboo.feature.jiraIssueList.singleIssue(issue));
    };

    return {
        onReturnFromLinkingIssueManually: function (json) {
            if (json && json.status && json.status == "OK") {
                var $tableRows = AJS.$(".test-case-row-"+json.testCaseId),
                        $linkedJiraIssueContainers = $tableRows.find(".linked-jira-issue");

                if (json.authenticationRedirectUrl)
                {
                    $linkedJiraIssueContainers.html(bamboo.feature.jiraIssueList.singleIssueOAuth({
                        key: json.issue.key,
                        keyLink: AJS.contextPath() + '/project/jiraRedirect.action?jiraIssueKey=' + json.issue.key,
                        authenticationRedirectUrl: json.authenticationRedirectUrl + '&redirectUrl=' + encodeURIComponent(document.location.href),
                        authenticationInstanceName: json.authenticationInstanceName
                    }));
                }
                else
                {
                    renderLinkedJiraIssue($linkedJiraIssueContainers, json.issue);
                }

                $tableRows.find(".unlink-test-to-jira-action").toggleClass("hidden", false);
                $tableRows.find(".link-test-to-jira-action").toggleClass("hidden", true);
                $tableRows.find(".create-jira-issue-for-test-action").toggleClass("hidden", true);
            } else {
                //show some error alert?... shouldn't happen anyway...
            }
        }
    };

})(jQuery);
