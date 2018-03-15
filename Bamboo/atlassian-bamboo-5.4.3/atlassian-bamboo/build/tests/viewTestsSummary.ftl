[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.tests.ViewTestsSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.tests.ViewTestsSummary" --]

<html>
<head>
    <title>[@ww.text name="build.testSummary.title"/]</title>
     <meta name="tab" content="tests"/>
</head>

<body>
    [@cp.filterDropDown filterController=filterController/]
    [@ui.header pageKey='build.testSummary.heading' /]
    <p>
        [@ww.text name="build.testSummary.description"]
            [@ww.param]${filterController.selectedFilterName}[/@ww.param]
            [@ww.param]${immutableBuild.name}[/@ww.param]
        [/@ww.text]
    </p>

[@dj.tabContainer headings=[action.getText('build.testSummary.mostFailingTest.title'), action.getText('build.testSummary.longestToFix.title'),
                  action.getText('build.testSummary.longestRunningTest.title'), action.getText('build.testSummary.numberOfTests.title')]
                  selectedTab='${selectedTab!}']

    [@dj.contentPane labelKey='build.testSummary.mostFailingTest.title']
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
                            [@ww.text name="build.testSummary.mostFailingTest.mostRecent"/]
                        </th>
                    </tr>
                </thead>
                <tbody>
                    [#list mostFailingTests as testCasePair]
                        [#assign  testCase = testCasePair.first /]
                        [@ww.url value=fn.getViewTestCaseHistoryUrl(immutableBuild.key, testCase.id) id='testCaseUrl' /]
                        <tr>
                            <td title="${testCase.testClass.name?html}:${testCase.name?html}" class='testCase'>
                                <div class="title">
                                <a href="${testCaseUrl}">${testCase.methodName!?html}</a>
                                </div>
                                <div class="details">${testCase.className!?html}</div>
                            </td>
                            <td>
                                [@ui.barGraph title='${testCasePair.second} failures' width='${action.getFailureBarWidth(testCasePair.second)}' color='red' /]
                                ${testCasePair.second}
                            </td>
                            <td class="recentFailures">
                                [#assign failures=action.getRecentFailures(testCase, 5)/]
                                [#list failures as failurePair]
                                    [@ww.url id='testResultUrl' value=fn.getTestCaseResultUrl(buildKey, failurePair.second, failurePair.first.testCase.id) /]
                                    <a href="${testResultUrl}">${failurePair.second}</a>[#if failurePair_has_next],[/#if]
                                [/#list]
                                [#if testCasePair.second gt 5]
                                    [@ww.text name="build.testSummary.moreFailures"]
                                        [@ww.param value=(testCasePair.second - 5)/]
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
    [/@dj.contentPane]

    [@dj.contentPane labelKey='build.testSummary.longestToFix.title']
        [#if longestTimeToFixTests?has_content && longestTimeToFixTests?size gt 0]
        <table class="testSummary aui" summary="[@ww.text name="build.testSummary.longestToFix.title"/]" id="topTenLongestFixTests">
            <thead>
                <tr>
                    <th>
                        [@ww.text name="build.testSummary.test"/]
                    </th>
                    <th>
                        [@ww.text name="build.testSummary.longestToFix.averageBuilds"/]
                    </th>
                </tr>
            </thead>
            <tbody>
                [#list longestTimeToFixTests as testCasePair]
                    [#assign  testCase = testCasePair.first /]
                    [@ww.url value=fn.getViewTestCaseHistoryUrl(immutableBuild.key, testCase.id) id='testCaseUrl' /]
                    <tr>
                        <td title="${testCase.testClass.name?html}:${testCase.name?html}" class='testCase'>
                            <div class="title">
                            <a href="${testCaseUrl}">${testCase.methodName!?html}</a>
                            </div>
                            <div class="details">${testCase.testClass.name!?html}</div>
                        </td>
                        <td>
                            ${testCasePair.second}
                        </td>
                    </tr>
                [/#list]
            </tbody>
        </table>
        [#else]
            <p>
                [@ww.text name="build.testSummary.fixed.empty"]
                    [@ww.param]${filterController.selectedFilterName}[/@ww.param]
                [/@ww.text]
            </p>
        [/#if]
    [/@dj.contentPane]

    [@dj.contentPane labelKey='build.testSummary.longestRunningTest.title']
		[#if longestRunningTests?has_content && longestRunningTests?size gt 0]
			<table class="testSummary aui" summary="[@ww.text name="build.testSummary.longestRunningTest.title"/]" id="topTenLongestRunningTests">
                <thead>
                    <tr>
                        <th>
                            [@ww.text name="build.testSummary.test"/]
                        </th>
                        <th>
                            [@ww.text name="build.testSummary.longestRunningTest.averageDuration"/]
                        </th>
                    </tr>
                </thead>
                <tbody>
                    [#list longestRunningTests as testCase]
                        [@ww.url value=fn.getViewTestCaseHistoryUrl(immutableBuild.key, testCase.id) id='testCaseUrl' /]
                        <tr>
                            <td title="${testCase.testClass.name?html}:${testCase.name?html}" class='testCase'>
                                <div class="title">
                                <a href="${testCaseUrl}">${testCase.methodName!?html}</a>
                                </div>
                                <div class="details">${testCase.className!?html}</div>
                            </td>
                            <td class="">
                                ${durationUtils.getPrettyPrint(testCase.averageDuration)}</span>
                            </td>
                        </tr>
                    [/#list]
                </tbody>
			</table>
            <p class="subGrey">[@ww.text name="build.testSummary.longestRunning.footnote" /]</p>
		[#else]
			<p>[@ww.text name="build.testSummary.longestRunning.empty" /]</p>
		[/#if]
    [/@dj.contentPane]

[#if dataset??]
    [@dj.contentPane labelKey='build.testSummary.numberOfTests.title']
        <p>
            [@ww.text name="build.testSummary.numberOfTests.description"/]
            [@ww.action name="viewReportChart" namespace="/charts" executeResult="true" /]
        </p>
    [/@dj.contentPane]
[/#if]

[/@dj.tabContainer]


</body>
</html>
