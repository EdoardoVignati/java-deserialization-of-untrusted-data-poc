[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]

<html>
<head>
    [#assign commonTestCaseResultData = testCaseResults.get(0)/]
    [@ui.header pageKey='buildResult.testCase.title' object='${immutableBuild.key}-${buildResultsSummary.buildNumber} ${commonTestCaseResultData.methodName?html}' title=true/]
    <meta name="tab" content="tests"/>
</head>

<body>

    [#assign testCaseTitleDescription][#rt]
        [@ww.text name='buildResult.testCase.summary']
            [@ww.param]${commonTestCaseResultData.methodName?html}[/@ww.param]
            [@ww.param name="value" value="${buildResultsSummary.buildNumber}"/]
            [@ww.param]${immutableBuild.name}[/@ww.param]
        [/@ww.text]
        <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(buildKey, commonTestCaseResultData.testCase.id) /]">[@ui.icon type="time" useIconFont=true textKey="buildResult.testCase.history" /]</a>
    [/#assign][#lt]

    [@ui.header pageKey='buildResult.testCase.title' object=commonTestCaseResultData.methodName?html description=testCaseTitleDescription/]

    <div class="aui-group">

        [#assign commonTestClassResultData = testClassResults.get(0)/]
        <div class="aui-item">
            <dl class="testcase details-list">
                <dt class="description">[@ww.text name="buildResult.testCase.description" /]</dt>
                <dd>${testCaseResults.get(0).methodName?html}</dd>
                <dt class="class">[@ww.text name="buildResult.testCase.class" /]</dt>
                <dd>${commonTestClassResultData.name?html}</dd>
                <dt class="method">[@ww.text name="buildResult.testCase.method" /]</dt>
                <dd>${testCaseResults.get(0).name?html}</dd>
                [#if commonTestCaseResultData.testCase.linkedJiraIssueKey?has_content]
                    [#import "/lib/tests.ftl" as tests]
                    <dt class="issue">[@ww.text name="buildResult.testCase.issue" /]</dt>
                    <dd>[@tests.displayLinkedJiraIssue commonTestCaseResultData.testCase.linkedJiraIssueKey commonTestCaseResultData.testCase.id /]</dd>
                [/#if]
            </dl>
        </div>

        [#assign durations=''/]
        [#assign statusValues=''/]
        [#list testCaseResults as testCaseResult]
            [#if durations?has_content]
                [#assign durations=durations+', ']
            [/#if]
            [#if statusValues?has_content]
                [#assign statusValues=statusValues+', ']
            [/#if]
            [#assign durations=durations+testCaseResult.getPrettyDuration()/]

            [#assign statusValues]
                ${statusValues} ${testCaseResult.state.displayName}[#if  testCaseResult.deltaState != "NONE" && testCaseResult.deltaState != "PASSING"] (${testCaseResult.deltaState.displayName})[/#if]
            [/#assign]
        [/#list]
        <div class="aui-item">
            <dl class="testcase details-list">
                <dt class="duration">[@ww.text name="buildResult.testCase.duration" /]</dt>
                <dd>${durations}</dd>
                <dt class="status">[@ww.text name="buildResult.testCase.status" /]</dt>
                <dd>${statusValues}</dd>
            </dl>
        </div>
    </div>

    [#list testCaseResults as testCaseResult]
        [#if testCaseResult.errors?has_content]
            <div class="testCaseErrorLogSection">
                <h2>Error Log</h2>
                <pre class="outputErrorLog">[#rt]
                    [#list testCaseResult.errors as error]
                        ${error.content?trim?html}[#t]
                    [/#list]
                </pre>[#lt]
            </div>
        [/#if]
    [/#list]

</body>
</html>
