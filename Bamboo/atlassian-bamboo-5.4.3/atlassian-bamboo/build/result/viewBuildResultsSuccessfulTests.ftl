[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResultsSuccessfulTests" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResultsSuccessfulTests" --]
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
    <li class="on">
        <a href="${successfulLink}">[@ww.text name='buildResult.tests.summary.successful' /][#if buildResultsSummary.testResultsSummary.successfulTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.successfulTestCaseCount})[/#if]</a>
    </li>
    [#if testSummary.hasQuarantinedTestResults()]
        <li>
            <a href="${quarantinedLink}">[@ww.text name='buildResult.tests.summary.quarantined.short' /][#if buildResultsSummary.testResultsSummary.quarantinedTestCaseCount > 0]
                (${buildResultsSummary.testResultsSummary.quarantinedTestCaseCount})[/#if]</a>
        </li>
    [/#if]
    [#if user??]
    <li>
        [@ui.displayIdeIcon/]
    </li>
    [/#if]
</ul>

    [#if buildResults?? && buildResults.successfulTestResults?has_content && (pager.page.list)?has_content]
        [#assign successfulTests = pager.page.list]

        <p class="successfulTestsText">
            [@ww.text name='buildResult.tests.successful.description']
                [@ww.param value='${buildResults.successfulTestResults.size()}'/]
            [/@ww.text]
            [#if testSummary.fixedTestCaseCount gt 0]
                [@ww.text name='buildResult.tests.successful.fixed']
                    [@ww.param value='${testSummary.fixedTestCaseCount}'/]
                [/@ww.text]
            [/#if]
        </p>

        [#if pager.hasNextPage || pager.hasPreviousPage]
            [@ww.url id='allSuccessfulLink'
                action='viewBuildResultsSuccessfulTests'
                namespace='/build/result'
                buildNumber='${buildNumber}'
                buildKey='${immutableBuild.key}'
                pageSize='${(buildResults.successfulTestResults.size())!"999999"}'
            /]
            <a href="${allSuccessfulLink}">[@ww.text name='buildResult.tests.successful.showAll' /]</a>
        [/#if]

        [#if testSummary.fixedTestCaseCount > 0]
            [@tests.testsTable id="fixed-tests" testsMap=buildResultsSummary.filteredTestResults.fixedTests showReason=false showJob=false showDuration=true showStackTrace=false isStackTraceExpanded=false caption=tests.testsTableCaption('buildResult.tests.summary.fixed.title', testSummary.fixedTestCaseCount) /]
        [/#if]

        [#assign successfulTestsText]
            [@ww.text name='buildResult.tests.summary.successful.all'/]
        [/#assign]
        [@successTable id="successful-tests" successfulTests=successfulTests caption=successfulTestsText/]
    [#else]
        [@ww.text name='buildResult.tests.successful.none' /]
    [/#if]
</body>
</html>

[#macro successTable successfulTests caption="" id="" cssClass=""]
    [#assign testIndex = 0]
    [#assign colspan = 3]

    <div class="tests-table-container">
        <table class="aui tests-table[#if cssClass?has_content] ${cssClass}[/#if]"[#if id?has_content] id="${id}"[/#if]>
            [#if caption?has_content]<caption><span>${caption}</span></caption>[/#if]
            <thead>
                <tr>
                    <th class="status"><span class="assistive">[@ww.text name="buildResult.completedBuilds.status" /]</span></th>
                    <th class="test">[@ww.text name="build.testSummary.test" /]</th>
                    <th class="duration">[@ww.text name="buildResult.completedBuilds.duration" /]</th>
                    [#if action.getUser()?? &&  fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
                        <th class="actions"></th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#list successfulTests as testResult]
                    [#assign testIndex = testIndex + 1]
                    <tr class="${testResult.state.displayName?lower_case?html}[#if (testIndex) % 2 == 0] zebra[/#if] test-case-row-${testResult.testCaseId}">
                        <td class="status">[@ui.icon type=testResult.state.displayName?lower_case?html text=testResult.state.displayName?html /]</td>
                        <td class="test">
                            <span class="test-class">${testResult.shortClassName?html}</span>
                            <a href="[@ww.url value=fn.getTestCaseResultUrl(immutablePlan.key,buildResultsSummary.buildNumber, testResult.testCaseId) /]" class="test-name">${testResult.actualMethodName?html}</a>
                            <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(immutablePlan.key, testResult.testCaseId) /]">[@ui.icon type="time" useIconFont=true textKey="buildResult.tests.history" /]</a>

                            [#local linkedJiraIssueKey=action.getLinkedJiraIssueForTestCase(testResult.testCaseId)!]
                            [@tests.displayLinkedJiraIssue linkedJiraIssueKey testResult.testCaseId /]
                        </td>
                        <td class="duration">${testResult.prettyDuration?html}</td>
                        [#if action.getUser()?? &&  fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
                            <td class="actions">
                                [#local actionsText][@ww.text name="menu.actions" /][/#local]
                                [@ui.standardMenu triggerText="" id="testResultActions-successfulTestsTable-${testResult.testCaseId}" icon="configure" useIconFont=true subtle=true]
                                    [@tests.displayTestToJiraActions linkedJiraIssueKey=linkedJiraIssueKey testCaseId=testResult.testCaseId planResultKey=typedPlanResultKey returnUrl=currentUrl /]
                                [/@ui.standardMenu]
                            </td>
                        [/#if]
                    </tr>
                [/#list]
            </tbody>
        </table>
        [@dj.simpleDialogForm triggerSelector=".create-jira-issue-for-test-action"
                width=680
                height=520
                headerKey="build.testResult.createNewJiraIssue.title"
                submitCallback="BAMBOO.TESTACTIONS.onReturnFromLinkingIssueManually" /]
        [@dj.simpleDialogForm triggerSelector=".link-test-to-jira-action"
                width=500
                height=280
                headerKey="build.testResult.linkWithJiraIssue.title"
                submitLabelKey="build.testResult.linkWithJiraIssue.link"
                submitCallback="BAMBOO.TESTACTIONS.onReturnFromLinkingIssueManually" /]

        [@cp.pagination /]
    </div>
[/#macro]
