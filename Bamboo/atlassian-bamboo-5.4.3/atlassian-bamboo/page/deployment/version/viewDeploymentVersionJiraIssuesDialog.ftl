[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionJiraIssues" --]
[#import "../../../plugins/jira-plugin/viewJiraIssueComponents.ftl" as jiraComponents /]

[#-- access JIRA issues first to check if accessible --]
[#if oauthAuthenticationRequired]
    [@cp.oauthAuthenticationRequest oauthLoginDanceUrl/]
[#else]
    [@jiraComponents.displayJiraIssueList issues=pager.page.list totalSize=pager.totalSize resultsSummary='' heading='Related issues' showOperations=false showRelated=false showCaption=false showPagination=false/]
    <p class="view-more">[@ww.text name="deployment.execute.preview.version.issues.sublist"][@ww.param value=(pager.page.list.size())/][@ww.param]${pager.totalSize}[/@ww.param][/@ww.text]
        [#if comparingWithBuildResult]
            <a href="${req.contextPath}/deploy/viewCreateDeploymentVersionJiraIssues.action?planResultKey=${planResultKey}&deploymentProjectId=${deploymentProjectId}[#if compareWithVersionId > 0]&compareWithVersion=${compareWithVersion}&compareWithVersionId=${compareWithVersionId}[/#if]">
        [#else]
            <a href="${req.contextPath}/deploy/viewDeploymentVersionJiraIssues.action?versionId=${versionId}&compareWithVersion=${compareWithVersion}&compareWithVersionId=${compareWithVersionId}">
        [/#if]
        [@ww.text name='deployment.execute.preview.version.issues.viewAll'/]</a>
    </p>
[/#if]