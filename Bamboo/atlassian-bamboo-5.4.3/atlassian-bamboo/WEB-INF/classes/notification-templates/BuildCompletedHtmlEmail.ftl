[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.build.Buildable" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#include "notificationCommons.ftl"]
[#include "notificationCommonsHtml.ftl" ]
[#assign testSummary = buildSummary.testResultsSummary /]

[@templateOuter baseUrl=baseUrl]

    [@displayTriggerReason /]
    <p class="tests-summary">
        [#if buildSummary.successful]
            [#if testSummary.totalTestCaseCount == 0]
                No tests executed.
            [#else]
                <strong>${testSummary.successfulTestCaseCount}</strong> tests in total.
            [/#if]
        [#else]
           [@displayBuildFailureMessage buildSummary/]
        [/#if]
    </p>

    [@showCommits buildSummary baseUrl /]
    [@showJobTests buildSummary baseUrl /]

    [#if shortErrorSummary.size() gt 0]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/log" "Error Summary" "View full build log"/]
        <table width="100%" cellpadding="0" cellspacing="0" class="errors">
            [#list shortErrorSummary as error]
                [#assign rowClass][#if error_index == 0] first[/#if][#if !error_has_next] last[/#if][/#assign]
                <tr[#if rowClass?has_content] class="${rowClass?trim}"[/#if]>
                    <td>${htmlUtils.getAsPreformattedText(error)}</td>
                </tr>
            [/#list]
        </table>
    [/#if]

    [@showActions]
        [@addAction "View Online" "${baseUrl}/browse/${buildSummary.planResultKey}" true/]
        [@addAction "Add Comments" "${baseUrl}/browse/${buildSummary.planResultKey}?commentMode=true"/]
        [@addAction "View Artifacts" "${baseUrl}/browse/${buildSummary.planResultKey}/artifact"/]
        [@addAction "Download Logs" "${baseUrl}/download/${buildSummary.planKey}/build_logs/${buildSummary.planResultKey}.log"/]
    [/@showActions]

[/@templateOuter]