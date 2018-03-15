[#-- @ftlvariable name="linkGenerator" type="com.atlassian.bamboo.webrepository.CommitUrlProvider" --]
[#-- @ftlvariable name="maxChanges" type="java.lang.Integer" --]
[#-- @ftlvariable name="buildResultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#-- @ftlvariable name="repositoryChangeset" type="com.atlassian.bamboo.resultsummary.vcs.RepositoryChangeset" --]
[#if repositoryChangeset.commits?has_content]
    [#assign commitToUrls = (linkGenerator.getWebRepositoryUrlForCommits(repositoryChangeset.commits, repositoryData))! /]
    <table class="aui code-changes">
        [#if buildResultsSummary.repositoryChangesets?size gt 1]
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
                [#if commit_index gte maxChanges && maxChanges gte 0]
                    [#break]
                [/#if]
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
                    [#assign guessedRevision = commit.guessChangeSetId()!("")]
                    [#if guessedRevision?has_content]
                        [#assign commitUrl = (commitToUrls.get(commit))! /]
                        [#if commitUrl?has_content]
                            <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]">${guessedRevision}</a> [@ui.copyToClipboard text=guessedRevision width=90 /]
                        [#else]
                            <span class="revision-id">${guessedRevision}</span> [@ui.copyToClipboard text=guessedRevision width=90/]
                        [/#if]
                    [/#if]
                </td>
                <td class="commit-message">
                    [@ui.renderValidJiraIssues commit.comment resultsSummary /]
                </td>
                <td class="revision-date">
                    [@ui.time datetime=commit.date relative=true /]
                </td>
            </tr>
            [/#list]
        </tbody>
    </table>
[/#if]
