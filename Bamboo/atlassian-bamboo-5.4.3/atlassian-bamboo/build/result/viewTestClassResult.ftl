[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewTestClassResultAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewTestClassResultAction" --]
[#--Not currently used for anything!--]

<html>
<head>
    [@ui.header pageKey='buildResult.testClass.title' object='${immutableBuild.key}-${buildResultsSummary.buildNumber} ${testClassResult.shortName?html}' title=true/]
    <meta name="tab" content="tests"/>
</head>
<body>

    <div class="section">
        <h2>${testClassResult.shortName?html}</h2>

    <p>
        The below summarizes the result of the test suite: ${testClassResult.name?html} in
        build ${buildResultsSummary.buildNumber} of ${immutableBuild.name}.

        It includes a listing of all unit tests in this class.

        [#if testClassResult.failedTestCount gt 0]
            Under each failed unit test is the error associated with the test.
        [/#if]
    </p>

[#if  testClassResult.getFailedTestCount() gt 0]
    [#assign  state="Failed"/]
[#else]
    [#assign  state="Successful"/]
[/#if]

[@ui.bambooInfoDisplay float=true]
    [@ww.label labelKey='buildResult.testClass.status' value="${state}" cssClass='${state}' /]
    [@ww.label labelKey='buildResult.testClass.fullName' name='testClassResult.name' /]
[/@ui.bambooInfoDisplay]

[@ui.bambooInfoDisplay float=true]
    [@ww.label labelKey='buildResult.testClass.totalDuration' value='${durationUtils.getPrettyPrint(testClassResult.duration)}' /]
[/@ui.bambooInfoDisplay]

[@ui.clear /]

<div class="section">
    <h2>Tests</h2>
    <p>The test suite had a total of ${testClassResult.testCaseResults.size()} tests in build ${buildResultsSummary.buildNumber}.
        [#if testClassResult.failedTestCount gt 0]
            <strong class="${state}">${testClassResult.failedTestCount}</strong> test(s) failed.
        [#else]
            <strong class="${state}">All tests</strong> were successful.
        [/#if]
    </p>
    <table class="testResults aui" cellspacing="0" summary="Unit Test Results">
        <thead>
            <tr>
                <th>
                    Test Name
                </th>
                [#if testClassResult.failedTestCount gt 0 ]
                    <th>
                        Failing Since Build
                    </th>
                [/#if]
                <th>
                    Duration
                </th>
            </tr>
        </thead>
        [#list testClassResult.testCaseResults as testResult]

            [@ww.url id='testCaseUrl' value=fn.getTestCaseResultUrl(immutableBuild.key, buildResults.buildNumber, testResult.testCase.id) /]


            <tr>
                <td class="testMethodName ${testResult.state.displayName}"  title="${testClassResult.name?html}:${testResult.name?html}">
                    <a id="test:${testClassResult.name?html}:${testResult.name?html}" href="${testCaseUrl}">
                        ${testResult.methodName?html}
                    </a>
                    [#if testResult.errors.size() gt 0]
                    <div class="testCaseErrorLogSection">
                        <pre class="outputErrorLog">
                        [#list testResult.errors as error]
${error.content?html}
                        [/#list]
                    </pre></div>
                    [/#if]

                </td>

                [#if testClassResult.failedTestCount gt 0 ]
                <td>
                    [#if  testResult.failingSince > -1]
                         [#assign failingSinceBuild = (action.getFailingSinceForTest(testResult))!('')]
                         [#if failingSinceBuild?has_content]
                            <a href="${req.contextPath}/browse/${immutableBuild.key}-${failingSinceBuild.buildNumber}">${immutableBuild.key}-${failingSinceBuild.buildNumber}</a>
                         [#else]
                            [#assign failingSinceBuildString = (action.getFailingSinceForTestString(buildResultsSummary, testResult))!('')]
                            [#if  failingSinceBuildString?has_content]
                                 ${failingSinceBuildString}
                            [#else]
                                 Cannot find when the test started failing
                            [/#if]
                         [/#if]
                     [/#if]
                </td>
                [/#if]

                <td class="testDuration">
                    ${testResult.prettyDuration} 
                </td>
            </tr>
        [/#list]
    </table>
</div>
</div>
</body>
</html>
