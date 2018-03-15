[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]

[#import "/lib/resultSummary.ftl" as ps]
[#import "/lib/build.ftl" as bd]
[#import "/lib/tests.ftl" as tests]

[@ww.text id='cancelBuildText' name='agent.build.cancel' /]

[#assign buildResult=buildResults! /]
[#assign buildSummary=buildResultsSummary /]
[#assign testResults=filteredTestResults! /]
[#assign testSummary= buildSummary.testResultsSummary /]
[#assign buildResultKey=buildSummary.planResultKey /]
[#assign buildLifeCycleState=buildSummary.lifeCycleState /]


[@ww.url id='viewFailedTestsUrl'
    action='viewBuildResultsFailedTests'
    namespace='/build/result'
    buildNumber='${buildSummary.buildNumber}'
    buildKey='${immutableBuild.key}'/]
[@ww.url id='viewSuccessfulTestsUrl'
    action='viewBuildResultsSuccessfulTests'
    namespace='/build/result'
    buildNumber='${buildSummary.buildNumber}'
    buildKey='${immutableBuild.key}'/]
[@ww.url id='manageElasticInstancesUrl'
    action='manageElasticInstances'
    namespace='/admin/elastic'/]
[@ww.url id='viewAgentsUrl'
    action='viewAgents'
    namespace='/agent'
    planKey=immutableBuild.key
    returnUrl=currentUrl/]
<html>
<head>
	[@ui.header pageKey='buildResult.summary.title' object='${immutableBuild.name} ${buildSummary.buildNumber}' title=true /]
    <meta name="tab" content="summary"/>
</head>

<body>
[@ui.header pageKey='buildResult.summary.title' /]
[#if buildSummary.inProgress]
    [#if currentlyBuilding??]
            [#assign agent = action.getAgent(currentlyBuilding)!/]
    [/#if]
[#elseif buildSummary.finished || buildSummary.notBuilt]
    [#assign agent = action.getAgent(buildSummary)!/]
[/#if]
    [#-- ============================================================================================= Header Section --]
    [@ww.url id='currentBuildUrl' value='/browse/${buildResultKey}' /]
    <div class="result-summary aui-group">
        <div class="details aui-item">
            [@ps.brsStatusBox resultsSummary action.getRepositoryChangesetsWithNotBlankRevision(resultsSummary) agent! /]
        </div>
        [#assign jobResultPanels][@ui.renderWebPanels "jobresult.summary.right" /][/#assign]
        [#if jobResultPanels?trim?has_content]
            <div class="aui-item">${jobResultPanels}</div>
        [/#if]
    </div>


    [#-- ============================================================================================= Tests Section --]

    [#if buildSummary?has_content && buildSummary.finished && testResults?? && testSummary.totalTestCaseCount > 0]
        <div class="tests">
            [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
            [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
            [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]

            <h2>[@ww.text name='buildResult.testClass.tests'/][#if user??] [@ui.displayIdeIcon/][/#if]</h2>
            [@tests.displayTestInfo testSummary /]
            [@tests.displayTestSummary testResults=testResults testSummary=testSummary displayQuarantined=false/]
        </div>
    [/#if]

    [#-- ============================================================================================== Logs Section --]

    [#if buildSummary.inProgress]
        <div id="logs" class="section">
            <div class="floating-toolbar">
                <a id="resultSummaryLogs_toggler_off" class="toggleOff">Expand</a>
                <a id="resultSummaryLogs_toggler_on" class="toggleOn">Collapse</a>
            </div>
            <h2>[@ww.text name="build.logs.title" /]</h2>
            <div id="resultSummaryLogs_target">
                <table id="buildLog" class="hidden">
                    <tbody></tbody>
                </table>
                <p class="loading">[@ui.icon type="loading" /]&nbsp;[@ww.text name="build.logs.fetching" /]</p>
                <p>[@ww.text name="build.logs.linesToDisplay" ]
                    [@ww.param][@ww.select id="linesToDisplay" name="linesToDisplay" list=[10, 25, 50, 100] theme="simple"/][/@ww.param]
                [/@ww.text]</p>
            </div>
            [@cp.toggleDisplayByGroup toggleGroup_id='resultSummaryLogs' jsRestore=true/]
        </div> <!-- END #logs -->
    [/#if]

    [#-- ============================================================================================= Errors Section --]

    [@ps.showBuildErrors buildResultSummary=buildSummary extraBuildResultsData=buildResults /]



    [#if buildSummary.active]

        [@ww.url id='getBuildUrl' value='/rest/api/latest/result/${buildResultKey}' /]
        [@ww.url id="reloadUrl" value="/browse/${buildResultKey}"/]
        [@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]

        <script type="text/x-template" title="disabledStopButton-template">
            [@ui.icon type="build-stop-disabled" text=cancellingBuildText /]
        </script>

        <script type="text/x-template" title="logTableRow-template">
            <tr><td class="time">{time}</td><td class="buildOutputLog">{log}</td></tr>
        </script>

        <script type="text/x-template" title="progressOverAverage-template">
            [@ww.text name="build.currentactivity.build.overaverage"]
                [@ww.param]{elapsed}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="progressUnderAverage-template">
            [@ww.text name="build.currentactivity.build.underaverage"]
                [@ww.param]{elapsed}[/@ww.param]
                [@ww.param]{remaining}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="queueDurationDescription-template">
            [@ww.text name="queue.status.waiting.queueDurationDescription"]
                [@ww.param]{durationDescription}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="queuePositionDescription-template">
            [@ww.text name="queue.status.waiting.queuePositionDescription"]
                [@ww.param]{position}[/@ww.param]
                [@ww.param]{length}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="updatingSourceFor-template">
            [@ww.text name="build.currentactivity.build.updatingSourceFor"]
                [@ww.param]{prettyVcsUpdateDuration}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/javascript">
            AJS.$(function () {
                JobResultSummaryLiveActivity.init({
                    buildResultKey: "${buildResultKey?js_string}",
                    buildLifeCycleState: "${buildLifeCycleState.getValue()?js_string}",
                    container: AJS.$("#buildResultsSummary"),
                    getBuildUrl: "${getBuildUrl}",
                    reloadUrl: "${reloadUrl}",
                    templates: {
                        disabledStopButton: AJS.template.load("disabledStopButton-template"),
                        logTableRow: "logTableRow-template",
                        progressOverAverage: "progressOverAverage-template",
                        progressUnderAverage: "progressUnderAverage-template",
                        queueDurationDescription: "queueDurationDescription-template",
                        queuePositionDescription: "queuePositionDescription-template",
                        updatingSourceFor: "updatingSourceFor-template"
                    }
                });
            });
        </script>
    [/#if]

    [#if buildSummary.finished || buildSummary.notBuilt]
        [@cp.displayErrorsForResult planResult=buildSummary errorAccessor=errorAccessor manualReturnUrl='/browse/${buildResultKey}' /]
    [/#if]

  </body>
</html>