[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
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
                    <span class="revision-id">${commit.changeSetId!}</span>
                </h3>
                <p>[@ui.renderValidJiraIssues commit.comment resultsSummary /]</p>
                <ul class="files">
                    [#list commit.files as file]
                        <li>
                            ${file.cleanName!?html}
                            (version ${file.revision!?html})
                        </li>
                    [/#list]
                </ul>
            </li>
        [/#list]
        </ul>
    [/@ui.bambooInfoDisplay]
[/#if]
