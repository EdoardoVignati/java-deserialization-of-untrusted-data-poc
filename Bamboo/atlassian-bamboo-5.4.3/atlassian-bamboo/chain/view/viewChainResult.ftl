[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]

<html>
<head>
	[@ui.header pageKey='chainResult.summary.title' object='${immutablePlan.name} ${chainResultNumber}' title=true /]
    <meta name="tab" content="result"/>
</head>

<body>
<div class="result-summary-tab">
[#import "/lib/resultSummary.ftl" as ps]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/tests.ftl" as tests]

[#assign testSummary = chainResult.testResultsSummary /]
[#assign testResults = filteredTestResults /]
[#assign hasNewFailingTests = testSummary.newFailedTestCaseCount gt 0 /]
[#assign hasExistingFailedTests = testSummary.existingFailedTestCount gt 0 /]
[#assign hasFixedTests = testSummary.fixedTestCaseCount gt 0 /]
[#assign hasQuarantinedTests = testSummary.quarantinedTestCaseCount gt 0 /]
[@ww.url id='manageElasticInstancesUrl' action='manageElasticInstances' namespace='/admin/elastic'/]

[@ui.header pageKey='chainResult.summary.title' /]
<div class="result-summary aui-group">
    <div class="details aui-item">
        [#if (chainResult.totalJobCount == 1)]
            [#if currentlyBuilding?? && chainResult.inProgress]
                [#assign agent = action.getAgent(currentlyBuilding.buildAgentId)!/]
            [#elseif chainResult.finished]
                [#assign jobSummary = (chainResult.orderedJobResultSummaries?first)! /]
                [#if jobSummary.finished || (jobSummary.notBuilt && jobSummary.buildAgentId??)]
                    [#assign agent = action.getAgent(jobSummary.buildAgentId)! /]
                [/#if]
            [/#if]
            [@ps.brsStatusBox buildSummary=resultsSummary filteredRepositoryChangesets=action.getRepositoryChangesetsWithNotBlankRevision(resultsSummary) agent=agent prefix="chainResult" /]
        [#else]
            [@ps.brsStatusBox buildSummary=resultsSummary filteredRepositoryChangesets=action.getRepositoryChangesetsWithNotBlankRevision(resultsSummary) prefix="chainResult" /]
        [/#if]
        [#if testSummary.totalTestCaseCount > 0 && chainResult.finished]
            <div class="test-summary">
                <ul>
                    <li class="new-failures">[#if hasNewFailingTests]<a href="#new-failed-tests">${testSummary.newFailedTestCaseCount} <span>[@ww.text name='chain.summary.test.newFailures'/]</span></a>[#else]${testSummary.newFailedTestCaseCount} <span>[@ww.text name='chain.summary.test.newFailures'/]</span>[/#if]</li>
                    <li class="existing-failures">[#if hasExistingFailedTests]<a href="#existing-failed-tests">${testSummary.existingFailedTestCount} <span>[@ww.text name='chain.summary.test.existingFailures'/]</span></a>[#else]${testSummary.existingFailedTestCount} <span>[@ww.text name='chain.summary.test.existingFailures'/]</span>[/#if]</li>
                    <li class="fixed">[#if hasFixedTests]<a href="#fixed-tests">${testSummary.fixedTestCaseCount} <span>[@ww.text name='chain.summary.test.fixed'/]</span></a>[#else]${testSummary.fixedTestCaseCount} <span>[@ww.text name='chain.summary.test.fixed'/]</span>[/#if]</li>
                    [#if hasQuarantinedTests]<li class="quarantine"><a href="[@ww.url value='/browse/${chainResult.planResultKey}/test/#quarantined-tests' /]">${testSummary.quarantinedTestCaseCount} <span>[@ww.text name='chain.summary.test.quarantined'/]</span></a></li>[/#if]
                </ul>
            </div>
        [/#if]
    </div>

    <div class="aui-item result-web-panels right-result-web-panels">
        [@ui.renderWebPanels "chainresult.summary.right" /]
    </div>
</div>

<div class="result-web-panels">
    [@ui.renderWebPanels "chainresult.summary" /]
</div>

[#-- Show errors section if failed, no failed tests and only one failed job --]
[#if chainResult.finished && chainResult.failed && testSummary.failedTestCaseCount == 0]
    [#assign failedJobResults = chainResult.failedJobResults /]
    [#if failedJobResults.size() == 1 ]
        [#assign brs = failedJobResults[0] /]
        [@ww.text id="errorSummaryHeader" name='buildResult.error.summary.chain.title' ]
            [@ww.param][@ww.url value='/browse/${brs.planResultKey}/' /][/@ww.param]
            [@ww.param]${brs.immutablePlan.buildName}[/@ww.param]
        [/@ww.text]
        [@ps.showBuildErrors buildResultSummary=brs extraBuildResultsData=brs.extraBuildResultsData type="chain" header=errorSummaryHeader /]
    [/#if]
[/#if]

[#if chainResult.finished || chainResult.notBuilt]
    [@cp.displayErrorsForResult planResult=chainResult errorAccessor=errorAccessor manualReturnUrl='/browse/${chainResult.planResultKey}'/]
[/#if]

[#-- ============================================================================================== Logs Section --]

[#if chainResult.inProgress]
    <h2 id="jobLogDisplay">
        [#assign resultSummaries=jobResultSummaries /]
        [#assign firstActiveJobKey="" /]
        [#if resultSummaries?size > 1]

            [#list resultSummaries as res]
                [#if res.inProgress]
                    [#assign firstActiveJobKey=res.planResultKey/]
                    [#break]
                [#elseif res.queued && !firstQueuedJobKey?has_content]
                    [#assign firstQueuedJobKey=res.planResultKey/]
                [/#if]
            [/#list]
            [#if !firstActiveJobKey?has_content && firstQueuedJobKey?has_content]
                [#assign firstActiveJobKey=firstQueuedJobKey /]
            [/#if]

            <label for="jobResultKeyForLogDisplay">[@ww.text name="build.logs.displayForJob" /]</label>
            [@ww.select id="jobResultKeyForLogDisplay" name="jobResultKeyForLogDisplay" list=jobResultSummaries listKey="buildResultKey" listValue="plan.buildName" groupBy="plan.stage.name" theme="simple" /]
        [#elseif resultSummaries?size == 1]
            [@ww.text name="build.logs.displayForOneJob"][@ww.param]${resultSummaries.get(0).immutablePlan.buildName}[/@ww.param][/@ww.text]
            [@ww.hidden id="jobResultKeyForLogDisplay" value="${resultSummaries.get(0).planResultKey}" /]
        [/#if]
    </h2>
    <div id="buildResultSummaryLogs">
        <table id="buildLog" class="hidden">
            <tbody></tbody>
        </table>
        <p class="loading">[@ui.icon type="loading" /]&nbsp;[@ww.text name="build.logs.fetching" /]</p>
        <p>[@ww.text name="build.logs.linesToDisplay" ]
            [@ww.param][@ww.select id="linesToDisplay" name="linesToDisplay" list=[10, 25, 50, 100] theme="simple"/][/@ww.param]
        [/@ww.text]</p>
    </div>
    <p id="buildResultSummaryLogMessage"></p>

    <script type="text/x-template" title="logTableRow-template">
        <tr><td class="time">{time}</td><td class="buildOutputLog">{log}</td></tr>
    </script>

    <script type="text/x-template" title="logMessagePending-template">
        [@ww.text name="chainResult.summary.job.pending" ][@ww.param]{job}[/@ww.param][/@ww.text]
    </script>

    <script type="text/x-template" title="logMessageQueued-template">
        [@ww.text name="chainResult.summary.job.queued" ][@ww.param]{job}[/@ww.param][/@ww.text]
    </script>

    <script type="text/x-template" title="logMessageFinished-template">
        [@ww.text name="chainResult.summary.job.finished" ][@ww.param]{job}[/@ww.param][/@ww.text]
    </script>

    <script type="text/javascript">
        AJS.$(function () {
            BuildResultSummaryLiveActivity.init({
                getBuildUrl: "[@ww.url value='/rest/api/latest/result/@KEY@' /]",
                activeJobResultKey: "${firstActiveJobKey}",
                templates: {
                    logMessagePending: "logMessagePending-template",
                    logMessageQueued: "logMessageQueued-template",
                    logMessageFinished: "logMessageFinished-template",
                    logTableRow: "logTableRow-template"
                }
            });
        });
    </script>
[/#if]

<script type="text/javascript">
    JiraIssueLinkManager.init("${(project.key)!""}");
</script>
</div>
</body>
</html>
