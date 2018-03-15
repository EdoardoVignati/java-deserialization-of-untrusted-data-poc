[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#import "deploymentComparisonVersionPicker.ftl" as dcvp/]
[#import "../../../plugins/jira-plugin/viewJiraIssueComponents.ftl" as jiraComponents /]

<html>
<head>
    <meta name="decorator" content="deploymentProjectDecorator"/>
    <meta name="tab" content="issues"/>
</head>
<body>
    <h2 id="jiraIssuesHeader">[@ww.text name='deployment.version.jiraIssues.title' /]</h2>
    [#if oauthAuthenticationRequired]
        [@cp.oauthAuthenticationRequest oauthLoginDanceUrl/]
    [#else]
        [@jiraComponents.displayJiraIssueList issues=pager.page.list totalSize=pager.totalSize resultsSummary='' heading='Related issues' showOperations=false showRelated=false/]
    [/#if]
</body>
</html>
