[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="error" type="com.atlassian.bamboo.logger.ErrorDetails" --]
[#include "notificationCommonsHtml.ftl"]
[#assign buildSummaryUrl= baseUrl + '/browse/' + error.buildKey + '#buildPlanSummaryErrorLog' /]

[@templateOuter baseUrl=baseUrl showTitleStatus=false]

    <table width="100%" cellpadding="0" cellspacing="0" class="error-detected">
        <tr>
            <td class="status-icon">
                <img src="${baseUrl}/images/delete.gif">
            </td>
            <td>
                Bamboo has detected an error for
                <span class="build">
                    <a href="${baseUrl}/browse/${error.parentPlanKey}/">${error.buildName?replace(" - ", " &rsaquo; ")}</a>
                    [#if error.buildNumber?has_content && error.buildExists]
                        &rsaquo; <a href="${baseUrl}/browse/${error.buildResultKey}/">#${error.buildNumber}</a>
                    [/#if]
                </span>
                [#if error.context?has_content]
                    <span class="error-context">${error.context}</span>
                [/#if]
            </td>
        </tr>
    </table>

    <table cellpadding="0" cellspacing="0" class="error-details">
        <tbody>
            [#if error.numberOfOccurrences == 1]
                <tr>
                    <th>Occurred:</th>
                    <td width="100%">${error.lastOccurred?datetime}</td>
                </tr>
            [#else]
                <tr>
                    <th>Occurrences:</th>
                    <td width="100%">${error.numberOfOccurrences}</td>
                </tr>
                <tr>
                    <th>First Occurred:</th>
                    <td width="100%">${error.firstOccurred?datetime}</td>
                </tr>
                <tr>
                    <th>Last Occurred:</th>
                    <td width="100%">${error.lastOccurred?datetime}</td>
                </tr>
            [/#if]
            [#if error.agentIds?has_content]
                <tr>
                    <th rowspan="${error.agents?size}">Agent[#if error.agents?size != 1]s[/#if]:</th>
                    [#list error.agents as agent]
                        <td width="100%"><a href="${baseUrl}/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a></td>
                        [#if agent_has_next]</tr><tr>[/#if]
                    [/#list]
                </tr>
            [/#if]
        </tbody>
    </table>

    [#if error.throwableDetails?has_content]
        [@sectionHeader baseUrl buildSummaryUrl "Exception Details" /]

        [#if error.throwableDetails?has_content]
            <dl class="error-throwable-details">
               [#if error.throwableDetails.name?has_content]
                    <dt><strong>${error.throwableDetails.name?html}[#if error.throwableDetails.message?has_content]:[/#if]</strong></dt>
               [/#if]
               [#if error.throwableDetails.message?has_content]
                    <dd>${error.throwableDetails.message?html}</dd>
               [/#if]
            </dl>
        [/#if]

        [#if error.throwableDetails.stackTrace?has_content]
            <pre class="error-log">${error.throwableDetails.stackTrace?html}</pre>
        [/#if]
    [/#if]

    [@showActions]
        [#if error.buildNumber?has_content && error.buildExists]
            [@addAction name="View Build Online" url="${baseUrl}/browse/${error.buildResultKey}/" first=true /]
        [/#if]
        [@addAction name="View Error Online" url="${buildSummaryUrl}" first=!(error.buildNumber?has_content && error.buildExists) /]
        [@addAction name="Clear Error From Log" url="${baseUrl}/admin/removeErrorFromLog.action?buildKey=${error.buildKey}&error=${error.errorNumber}&returnUrl=${buildSummaryUrl?url}" /]
        [@addAction name="View Plan Summary" url="${baseUrl}/browse/${error.parentPlanKey}" /]
    [/@showActions]
[/@templateOuter]