[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionCommits" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionCommits" --]

[#if commitsCount gt 0]
<div id="changesSummary" class="changesSummary">
    [#if totalCommitsCount gt commitsCount]
        [@ww.text id='deploymentVersionFilesSkipped' name='buildResult.changes.files.skipped' ]
            [@ww.param name="value" value="${commitsCount}"/]
            [@ww.param name="value" value="${totalCommitsCount}"/]
        [/@ww.text]
        [@ui.messageBox title=deploymentVersionFilesSkipped /]
    [/#if]
        [#list changesets as repositoryChangeset]
    [#assign repositoryData=repositoryChangeset.repositoryData/]
    [#if action.isWebRepositoryViewerDefined(repositoryData)]
    ${repositoryData.webRepositoryViewer.getHtmlForDeploymentVersionCommitSummary(deploymentVersion, repositoryChangeset, repositoryData, maxChanges)}
    [#else]
        [@defaultCommitDisplay changesets repositoryChangeset/]
    [/#if]
[/#list]
</div>
[#else]
<p>[@ww.text name='deployment.version.noCommits'/]</p>
[/#if]


[#-- @ftlvariable name="linkGenerator" type="com.atlassian.bamboo.webrepository.CommitUrlProvider" --]
[#-- @ftlvariable name="maxChanges" type="java.lang.Integer" --]
[#-- @ftlvariable name="repositoryChangeset" type="com.atlassian.bamboo.deployments.versions.history.commit.DeploymentVersionVcsChangeset" --]
[#macro defaultCommitDisplay changesets repositoryChangeset]
    [#if repositoryChangeset.commits?has_content]
        [#assign commitToUrls = (linkGenerator.getWebRepositoryUrlForCommits(repositoryChangeset.commits, repositoryChangeset.repositoryData))! /]
    <table class="aui code-changes">
        [#if changesets?size gt 1]
            <caption><span>${repositoryChangeset.repositoryData.getName()?html}</span></caption>
        [/#if]
        <thead>
        <tr>
            <th colspan="2" class="author">[@ww.text name="webRepositoryViewer.author"/]</th>
            <th class="revision">[@ww.text name="webRepositoryViewer.commit"/]</th>
            <th class="commit-message">[@ww.text name="webRepositoryViewer.message"/]</th>
            <th class="revision-date">[@ww.text name="webRepositoryViewer.commitDate"/]</th>
        </tr>
        </thead>
        <tbody>
            [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
            [@displayCommitTableRow commit=commit deploymentVersion=deploymentVersion!/]
        [/#list]
        </tbody>
    </table>
    [/#if]
[/#macro]

[#macro displayCommitTableRow commit deploymentVersion]
<tr>
    <td class="avatar">
        [@ui.displayAuthorAvatarForCommit commit=commit avatarSize='24' /]
    </td>
    <td class="author">
        [#if (commit.author.linkedUserName)?has_content]
            <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
        [#else]
            [@ui.displayAuthorFullName author=commit.author /]
        [/#if]
    </td>
    <td class="revision">
        [#assign revision = commit.getChangeSetId()!("")]
        [#if revision?has_content]
            [#assign commitUrl = (commitToUrls.get(commit))! /]
            [#if commitUrl?has_content]
                <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]">${revision}</a> [@ui.copyToClipboard text=revision width=90 /]
            [#else]
                <span class="revision-id">${revision}</span>
            [/#if]
        [/#if]
    </td>
    <td class="commit-message">
        [#if deploymentVersion?has_content]
            [@ui.renderValidJiraIssuesForDeploymentVersion commit.comment deploymentVersion/]
        [#else]
            [@ui.renderJiraIssues commit.comment/]
        [/#if]
    </td>
    <td class="revision-date">
        [@ui.time datetime=commit.date/]
    </td>
</tr>
[/#macro]