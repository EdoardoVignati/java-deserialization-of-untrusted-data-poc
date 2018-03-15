[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResultsTests" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResultsTests" --]
<html>
<head>
    [@ui.header pageKey='buildResult.tests.title' object='${immutableBuild.name} ${buildResultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="tests"/>
</head>
<body>
[#if action.showSuccess()]
    [@ww.action name="viewBuildResultsSuccessfulTests" executeResult="true" /]
[#else]
    [@ww.action name="viewBuildResultsFailedTests" executeResult="true" /]
[/#if]]
</body>
</html>