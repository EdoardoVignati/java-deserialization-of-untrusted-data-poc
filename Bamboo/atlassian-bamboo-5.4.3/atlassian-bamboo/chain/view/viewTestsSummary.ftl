[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.tests.ViewTestsSummaryForPlan" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.tests.ViewTestsSummaryForPlan" --]

<html>
<head>
    [@ui.header pageKey='build.testSummary.title' object=immutablePlan.name title=true /]
    <meta name="tab" content="tests"/>
</head>

<body>
[@cp.filterDropDown filterController=filterController/]
[@ui.header pageKey='build.testSummary.heading' /]

<h2>[@ww.text name='build.testSummary.mostFailingTest.title' /]</h2>

        [#if mostFailingTests?has_content && mostFailingTests?size gt 0]
        <table class="testSummary aui" summary="[@ww.text name="build.testSummary.mostFailingTest.title"/]" id="topTenFailingTests">
            <thead>
            <tr>
                <th>
                    [@ww.text name="build.testSummary.test"/]
                </th>
                <th>
                    [@ww.text name="build.testSummary.mostFailingTest.timesFailed"/]
                </th>
                <th>
                    [@ww.text name="job.common.title"/]
                </th>
                <th>
                    [@ww.text name="build.testSummary.mostFailingTest.mostRecent"/]
                </th>
            </tr>
            </thead>
            <tbody>
                [#list mostFailingTests as testCasePair]
                    [#assign  testCase = testCasePair.first /]
                    [#assign job = testCase.testClass.plan /]

                    [@ww.url value=fn.getViewTestCaseHistoryUrl(job.key, testCase.id) id='testCaseUrl' /]
                <tr>
                    <td title="${testCase.methodName!?html}" class='testCase'>
                        ${testCase.testClass.shortName!?html} <a href="${testCaseUrl}">${testCase.name!?html}</a>
                    </td>
                    <td>
                        [@ui.barGraph title='${testCasePair.second} failures' width='${action.getFailureBarWidth(testCasePair.second)}' color='red' /]
                                ${testCasePair.second}
                    </td>
                    <td>
                        ${job.buildName}
                    </td>
                    <td class="recentFailures">
                        [#assign failures=action.getRecentFailures(testCase, 3)/]
                        [#list failures as failurePair]
                            [@ww.url id='testResultUrl' value=fn.getTestCaseResultUrl(job.planKey, failurePair.second, failurePair.first.testCase.id) /]
                            <a href="${testResultUrl}">#${failurePair.second}</a>[#if failurePair_has_next],[/#if]
                        [/#list]
                        [#if testCasePair.second gt 5]
                            [@ww.text name="build.testSummary.moreFailures"]
                                [@ww.param value=(testCasePair.second - 3)/]
                            [/@ww.text]
                        [/#if]
                    </td>
                </tr>
                [/#list]
            </tbody>
        </table>
        [#else]
        <p>
            [@ww.text name="build.testSummary.failed.empty"]
                    [@ww.param]${filterController.selectedFilterName}[/@ww.param]
                [/@ww.text]
        </p>
        [/#if]



</body>
</html>
