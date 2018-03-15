[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.tests.ViewTestCaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.tests.ViewTestCaseAction" --]

<html>
<head>
[#if testCase??]
    [@ui.header page="Test Summary for ${testCase.testClass.shortName?html}:${testCase.methodName?html}" title=true/]
[/#if]
     <meta name="tab" content="tests"/>
</head>
<body>

[#if testCase??]
    [@ui.header page="Test Summary" description='This page summarises information for <strong>${testCase.name?html}</strong> in test class <strong title="${testCase.testClass.name?html}">${testCase.testClass.shortName?html}</strong>.' /]
    <div class="aui-group">
        [@displayDetails /]
        [@displayStats /]
    </div>

    [#if testCase.numberOfFailedRuns > 0]
        [@displayRecentFailures /]
    [/#if]
[#else]
    [@ui.messageBox type="warning" title="Test case not found" /]
[/#if]

</body>
</html>

[#macro displayDetails]
[#if testCaseSummary.lastTestCaseResult??]
    [#if testCaseSummary.lastTestCaseResult.state.displayName == "Failed"]
        [#assign status="fail"/]
    [#else]
        [#assign status="success"/]
    [/#if]
[#else]
    [#assign status="success"/]
[/#if]

[#assign hasTestCasePassed = (status=="success") /]

<div id="planDetailsSummary" class="aui-item">
    <h2>Details</h2>
    <dl class="details-list">
        <dt>Test Class</dt>
        <dd>${testCase.testClass.name?html}</dd>

        <dt>Test</dt>
        <dd>${testCase.methodName?html}</dd>

        [#if testCase.linkedJiraIssueKey?has_content]
            [#import "/lib/tests.ftl" as tests]
            <dt class="issue">[@ww.text name="buildResult.testCase.issue" /]</dt>
            <dd>[@tests.displayLinkedJiraIssue testCase.linkedJiraIssueKey testCase.id /]</dd>
        [/#if]

        [#if testCase.lastRanBuildNumber > 0]
            <dt class="completed">Last ran</dt>
            <dd>
                [@ui.icon type=latestTestCaseState.displayName?lower_case?html text=latestTestCaseState.displayName?html /]
                [@displayBuildInfo brs=testCaseSummary.lastRanBuild hasTestCasePassed=hasTestCasePassed showColorCode=true/]
            </dd>

            [#if testCase.firstRanBuildNumber > 0]
                <dt>First ran</dt>
                <dd>
                    <a href="[@ww.url value='/browse/${immutableBuild.key}-${testCase.firstRanBuildNumber}'/]">#${testCase.firstRanBuildNumber}</a>
                </dd>
            [/#if]

            [#if testCase.numberOfFailedRuns gte 0]
                <dt>Failures</dt>
                <dd>${testCase.numberOfFailedRuns}</dd>
            [/#if]
            [#if testCase.numberOfSuccessRuns gte 0]
                <dt>Successes</dt>
                <dd>${testCase.numberOfSuccessRuns}</dd>
            [/#if]

            [#if status="success"]
                <dt class="successful-since">Passing since</dt>
                [#if testCaseSummary.succeedingSinceBuild??]
                    <dd>[@displayBuildInfo brs=testCaseSummary.succeedingSinceBuild/]</dd>
                [#else]
                    <dd>This test case has never failed.</dd>
                [/#if]
            [#else]
                [#if testCaseSummary.failingSinceBuild??]
                    <dt class="failing-since">[@ww.text name="buildResult.failingsince"/]</dt>
                    <dd>[@displayBuildInfo brs=testCaseSummary.failingSinceBuild/]</dd>

                    [#if testCaseSummary.countFailingSince > 0 ]
                        <dt>Failing for</dt>
                        <dd>[@ww.text name='build.common.build.count'][@ww.param name="value" value=testCaseSummary.countFailingSince /][/@ww.text]</dd>
                    [/#if]
                [#elseif testCaseSummary.failingSinceBuildKey]
                    <dt>[@ww.text name="buildResult.failingsince"/]</dt>
                    <dd>${testCaseSummary.failingSinceBuildKey}</dd>
                [/#if]
            [/#if]
        [/#if]
    </dl>
</div>
[/#macro]

[#macro displayStats]
<div id="planStatsSummary" class="aui-item">
    <h2>Test Statistics</h2>
    <div id="successRate">
        <div class="successRatePercentage">
            <p><span>${testCase.successPercentage}%</span>Successful</p>
        </div>

        <dl>
            <dt class="first">[@ww.text name='build.common.successful' /]:</dt>
            <dd class="first">${testCase.numberOfSuccessRuns} / ${testCase.totalTestRuns}</dd>
            <dt>Average Duration:</dt>
            <dd>${testCase.averageDurationInSeconds} seconds</dd>
        </dl>
    </div>
</div>
[/#macro]

[#macro displayRecentFailures]
    [#import "/fragments/statistics/recentFailures.ftl" as recentFailures]
    <div id="recentFailures">
        <h2>Recent Failures</h2>

        [#if !testCaseSummary.failurePeriods?has_content]
            <p>
                [@ww.text name="build.testCaseSummary.failureDescription.empty"]
                    [@ww.param]${filterController.selectedFilterName?lower_case}[/@ww.param]
                [/@ww.text]
            </p>
        [#else]
            [@recentFailures.listRecentFailures maxResults=10 failurePeriods=testCaseSummary.failurePeriods/]
            <p>
                [@ww.text name="build.testCaseSummary.failureDescription"]
                    [@ww.param]${filterController.selectedFilterName?lower_case}[/@ww.param]
                [/@ww.text]
            </p>
            <ul>
                <li>Average time to fix test when failed: <strong>${dateUtils.formatDurationPretty(testCaseSummary.averageElapsedTime / 1000)}</strong></li>
                <li>Average number of builds between fixes: <strong>${testCaseSummary.averageElapsedBuilds} build(s)</strong></li>
            </ul>
        [/#if]
    </div>
[/#macro]

[#macro displayBuildInfo brs showColorCode=false hasTestCasePassed=""]
    [#import "/lib/resultSummary.ftl" as ps]

    [#if showColorCode]
        [#if hasTestCasePassed]
            [#assign cssClass="Successful"/]
        [#else]
            [#assign cssClass="Failed"/]
        [/#if]
    [#else]
        [#assign cssClass=""/]
    [/#if]

    <span class="${cssClass}">[@ps.buildResultLink immutablePlan.key brs.buildNumber/]</span>
    <span>(${brs.reasonSummary} &ndash; [@ui.time datetime=brs.buildCompletedDate]${brs.relativeBuildDate}[/@ui.time])</span>
[/#macro]
