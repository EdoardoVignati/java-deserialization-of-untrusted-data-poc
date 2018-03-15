[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues" --]
[#import  "viewJiraIssueComponents.ftl" as jiraComponents/]

<html>
<head>
	[@ui.header pageKey='JIRA Issues' object='${immutablePlan.name} ${resultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="jira"/>
    <meta name="decorator" content="result"/>
</head>

<body>
    [#if immutablePlan?? && resultsSummary?? && user??]
        <div class="toolbar aui-toolbar inline">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    [@ww.url id='addLinkedIssueUrl' value='/build/addJiraIssue!default.action?buildKey=${immutablePlan.key!}&buildNumber=${resultsSummary.buildNumber}' /]
                    <a id="addNewLinkedJiraIssue" class="toolbar-trigger" href="${addLinkedIssueUrl}">[@ww.text name='buildResult.jiraIssues.link' /]</a>
                </li>
            </ul>
        </div>
        [@dj.simpleDialogForm triggerSelector='#addNewLinkedJiraIssue' headerKey='buildResult.jiraIssues.addLinked.title' submitCallback='reloadThePage' width=592 height=240 /]
    [/#if]
    <h1 id="jiraIssuesHeader">[@ww.text name='buildResult.jiraIssues.title' /]</h1>
    <p>[@ww.text name='buildResult.jiraIssues.description' /]</p>
    [#if fn.isChain(immutablePlan)]
        [#assign showRelated=true/]
    [#else]
        [#assign showRelated=false/]
    [/#if]

    [#-- access JIRA issues first to check if accessible --]
    [#assign relatedIssuesList=relatedIssues /]

    [#if oauthAuthenticationRequired]
        [@cp.oauthAuthenticationRequest oauthLoginDanceUrl/]
    [#else]
        [@jiraComponents.displayJiraIssueList issues=relatedIssuesList totalSize=relatedIssuesList.size() resultsSummary=resultsSummary heading="Related issues" lastModified=lastModified showRelated=showRelated/]
    [/#if]
</body>
</html>

