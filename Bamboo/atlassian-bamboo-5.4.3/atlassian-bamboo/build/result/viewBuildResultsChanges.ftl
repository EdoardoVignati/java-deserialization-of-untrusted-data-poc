[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewNextBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewNextBuildResults" --]
<html>
<head>
	[@ui.header pageKey='buildResult.changes.title' object='${immutablePlan.name} ${resultsSummary.buildNumber}' title=true/]
    <meta name="tab" content="changes"/>
</head>

<body>
    <div id="fullChanges">
        [#if changeUrl??]<a href="${changeUrl}">[/#if][@ui.header pageKey='buildResult.changes.title' /][#if changeUrl??]</a>[/#if]
        [#if action.getSkippedCommitsCount(resultsSummary) gt 0]
            [@ww.text id='buildResultFilesSkipped' name='buildResult.changes.files.skipped' ]
                [@ww.param name="value" value="${resultsSummary.commits?size}"/]
                [@ww.param name="value" value="${resultsSummary.commits?size + action.getSkippedCommitsCount(resultsSummary)}"/]
            [/@ww.text]
            [@ui.messageBox title=buildResultFilesSkipped /]
        [/#if]
        [#assign changesetInformation]
            [#list resultsSummary.repositoryChangesets?sort_by("position") as repositoryChangeset]
                [#assign repositoryDefinition=action.getRepositoryData(repositoryChangeset)/]
                [#if repositoryDefinition.webRepositoryViewer?has_content]
                ${repositoryDefinition.webRepositoryViewer.getHtmlForCommitsFull(resultsSummary, repositoryChangeset, repositoryDefinition)}
                [#else]
                    [#include "../../templates/plugins/webRepository/noWebRepositoryView.ftl" /]
                [/#if]
            [/#list]
        [/#assign]
        [#if changesetInformation?trim?has_content]
            ${changesetInformation}
        [#else]
            <p>[@ww.text name="buildResult.changes.none" /]</p>
        [/#if]
    </div>
</body>
</html>
