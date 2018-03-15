[#-- @ftlvariable name="testResults" type="com.atlassian.bamboo.resultsummary.tests.FilteredTestResults" --]
[#-- @ftlvariable name="testSummary" type="com.atlassian.bamboo.resultsummary.tests.TestResultsSummary" --]
[#-- @ftlvariable name="testsMap" type="com.google.common.collect.Multimap<com.atlassian.bamboo.resultsummary.tests.TestClassResultDescriptor, com.atlassian.bamboo.resultsummary.tests.TestCaseResult>" --]

[#import "/lib/menus.ftl" as menu]

[#macro displayTestSummary testResults testSummary displayQuarantined=false showJob=false]
    [#if testSummary.newFailedTestCaseCount > 0]
        [@testsTable id="new-failed-tests" testsMap=testResults.newFailedTests showReason=false showJob=showJob showDuration=true showStackTrace=true isStackTraceExpanded=true caption=testsTableCaption('buildResult.tests.summary.newFailures.title', testSummary.newFailedTestCaseCount) /]
    [/#if]

    [#if testSummary.existingFailedTestCount > 0]
        [@testsTable id="existing-failed-tests" testsMap=testResults.existingFailedTests showReason=true showJob=showJob showDuration=true showFailingSince=true showStackTrace=true isStackTraceExpanded=false caption=testsTableCaption('buildResult.tests.summary.existingFailures.title', testSummary.existingFailedTestCount) /]
    [/#if]

    [#if testSummary.fixedTestCaseCount > 0]
        [@testsTable id="fixed-tests" testsMap=testResults.fixedTests showReason=true showJob=showJob showDuration=true showFailingSince=true caption=testsTableCaption('buildResult.tests.summary.fixed.title', testSummary.fixedTestCaseCount) /]
    [/#if]

    [#if displayQuarantined && testSummary.quarantinedTestCaseCount > 0]
        [@testsTable id="quarantined-tests" testsMap=testResults.quarantinedTests showQuarantineInfo=true showReason=true showJob=showJob showDuration=true showFailingSince=true showStackTrace=true isStackTraceExpanded=true caption=testsTableCaption('buildResult.tests.summary.quarantined.title', testSummary.quarantinedTestCaseCount) /]
    [/#if]
[/#macro]

[#function testsTableCaption titleKey count]
    [#assign fullCaption][@ww.text name=titleKey/] [@ui.itemCount count /][/#assign]
    [#return fullCaption]
[/#function]

[#macro testsTable testsMap showReason showJob showDuration showFailingSince=false showStackTrace=false isStackTraceExpanded=false showQuarantineInfo=false id="" cssClass="" caption=""]
    [#assign testIndex = 0]
    [#assign colspan = 2]
    [#if showStackTrace]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showJob]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showDuration]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showFailingSince]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showQuarantineInfo]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if action.getUser()?? && fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
        [#assign colspan = colspan + 1]
    [/#if]
    <div class="tests-table-container">
        <table class="aui tests-table[#if cssClass?has_content] ${cssClass}[/#if]"[#if id?has_content] id="${id}"[/#if]>
            [#if caption?has_content]<caption><span>${caption}</span></caption>[/#if]
            <thead>
                <tr>
                    [#if showStackTrace]<th class="twixie"></th>[/#if]
                    <th class="status"><span class="assistive">[@ww.text name="buildResult.completedBuilds.status" /]</span></th>
                    <th class="test">[@ww.text name="build.testSummary.test" /]</th>
                    [#if showFailingSince]<th class="failing-since[#if showQuarantineInfo]-small[/#if]">[@ww.text name="buildResult.tests.failingSince" /]</th>[/#if]
                    [#if showQuarantineInfo]<th class="quarantine-info">[@ww.text name="chain.quarantine.test.user" /]</th>[/#if]
                    [#if showJob]<th class="job">[@ww.text name="job.view" /]</th>[/#if]
                    [#if showDuration]<th class="duration">[@ww.text name="buildResult.completedBuilds.duration" /]</th>[/#if]
                    [#if action.getUser()?? &&  fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
                        <th class="actions"></th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#list testsMap.keySet() as testResultClass]
                    [#list testsMap.get(testResultClass) as testResult]
                        [#assign testIndex = testIndex + 1 /]
                        [#assign failingSinceBuild = (action.getFailingSinceForTest(testResult))!('') /]
                        [#assign hasStackTrace = testResult.errors?size gt 0 /]
                        [#assign shouldExpandStackTrace = hasStackTrace && isStackTraceExpanded /]
                        <tr id="testCase-${testResult.testCase.id}" class="${testResult.state.displayName?lower_case?html}[#if (testIndex) % 2 == 0] zebra[/#if] test-case-row-${testResult.testCase.id}[#if showStackTrace && hasStackTrace] [#if shouldExpandStackTrace]expanded[#else]collapsed[/#if][/#if]">
                            [#if showStackTrace]<td class="twixie">[#if hasStackTrace][#if shouldExpandStackTrace][@ui.icon type="collapse" textKey="global.buttons.collapse" /][#else][@ui.icon type="expand" textKey="global.buttons.expand" /][/#if][/#if]</td>[/#if]
                            <td class="status">[@ui.icon type=testResult.state.displayName?lower_case?html text=testResult.state.displayName?html /]</td>
                            <td class="test">
                                <span class="test-class">${testResult.testClassResult.shortName?html}</span>
                                <a href="[@ww.url value=fn.getTestCaseResultUrl(testResult.testCase.testClass.plan.key, testResult.testClassResult.buildResultsSummary.buildNumber, testResult.testCase.id) /]" class="test-name">${testResult.name?html}</a>
                                <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(testResult.testCase.testClass.plan.key, testResult.testCase.id) /]">[@ui.icon type="time" useIconFont=true textKey="buildResult.tests.history" /]</a>
                                [#local testResultOnMaster = action.getTestCaseResultOnMasterBranch(testResult)! /]
                                [#if testResultOnMaster?has_content]
                                    <p class="description">
                                        [#local testResultOnMasterFailed = (testResultOnMaster.state == 'FAILED') /]
                                        [#local testResultOnMasterQuarantined = testResultOnMaster.testCase.quarantined /]
                                        [#if testResultOnMasterFailed]
                                            [#if testResultOnMasterQuarantined]
                                                [#local messageKey = 'buildResult.tests.testOnMaster.failingQuarantined']
                                            [#else]
                                                [#local messageKey = 'buildResult.tests.testOnMaster.failing']
                                            [/#if]
                                        [#else]
                                            [#if testResultOnMasterQuarantined]
                                                [#local messageKey = 'buildResult.tests.testOnMaster.passingQuarantined']
                                            [#else]
                                                [#local messageKey = 'buildResult.tests.testOnMaster.passing']
                                            [/#if]
                                        [/#if]
                                        [@ww.text name=messageKey]
                                            [@ww.param]
                                                [#if navigationContext.currentObject.parent?has_content]
                                                    [#local masterBranchName = navigationContext.currentObject.parent.master.branchName /]
                                                [#else]
                                                    [#local masterBranchName = navigationContext.currentObject.master.branchName /]
                                                [/#if]
                                                <a href="${req.contextPath}/browse/${testResultOnMaster.testCase.testClass.plan.key}/latest">${masterBranchName}</a>[#t]
                                            [/@ww.param]
                                        [/@ww.text]
                                    </p>
                                [/#if]

                                [#local linkedJiraIssueKey=testResult.testCase.linkedJiraIssueKey! /]
                                [@displayLinkedJiraIssue linkedJiraIssueKey testResult.testCase.id/]
                            </td>
                            [#if showFailingSince]<td class="failing-since">
                                [#if failingSinceBuild?has_content && failingSinceBuild.buildNumber != testResult.testClassResult.buildResultsSummary.buildNumber]
                                    [#if showJob]
                                        <a href="${req.contextPath}/browse/${testResult.testCase.testClass.plan.parent.key}-${failingSinceBuild.buildNumber}/" class="failing-since" title="[@ww.text name="buildResult.tests.failingSinceBuild" /] #${testResult.failingSince}"><span class="assistive">[@ww.text name="buildResult.tests.failingSinceBuild" /] </span>#${testResult.failingSince}</a>
                                    [#else]
                                        <a href="${req.contextPath}/browse/${testResult.testCase.testClass.plan.key}-${failingSinceBuild.buildNumber}/" class="failing-since" title="[@ww.text name="buildResult.tests.failingSinceBuild" /] #${testResult.failingSince}"><span class="assistive">[@ww.text name="buildResult.tests.failingSinceBuild" /] </span>#${testResult.failingSince}</a>
                                    [/#if]
                                    [#if showReason]<span class="reason">(${failingSinceBuild.reasonSummary})</span>[/#if]
                                [/#if]
                            </td>[/#if]
                            [#if showQuarantineInfo]
                            <td class="quarantine-data">
                                [#if testResult.testCase.quarantineStatistics??]
                                    [#local quarantineUser=ctx.getBambooUser(testResult.testCase.quarantineStatistics.quarantiningUsername) /]
                                    [#if quarantineUser??]
                                        [@ui.displayUserGravatar userName=quarantineUser.name size='18' class="avatar" alt="${quarantineUser.fullName?html}"/]
                                        <a href="${req.contextPath}/browse/user/${quarantineUser.name?url}">[@ui.displayUserFullName user=quarantineUser/]</a>
                                    [#else]
                                        [@ww.text name="chain.quarantine.test.noUser" /]
                                    [/#if]
                                    [#local quarantineDate = testResult.testCase.quarantineStatistics.quarantineDate /]
                                    <br/>[@ui.time datetime=quarantineDate showTitle=true]${durationUtils.getRelativeDate(quarantineDate)} [@ww.text name="global.dateFormat.ago"/][/@ui.time]
                                [#else]
                                    <em class="disabled">[@ww.text name='builder.common.tests.unleashed' /]</em>
                                [/#if]
                            </td>
                            [/#if]
                            [#if showJob]<td class="job"><a href="${req.contextPath}/browse/${testResult.testClassResult.buildResultsSummary.planResultKey}/"[#if testResult.testCase.testClass.plan.description?has_content] title="${testResult.testCase.testClass.plan.description}"[/#if]>${testResult.testCase.testClass.plan.buildName}</a></td>[/#if]
                            [#if showDuration]<td class="duration">${testResult.prettyDuration?html}</td>[/#if]
                            [#if action.getUser()?? &&  fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
                                [@ww.url id="quarantineUrl" action="quarantineTest" namespace="/build/admin" testId="${testResult.testCase.id}" returnUrl=currentUrl /]
                                [@ww.url id="unleashUrl" action="unleashTest" namespace="/build/admin" testId="${testResult.testCase.id}" returnUrl=currentUrl /]
                                <td class="actions" data-quarantine-url="${quarantineUrl}" data-unleash-url="${unleashUrl}">
                                    [#local actionsText][@ww.text name="menu.actions" /][/#local]
                                    [@ui.standardMenu triggerText="" id="testResultActions-${testResult.testCase.id}" icon="configure" useIconFont=true subtle=true]

                                        [@displayTestToJiraActions linkedJiraIssueKey=linkedJiraIssueKey testCaseId=testResult.testCase.id planResultKey=testResult.testClassResult.buildResultsSummary.planResultKey returnUrl=currentUrl /]

                                        [#local quarantineButtonClass = "quarantine-action" /]
                                        [#if testResult.testCase.isQuarantined()]
                                            [#local quarantineTitleKey = "builder.common.tests.unquarantine" /]
                                            [#local quarantineButtonClass = quarantineButtonClass + " quarantined" /]
                                            [#local quarantineButtonUrl = unleashUrl /]
                                        [#else]
                                            [#local quarantineTitleKey = "builder.common.tests.quarantine" /]
                                            [#local quarantineButtonUrl = quarantineUrl /]
                                        [/#if]
                                        [@ui.displayLink
                                                titleKey=quarantineTitleKey
                                                href=quarantineButtonUrl
                                                icon="quarantine"
                                                inList=true
                                                cssClass=quarantineButtonClass
                                                id="toggleTestIgnore-${testResult.name?html}-${testResult.testCase.testClass.name?html}" [#-- <-- for functional tests:--]
                                                mutative=true
                                        /]

                                    [/@ui.standardMenu]
                                </td>
                            [/#if]
                        </tr>
                        [#if showStackTrace && hasStackTrace]
                            <tr class="stack-trace">
                                <td class="code" colspan="${colspan}">
                                    <pre>[#list testResult.errors as error]${htmlUtils.getFirstNLinesWithTrailer(error.content,8)?html}[/#list]</pre>
                                </td>
                            </tr>
                        [/#if]
                    [/#list]
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

        [#if showStackTrace]
            <div class="aui-toolbar inline controls">
                <ul class="toolbar-group">
                    <li class="toolbar-item collapse-all">
                        <a class="toolbar-trigger">[@ui.icon type="collapse-all" textKey="global.buttons.collapse.all"/]</a>
                    </li>
                    <li class="toolbar-item expand-all">
                        <a class="toolbar-trigger">[@ui.icon type="expand-all" textKey="global.buttons.expand.all"/]</a>
                    </li>
                </ul>
            </div>
        [/#if]
    </div>
[/#macro]

[#-- Show JIRA issue link if exists --]
[#macro displayLinkedJiraIssue linkedJiraIssueKey testCaseId]
    <div class="linked-jira-issue test-case-${testCaseId}"[#if linkedJiraIssueKey?has_content] data-jira-issue-key="${linkedJiraIssueKey}"[/#if]>
    [#if linkedJiraIssueKey?has_content]
        <script type="text/javascript">
            BAMBOO.PLAN.LinkedJiraIssueDescription({
                planKey: '${(((immutablePlan.parent)!immutablePlan)!immutableBuild).key}',
                issueSelector: '.linked-jira-issue.test-case-${testCaseId}'
            });
        </script>
    [/#if]
    </div>
[/#macro]

[#macro displayTestToJiraActions linkedJiraIssueKey testCaseId planResultKey returnUrl ]
    [#local buttonCssClass="create-jira-issue-for-test-action"/]
    [#if linkedJiraIssueKey?has_content][#local buttonCssClass=buttonCssClass + " hidden"/][/#if]
    [@ww.url id="editCreateNewJiraIssueForTest" action="editCreateNewJiraIssueForTest" namespace="/ajax" testCaseId=testCaseId planResultKey=planResultKey returnUrl=returnUrl /]
    [@ui.displayLinkForAUIDialog id="editCreateNewJiraIssue-${testCaseId}"
            href=editCreateNewJiraIssueForTest
            titleKey="build.testResult.createNewJiraIssue.button"
            icon="jiraissue-new" [#-- change to something like jiraissue-bug or jiraissue-broken-test --]
            inList=true
            cssClass=buttonCssClass
    /]

    [#local buttonCssClass="link-test-to-jira-action"/]
    [#if linkedJiraIssueKey?has_content][#local buttonCssClass=buttonCssClass + " hidden"/][/#if]
    [@ww.url id="linkTestToJiraIssue" action="editLinkTestToJiraIssue" namespace="/ajax" testCaseId=testCaseId planKey=planResultKey.planKey returnUrl=returnUrl /]
    [@ui.displayLinkForAUIDialog id="linkTestToJiraIssue-${testCaseId}"
            href=linkTestToJiraIssue
            titleKey="build.testResult.linkWithJiraIssue.button"
            icon="jiraissue-new" [#-- change to something like jiraissue-link --]
            inList=true
            cssClass=buttonCssClass
    /]

    [#local unlinkHref = req.contextPath + "/ajax/unlinkTestToJiraIssue.action?testCaseId=${testCaseId}&planKey=${planResultKey.planKey}" /]
    [#local buttonCssClass="unlink-test-to-jira-action"/]
    [#if !linkedJiraIssueKey?has_content][#local buttonCssClass=buttonCssClass + " hidden"/][/#if]
    [@ui.displayLink
            titleKey="build.testResult.unlinkWithJiraIssue.button"
            href=unlinkHref
            icon="jiraissue-unknown" [#-- change to something like unlink --]
            inList=true
            cssClass=buttonCssClass
            data="data-test-case-id='${testCaseId}'"/]
[/#macro]

[#macro displayTestInfo testSummary ]
    [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
    [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
    [#assign hasQuarantinedTests=testSummary.quarantinedTestCaseCount gt 0 /]
    <ul id="testsSummary">
        <li id="testsSummaryTotal">
            [@ui.icon type="job"/]
            [@ww.text name='buildResult.tests.summary.testsTotal']
                [@ww.param name="value" value=testSummary.totalTestCaseCount /]
            [/@ww.text]
        </li>
        [#if testSummary.hasFailedTestResults() ]
            <li id="testsSummaryFailed">
                [@ui.icon type="failed"/]
                [@ww.text name='buildResult.tests.summary.failedTotal']
                    [@ww.param name="value" value=testSummary.failedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
        [#if hasNewlyFailingTests?? && hasNewlyFailingTests]
            <li id="testsSummaryFixed">
                [@ww.text name='buildResult.tests.summary.newFailedCount']
                    [@ww.param name="value" value=testSummary.newFailedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
        [#if hasFixedTests]
            <li id="testsSummaryFixed">
                [@ww.text name='buildResult.tests.summary.fixedSummary']
                    [@ww.param name="value" value=testSummary.fixedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
        [#if hasQuarantinedTests]
            <li id="testsSummaryQuarantined">
                [@ui.icon type="failed"/]
                [@ww.text name='buildResult.tests.summary.quarantinedSummary']
                    [@ww.param name="value" value=testSummary.quarantinedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
        <li id="testsSummaryDuration">
            [@ui.icon type="time" useIconFont=true/]
            [@ww.text name='buildResult.tests.summary.testDuration']
                [@ww.param]${durationUtils.getPrettyPrint(testSummary.totalTestDuration)}[/@ww.param]
            [/@ww.text]
        </li>
    </ul>
[/#macro]
