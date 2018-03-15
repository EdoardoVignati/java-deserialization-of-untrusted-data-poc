[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssueForPlan"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssueForPlan" --]

<html>
<head>
	<title>Build ${immutablePlan.name} - Linked JIRA Issues /]</title>
    <meta name="tab" content="jira"/>
    <meta name="decorator" content="plan">
</head>

<body>
    [@cp.filterDropDown filterController=filterController/]
    <h1 id="jiraIssuesHeader">JIRA Issues</h1>
    <p>This page lists the JIRA issues that have been linked to builds related to this plan, ordered by last built. This includes issues specified in commit messages, labels or comments for builds, as well as issues manually linked to builds.</p>

    [#if action.requiresOAuthHandshake()]
        [@cp.oauthAuthenticationRequest credentialsRequiredUrl/]
    [#elseif pager.totalSize > 0]
        [@displayJiraIssueList pager.page.list pager.totalSize immutablePlan.key /]
    [#else]
        <p>There are currently no JIRA Issues linked to <b>${immutablePlan.name}</b> for the selected filter: ${filterController.selectedFilterName}.</p>
    [/#if]
</body>
</html>


[#macro displayJiraIssueList issues totalIssues buildKey='' heading='JIRA Issues']
    [#import "viewJiraIssueComponents.ftl" as jiraComponents /]
    <table class="jiraIssueTable aui">
        <caption>
            <span class="jiraIssueSectionHeading">${heading}</span>
            <span class="jiraIssueCount">[#if totalIssues==1](1 issue)[#else](${totalIssues} issues)[/#if]</span>
        </caption>
        <colgroup>
            <col width="18">
            <col width="90">
            <col>
            <col width="9%">
            <col width="9%">
            <col width="9%">
            <col width="9%">
            <col width="9%" >
        </colgroup>
        <thead>
            <tr>
                <th id="${heading}-type">Type</th>
                <th id="${heading}-key">Key</th>
                <th id="${heading}-summary">Summary</th>
                <th id="${heading}-status">Status</th>
                <th id="${heading}-assignee">Assignee</th>
                <th id="${heading}-fix-versions">Fix versions</th>
                <th id="${heading}-relatedBuilds">Related Builds</th>
                <th id="${heading}-lastBuild">Last Built</th>
            </tr>
        </thead>
        <tbody>
            [#list issues as issue]
            <tr[#if lastModified?has_content && lastModified=issue.issueKey] id="jiraIssueSelected"[/#if]>
                <td class="jiraIssueIcon" headers="${heading}-type">
                    [@jiraComponents.jiraIcon issue /]
                </td>
                <td class="jiraIssueKey" headers="${heading}-key">
                    [@jiraComponents.jiraIssueKey issue /]
                </td>
                <td headers="${heading}-summary" class="[#if issue.jiraIssueDetails.summary?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraSummary issue /]
                </td>
                <td  class="jiraIssueStatus" headers="${heading}-status">
                    [@jiraComponents.jiraStatus issue /]
                </td>
                <td headers="${heading}-assignee" class="[#if issue.jiraIssueDetails.assignee?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraAssignee issue /]
                </td>
                <td headers="${heading}-fix-versions" class="[#if issue.jiraIssueDetails.fixVersions?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                    [@jiraComponents.jiraFixVersions issue /]
                </td>
                <td class="jiraIssueRelatedBuilds" headers="${heading}-relatedBuilds">
                    [@jiraComponents.jiraRelatedBuilds issue action.getNumberOfRelatedBuilds(issue.issueKey) /]
                </td>
                <td  class="jiraIssueLastBuilt" headers="${heading}-lastBuild">
                    Last built: ${issue.resultsSummary.relativeBuildDate}
                </td>
            </tr>
            [/#list]
        </tbody>
    </table>
    [#if (pager.page)?has_content]
        [@cp.pagination /]
    [/#if]
[/#macro]
