[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#import "/lib/tests.ftl" as tests]

<html>
<head>
    [@ui.header pageKey='buildResult.tests.title' object='${immutableBuild.name} ${buildResultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="tests"/>
</head>

<body>
    [@ui.header pageKey='buildResult.tests.title' /]

    [#assign  testSummary = buildResultsSummary.testResultsSummary/]
    [@tests.displayTestInfo testSummary=testSummary /]

    [@ww.url id='successfulLink'
        action='viewBuildResultsSuccessfulTests'
        namespace='/build/result'
        buildNumber='${buildNumber}'
        buildKey='${immutableBuild.key}'/]
    [@ww.url id='failedLink'
        action='viewBuildResultsFailedTests'
        namespace='/build/result'
        buildNumber='${buildNumber}'
        buildKey='${immutableBuild.key}'/]
    [@ww.url id='quarantinedLink'
        action='viewBuildResultsQuarantinedTests'
        namespace='/build/result'
        buildNumber='${buildNumber}'
        buildKey='${immutableBuild.key}'/]

    <ul id="submenu">
        <li>
            <a href="${failedLink}">[@ww.text name='buildResult.tests.summary.failed' /][#if buildResultsSummary.testResultsSummary.failedTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.failedTestCaseCount})[/#if]</a>
        </li>
        <li>
            <a href="${successfulLink}">[@ww.text name='buildResult.tests.summary.successful' /][#if buildResultsSummary.testResultsSummary.successfulTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.successfulTestCaseCount})[/#if]</a>
        </li>
        [#if testSummary.hasQuarantinedTestResults()]
            <li class="on">
                <a href="${quarantinedLink}">[@ww.text name='buildResult.tests.summary.quarantined.short' /][#if buildResultsSummary.testResultsSummary.quarantinedTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.quarantinedTestCaseCount})[/#if]</a>
            </li>
        [/#if]
        [#if user??]
        <li>
            [@ui.displayIdeIcon/]
        </li>
        [/#if]
    </ul>
    [#if buildResultsSummary?? && buildResultsSummary.filteredTestResults??]
        [#assign  testResults = buildResultsSummary.filteredTestResults/]
        <p class="quarantinedTestsText">
            [#if testSummary.hasQuarantinedTestResults()]
                [@ww.text name='buildResult.tests.quarantined.description']
                    [@ww.param name="value" value='${buildResultsSummary.buildNumber}'/]
                    [@ww.param name="value" value='${testSummary.quarantinedTestCaseCount}'/]
                [/@ww.text]
            [#else]
                [@ww.text name='buildResult.tests.quarantined.none' /]
            [/#if]
        </p>

        [#if testSummary.quarantinedTestCaseCount gt 0]
            [@tests.testsTable id="quarantined-tests"
                testsMap=testResults.quarantinedTests
                showQuarantineInfo=true
                showReason=true
                showJob=false
                showDuration=true
                showFailingSince=true
                showStackTrace=true
                isStackTraceExpanded=false
                caption=tests.testsTableCaption('buildResult.tests.summary.quarantined.title',
                testSummary.quarantinedTestCaseCount) /]
        [/#if]
    [/#if]
</body>
</html>
