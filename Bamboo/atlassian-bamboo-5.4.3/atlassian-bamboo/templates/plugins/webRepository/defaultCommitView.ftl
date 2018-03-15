[#-- @ftlvariable name="linkGenerator" type="com.atlassian.bamboo.webrepository.DefaultWebRepositoryViewer" --]
[#-- @ftlvariable name="repositoryChangeset" type="com.atlassian.bamboo.resultsummary.vcs.RepositoryChangeset" --]

[#if repositoryChangeset.commits?has_content]
    [@ui.bambooInfoDisplay title=repositoryChangeset.repositoryData.name?html headerWeight='h2']
    <ul>
    [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
        <li>
            [@ui.displayAuthorAvatarForCommit commit=commit avatarSize='24' /]
            <h3>
                <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
                <span class="revision-date">
                    [@ui.time datetime=commit.date relative=true /]
                </span>
                [#if "Unknown" != commit.author.name]
                    [#assign commitUrl = (linkGenerator.getWebRepositoryUrlForCommit(commit, repositoryData))!('') /]
                    [#assign guessedRevision = commit.guessChangeSetId()!("")]
                    [#if commitUrl?has_content && guessedRevision?has_content]
                        <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]">${guessedRevision}</a>
                    [#else ]
                        <span class="revision-id" title="[@ww.text name='webRepositoryViewer.error.cantCreateUrl' /]">${commit.changeSetId!}</span>
                    [/#if]
                [/#if]
            </h3>
            <p>[@ui.renderValidJiraIssues commit.comment buildResultsSummary /]</p>
           <ul class="files">
                [#list commit.files as file]
                <li>
                    [#if "Unknown" != commit.author.name]
                       [#assign fileLink = linkGenerator.getWebRepositoryUrlForFile(file, repositoryData)!]
                       [#if fileLink?has_content]
                          <a href="${fileLink}">${file.cleanName}</a>
                       [#else]
                          ${file.name}
                       [/#if]
                       [#if file.revision?has_content]
                            [#if fileLink?has_content && linkGenerator.getWebRepositoryUrlForRevision(file, repositoryData)?has_content]
                                <a href="${linkGenerator.getWebRepositoryUrlForRevision(file, repositoryData)}">(version ${file.revision})</a>
                            [#else]
                                (version ${file.revision})
                            [/#if]
                            [#if fileLink?has_content && linkGenerator.getWebRepositoryUrlForDiff(file, repositoryData)?has_content]
                                <a href="${linkGenerator.getWebRepositoryUrlForDiff(file, repositoryData)}">(diffs)</a>
                            [/#if]
                       [/#if]
                    [#else]
                        ${file.cleanName!}
                        [#if file.revision??]
                        (version ${file.revision})
                        [/#if]
                    [/#if]
                </li>
                [/#list]
            </ul>
        </li>
    [/#list]
    </ul>
    [/@ui.bambooInfoDisplay]
[/#if]
