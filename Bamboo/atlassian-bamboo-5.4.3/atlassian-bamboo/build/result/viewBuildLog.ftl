[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildLogs" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildLogs" --]

<html>
<head>
	[@ui.header pageKey='buildResult.logs.title' object='${immutableBuild.name} ${buildResultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="logs"/>
</head>

<body>
    [@ui.header pageKey='buildResult.logs.title' /]
    [#if buildLogs?has_content]
        <p>
            [@ww.text name='buildResult.logs.totalLines' ][@ww.param value=totalLines /][/@ww.text]
            [#if buildLogsTooLong]
                [@ww.text name='buildResult.logs.outputTruncated' ][@ww.param value=maxLinesToShow /][/@ww.text]
            [/#if]
            [#if action.buildResultsSummary.inProgress]
                <a id="logs-viewJobSummary" href="${req.contextPath}/browse/${buildResultsSummary.planResultKey}">[@ww.text name='buildResult.logs.view.livelogs'/]</a>
                &nbsp;|&nbsp;
            [/#if]
            <a href="${req.contextPath}/download/${immutableBuild.key}/build_logs/${buildResultsSummary.planResultKey}.log?disposition=attachment">[@ww.text name='buildResult.logs.download'/]</a> or
            <a href="${req.contextPath}/download/${immutableBuild.key}/build_logs/${buildResultsSummary.planResultKey}.log">[@ww.text name='buildResult.logs.view'/]</a>
            [@ww.text name='buildResult.logs.fullBuildLog'/]
        </p>

        [@ui.displayLogLines buildLogs /]
    [#else]
        <p>[@ww.text name='buildResult.logs.noLogsFound'/]</p>
    [/#if]
</body>
</html>