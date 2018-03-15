[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#-- @ftlvariable name="buildResults" type="java.util.List<com.atlassian.bamboo.resultsummary.ResultsSummary>" --]

[#-- ================================================================================== @cp.displayAuthorBuildsTable --]
[#macro displayAuthorBuildsTable buildResults totalBuildNumber=0]
[#-- @ftlvariable name="buildResults" type="java.util.List<com.atlassian.bamboo.resultsummary.ResultsSummary>" --]
    <table class="authorBuildsTable aui">
        <thead>
            <tr>
                <th>[@ww.text name='dashboard.build'/]</th>
                <th>[@ww.text name='dashboard.completed'/]</th>
                <th>[@ww.text name='buildResult.changes.title'/]</th>
                <th>[@ww.text name='dashboard.tests'/]</th>
            </tr>
        </thead>
        [#list buildResults as result]
        <tbody>
            [@ww.url id='buildUrl'
                     value='/browse/${result.planResultKey}' /]
            [@ww.url id='commitDetailUrl'
                     value='/browse/${result.planResultKey}/commit' /]

            <tr>
                <td class="buildKeyColumn ${result.buildState}"><a href="${buildUrl}">${result.planKey.key?replace("-", " &rsaquo; ")} &rsaquo; #${result.buildNumber}</a></td>
                <td class="whenColumn">${result.relativeBuildDate}</td>
                <td class="commentColumn">
                    <div class="actionLinks"><a href="${commitDetailUrl}">details</a></div>
                    <div class="commentList">
                        [#list result.commits as commit]
                            [#if commit.author.name == author.name]
                                <div>[@ui.renderValidJiraIssues commit.comment result /]</div>
                            [/#if]
                        [/#list]
                    </div>
                </td>
                <td class="testSummaryColumn">
                    [#if result.testResultsSummary.totalTestCaseCount != 0]
                        ${result.testSummary}
                    [#else]
                        [@ww.text name='buildResult.completedBuilds.noTests'/]
                    [/#if]
                </td>
            </tr>
        </tbody>
        [/#list]
    </table>
    [#if  totalBuildNumber != 0]
        [#if  buildResults.size() < 10 && buildResults.size() < totalBuildNumber]
            [#-- The list has been cut by permission filtering --]
            [@ui.messageBox]
                [@ww.text name='dashboard.mybamboo.warning.filtered'/]
            [/@ui.messageBox]
         [/#if]
    [/#if]
[/#macro]
