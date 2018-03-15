[#-- @ftlvariable name="numFailures" type="java.lang.Integer"--]
[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#-- @ftlvariable name="firstFailedBuildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="firstFailedTriggerReasonDescription" type="java.lang.String" --]
[#include "notificationCommons.ftl"]
[#include "notificationCommonsHtml.ftl"]
[#assign testSummary = buildSummary.testResultsSummary /]
[#assign totalJobCount = buildSummary.totalJobCount/]
[#assign failingJobCount = buildSummary.failedJobResults?size/]
[#assign customStatusMessage]
    [#if buildSummary.successful]
        [#if numFailures?has_content]was successful after <strong>${numFailures}</strong> [#if numFailures==1]failure[#else]failures[/#if][#else]was successful[/#if]
    [#else]
        [#if numFailures?has_content]has failed <strong>${numFailures}</strong> [#if numFailures==1]time[#else]times[/#if][#else]failed[/#if]
    [/#if]
[/#assign]

[@templateOuter baseUrl=baseUrl statusMessage=customStatusMessage]

    [@displayTriggerReason /]
    <p class="tests-summary">
        [#if buildSummary.successful]
            [#if totalJobCount > 1]
                [#if testSummary.totalTestCaseCount == 0]
                    All <strong>${totalJobCount}<strong> jobs passed[#t]
                [#else]
                    All <strong>${totalJobCount}</strong> jobs passed with <strong>${testSummary.successfulTestCaseCount}</strong> tests in total.[#t]
                [/#if]
            [#else]
                [#if testSummary.totalTestCaseCount == 0]
                    No tests executed.
                [#else]
                    <strong>${testSummary.successfulTestCaseCount}</strong> tests in total.
                [/#if]
            [/#if]
        [#else]
             [@displayBuildFailureMessage buildSummary totalJobCount /]
        [/#if]
    </p>
    [#if firstFailedBuildSummary?has_content]
        <p class="failing-since">This plan has been failing since <a href="${baseUrl}/browse/${firstFailedBuildSummary.planResultKey}">#${firstFailedBuildSummary.buildNumber}</a> (${firstFailedBuildSummary.reasonSummary}, ${firstFailedBuildSummary.getRelativeBuildDate(buildSummary.buildCompletedDate)}).</p>
    [/#if]

    [#list ctx.getWebPanelsForResultsSummary("notification.completedbuild.html", buildSummary) as webpanel]
    ${webpanel}
    [/#list]

    [@showFailingJobs buildSummary baseUrl /]
    [@showCommits buildSummary baseUrl /]
    [@showChainTests buildSummary baseUrl /]

    [@showActions]
        [@addAction "View Online" "${baseUrl}/browse/${buildSummary.planResultKey}" true/]
        [@addAction "Add Comments" "${baseUrl}/browse/${buildSummary.planResultKey}?commentMode=true"/]
    [/@showActions]

[/@templateOuter]