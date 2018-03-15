[#-- @ftlvariable name="issue" type="com.atlassian.bamboo.jira.jiraissues.LinkedJiraIssue" --]

[#macro jiraIssueKey issue]
${jiraIssueUtils.getRenderedString(issue.issueKey)}
[/#macro]

[#macro jiraSummary issue]
    [#local errorMessage][@ww.text name='issue.link.retrieval.error' /][/#local]
    ${issue.jiraIssueDetails.summary!errorMessage?html}
[/#macro]

[#macro jiraIcon issue]
    [#if issue.jiraIssueDetails.displayUrl?has_content ]
    <a href="${issue.jiraIssueDetails.displayUrl}" title="[@ww.text name='issue.link.jira.title' /]">
        [#if issue.jiraIssueDetails.type?has_content]
            <img class="issueTypeImg" src="${issue.jiraIssueDetails.type.typeIconUrl}" alt="${issue.jiraIssueDetails.type.typeDescription?html}"/>
        [#else]
            <img class="issueTypeImg" src="${req.contextPath}/images/icons/jira_type_unknown.gif" alt="Unknown Issue Type">
        [/#if]
    </a>
    [#else]
    <img class="issueTypeImg" src="${req.contextPath}/images/icons/jira_type_unknown.gif" alt="Unknown Issue Type">
    [/#if]
[/#macro]

[#macro jiraStatus issue]
    [#if issue.jiraIssueDetails.status?has_content]
    <img src="${issue.jiraIssueDetails.status.statusIconUrl}"/>${issue.jiraIssueDetails.status.statusDescription?html}
    [/#if]
[/#macro]

[#macro jiraAssignee issue]
    [#if issue.jiraIssueDetails.assignee?has_content]
    ${issue.jiraIssueDetails.assignee.displayName?html}
    [/#if]
[/#macro]

[#macro jiraFixVersions issue]
    [#if issue.jiraIssueDetails.fixVersions?has_content]
        [#list issue.jiraIssueDetails.fixVersions as fixVersion]
        ${fixVersion?html}[#t]
            [#if fixVersion_has_next], [/#if][#t]
        [/#list]
    [/#if]
[/#macro]

[#macro jiraRelatedBuilds issue numberOfBuilds]
    [#if issue.jiraIssueDetails.displayUrl??]
    <a href="${issue.jiraIssueDetails.displayUrl}" id="showBuildsRelatedToJira:${issue.issueKey}" title="View related builds in JIRA">[#if numberOfBuilds==1]1 related build[#else]${numberOfBuilds} related builds[/#if]</a>
    [/#if]
[/#macro]

[#macro jiraDeleteOperation issue buildResultsSummary]
    [@ww.url id='removeUrl' value='/build/removeJiraIssue.action?buildKey=${buildResultsSummary.planKey!}&buildNumber=${buildResultsSummary.buildNumber}&currentIssueKey=${issue.issueKey}' /]
<a id="removeJiraIssue:${issue.issueKey}" class="mutative" href="${removeUrl}" >[@ui.icon type="remove" useIconFont=true text="Remove linked JIRA Issue" /]</a>
[/#macro]

[#macro jiraWorkflowOperation issue]
[#-- Currently out-of-service --]
<a title="Transition Issue" id="workflowJiraIssueUrl-${issue.issueKey}" href="${req.contextPath}/ajax/transitionJiraIssueWorkflow.action?issueKey=${issue.issueKey}" issueKey=${issue.issueKey} returnUrl=${currentUrl}>
    <span class="icon icon-tools"/>
</a>
<script type="text/javascript">
    AJS.$(document).delegate("#workflowJiraIssueUrl-${issue.issueKey}", "click", BAMBOO.openJiraIssueTransitionDialog);
</script>
[/#macro]

[#macro jiraIssueSummary resultsSummary linkedJiraIssues maxIssues]
    [#if linkedJiraIssues?has_content && jiraIssueUtils.isJiraServerSetup()]
        [@ww.url id='jiraTabUrl' value='/browse/${resultsSummary.planResultKey}/issues' /]
    <div class="floating-toolbar">
        <a id="displayFullJiraIssues" href='${jiraTabUrl}'>[#rt]
                [#if linkedJiraIssues.size() gt maxIssues]
            [@ww.text name='buildResult.jiraIssues.all' ][@ww.param name="value" value="${linkedJiraIssues.size()}"/][/@ww.text][#t]
        [#else]
            [@ww.text name='buildResult.jiraIssues.details' /][#t]
        [/#if]
        </a>[#lt]
    </div>
    <h2>[@ww.text name='buildResult.jiraIssues.title' /]</h2>
    <ul>
        [#list action.getShortJiraIssues(maxIssues) as issue]
            [#if issue_index gte maxIssues]
                [#break]
            [/#if]
            <li>
                [@jiraComponents.jiraIcon issue /]
                <h3>[@jiraComponents.jiraIssueKey issue /]</h3>

                <p class="[#if issue.jiraIssueDetails.summary?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraSummary issue /]
                </p>
            </li>
        [/#list]
    </ul>
        [#if linkedJiraIssues.size() gt maxIssues]
        <p class="moreLink">
            <a href='${jiraTabUrl}'>
                [@ww.text name='buildResult.jiraIssues.more' ][@ww.param name="value" value="${linkedJiraIssues.size() - maxIssues}"/][/@ww.text]
            </a>
        </p>
        [/#if]
    [/#if]
[/#macro]

[#macro jiraIssueSummaryHolder resultsSummary maxIssues]
    [#assign issues=action.getSizeBoundedLinkedJiraIssues(maxIssues) /]
    [#assign issuesCount=linkedJiraIssues.size() /]
<div id="issueSummary" class="issueSummary[#if !(issues?has_content)] hidden[/#if]">
    <h2>[@ww.text name='buildResult.jiraIssues.title' /]</h2>
    [@ww.url id='jiraTabUrl' value='/browse/${resultsSummary.planResultKey}/issues' /]
${soy.render("bamboo.feature.jiraIssueList.jiraIssueList", {
"issues": issues,
"loading": true,
"jiraTabUrl": jiraTabUrl,
"maxIssues": maxIssues?int,
"issuesCount": issuesCount
})}

    [@ww.url id='getIssuesUrl' value='/rest/api/latest/result/' /]
    <script type="text/x-template" title="authenticationRequired-template">
        [@cp.oauthAuthenticationRequest "{authenticationUrl}" "{authenticationInstanceName}" /]
    </script>
    <script type="text/javascript">
        BAMBOO.JIRAISSUES.init({
                                   resultSummaryKey: "${resultsSummary.planResultKey}",
                                   getIssuesUrl: "${getIssuesUrl}",
                                   currentFullUrl: "${baseUrl}${currentUrl}",
                                   defaultIssueIconUrl: "${req.contextPath}/images/icons/jira_type_unknown.gif",
                                   defaultIssueType: "Unknown Issue Type",
                                   defaultIssueDetails: "Could not obtain issue details from JIRA",
                                   newIssueKey: "${newIssueKey!}",
                                   jiraTabUrl: "${jiraTabUrl?js_string}",
                                   maxIssues: ${maxIssues},
                                   templates: {
                                       authenticationRequiredTemplate: "authenticationRequired-template"
                                   }
                               });
    </script>
</div>
[/#macro]

[#macro jiraMissingApplinkInfo]
    [#if linkedJiraIssues?has_content]
        [#if !hideJiraTeaser]
        <script id="jira-teaser-template" type="text/x-template" title="jira-teaser-popup">
            <div id="jiraTeaser" class="jiraTeaser">
                <h2>[@ww.text name='jira.teaser.title' /]</h2>

                <p>[@ww.text name="jira.teaser.explanation"/]</p>
                <ul>
                    <li>
                        <img alt="Unknown Issue Type" src="${req.contextPath}/images/icons/jira_type_unknown.gif" class="issueTypeImg"/>

                        <h3>TEST-123</h3>

                        <p class="jiraIssueDetails">Connect Bamboo with JIRA</p>
                    </li>
                    <li>
                        <img alt="Unknown Issue Type" src="${req.contextPath}/images/icons/jira_type_unknown.gif" class="issueTypeImg"/>

                        <h3>TEST-456</h3>

                        <p class="jiraIssueDetails">View Issues on the build result summary screen</p>
                    </li>
                </ul>
                [#if !fn.hasAdminPermission()]
                    <p>[@ww.text name="jira.teaser.user" /]</p>
                [/#if]

                <form class="aui top-label" action="${req.contextPath}/plugins/servlet/applinks/listApplicationLinks">
                    <div class="buttons-container">
                        <div class="buttons">
                            [@ww.checkbox name="jira.teaser.hide" cssClass="jiraTeaserCheckbox" labelKey='jira.teaser.dont.show.again'/]
                            [#if fn.hasAdminPermission()]
                                <button class="aui-button aui-button-primary">[@ww.text name="jira.teaser.add" /]</button>
                            [/#if]
                            <a id="jira-teaser-close" class="close-dialog cancel">Close</a>
                        </div>
                    </div>
                </form>
            </div>
        </script>
        [/#if]
    [/#if]
[/#macro]

[#macro displayJiraIssueList issues resultsSummary totalSize heading='JIRA Issues' lastModified='' showRelated=true showOperations=true showCaption=true showPagination=true]
    [#local errorMsgColspan = showOperations?string(showRelated?string("8", "7"),showRelated?string("7","6"))/]
    [#import "viewJiraIssueComponents.ftl" as jiraComponents /]
<table class="jiraIssueTable aui">
    [#if showCaption]
    <caption>
        <span class="jiraIssueSectionHeading">${heading}</span>
        <span class="jiraIssueCount">[#if totalSize==1](1 issue)[#else](${totalSize} issues)[/#if]</span>
    </caption>
    [/#if]
    <colgroup>
        <col width="18">
        <col width="90">
        <col>
        <col width="9%">
        <col width="9%">
        <col width="9%">
        [#if showRelated]
            <col width="9%">
        [/#if]
        [#if showOperations]
            <col width="40" >
        [/#if]
    </colgroup>
    <thead>
    <tr>
    [#-- IF YOU ADD/REMOVE A COLUMN DON'T FORGET TO UPDATE THE COLSPAN FOR THE MESSAGE WHEN THERE ARE NO ISSUES!!! --]
        <th id="${heading}-type">Type</th>
        <th id="${heading}-key">Key</th>
        <th id="${heading}-summary">Summary</th>
        <th id="${heading}-status">Status</th>
        <th id="${heading}-assignee">Assignee</th>
        <th id="${heading}-fix-versions">Fix versions</th>
        [#if showRelated]
            <th id="${heading}-relatedBuilds">Related Builds</th>
        [/#if]
        [#if showOperations]
            <th id="${heading}-operations">Operations</th>
        [/#if]
    </tr>
    </thead>
    <tbody>
        [#if issues?has_content]
            [#list issues as issue]
            <tr class="[#if newIssueKey?has_content && newIssueKey=issue.issueKey] newJiraIssue[/#if]" [#if lastModified?has_content && lastModified=issue.issueKey]id="jiraIssueSelected"[/#if]>
                <td class="jiraIssueIcon" headers="${heading}-type">
                    [@jiraComponents.jiraIcon issue /]
                </td>
                <td class="jiraIssueKey" headers="${heading}-key">
                    [@jiraComponents.jiraIssueKey issue /]
                </td>
                <td headers="${heading}-summary" class="[#if issue.jiraIssueDetails.summary?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraSummary issue /]
                </td>
                <td class="jiraIssueStatus" headers="${heading}-status">
                    [@jiraComponents.jiraStatus issue /]
                </td>
                <td headers="${heading}-assignee" class="[#if issue.jiraIssueDetails.assignee?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraAssignee issue /]
                </td>
                <td headers="${heading}-fix-versions" class="[#if issue.jiraIssueDetails.fixVersions?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraFixVersions issue /]
                </td>
                [#if showRelated]
                    <td class="jiraIssueRelatedBuilds" headers="${heading}-relatedBuilds">
                        [@jiraComponents.jiraRelatedBuilds issue action.getNumberOfRelatedBuilds(issue.issueKey) /]
                    </td>
                [/#if]
                [#if showOperations]
                    <td class="jiraIssueOperations" headers="${heading}-operations">
                        [#if resultsSummary?? && user??]
                                [@jiraComponents.jiraDeleteOperation issue resultsSummary /]
                           [/#if]
                    </td>
                [/#if]
            </tr>
            [/#list]
        [#else]
        <tr><td class="jiraIssueDetailsError" colspan="${errorMsgColspan}">No issues</td></tr>
        [/#if]
    </tbody>
</table>
    [#if (pager.page)?has_content && showPagination]
        [@cp.pagination /]
    [/#if]
    [#if issues?has_content]
    <script type="text/javascript">
        JiraRelatedIssues.init();
    </script>
    [/#if]
[/#macro]
