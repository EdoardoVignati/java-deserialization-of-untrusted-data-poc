[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]

<html>
<head>
    [@ui.header pageKey='buildResult.testCase.title' object='${immutableBuild.key}-${buildResultsSummary.buildNumber} ${action.methodName?html}' title=true/]
    <meta name="tab" content="tests"/>
</head>

<body>
    [@ui.header pageKey='buildResult.testCase.title' object=action.methodName?html/]
    <div class="noResult">
        <div class="message">[@ww.text name='buildResult.testCase.noTestCaseResult'/]</div>
        <a href="${req.contextPath}/browse/${immutableBuild.key}/test/case/${action.testCaseId}">[@ww.text name='buildResult.testCase.history'/]</a>
    </div>
</body>
</html>
