[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainLogs" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainLogs" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#assign i18nPlanPrefix = fn.getPlanI18nKeyPrefix(immutablePlan)/]
<html>
<head>
	[@ui.header pageKey='Logs' object='${immutablePlan.key} ${(resultsSummary.buildNumber)!}' title=true /]
    <meta name="tab" content="logs"/>
</head>

<body>
    [@ui.header pageKey='Logs' /]
    [#if resultsSummary??]
        [@displayAllLogs /]
    [#else]
        <p>[@ww.text name=i18nPlanPrefix+'Result.logs.noLogsFound'/]</p>
    [/#if]

</body>
</html>


[#macro displayAllLogs]
    <div class="logs-table-container">
        <table id="job-logs" class="aui chain-logs-table">
            <caption id="logsCaption"><span>[@ww.text name=i18nPlanPrefix+'Result.logs.description'/]</span></caption>
            <colgroup>
                <col />
                <col />
                <col width="250"/>
            </colgroup>
            <thead>
                <td class="twixie">
                    <ul>
                        <li class="expand-all">
                            <span role="link">[@ui.icon type="expand" /][@ww.text name="global.buttons.expand.all" /]</span>
                        </li>
                        <li class="collapse-all">
                            <span role="link">[@ui.icon type="collapse" /][@ww.text name="global.buttons.collapse.all" /]</span>
                        </li>
                    </ul>
                </td>
                <th>[@ww.text name="Job"/]</th>
                <th>[@ww.text name="Logs"/]</th>
            </thead>
            <tbody>
                [#if resultsSummary.orderedJobResultSummaries.size() == 1]
                    [#assign singleJobPlan = true /]
                [#else]
                    [#assign singleJobPlan = false /]
                [/#if]

                [#list resultsSummary.stageResults as stageResult]
                    [#list stageResult.sortedBuildResults as buildResult]
                        [#local shouldExpand = buildResult.failed || singleJobPlan /]

                        <tr class="${shouldExpand?string('expanded', 'collapsed')}">
                            <td class="twixie">[@ui.icon type=shouldExpand?string("collapse", "expand") textKey="global.buttons.${shouldExpand?string('collapse', 'expand')}" /]</td>
                            <td>
                                [#if buildResult.finished]
                                    [#assign iconClass=buildResult.buildState /]
                                [#else]
                                    [#assign iconClass=buildResult.lifeCycleState /]
                                [/#if]
                                [@ui.icon type=iconClass/]
                                <a href="${req.contextPath}/browse/${buildResult.planResultKey}/log">${buildResult.immutablePlan.buildName?html}</a>
                                <span class="subGrey">${stageResult.name}</span>
                            </td>
                            [#if buildResult.finished || buildResult.inProgress]
                                <td>
                                    <a href="${req.contextPath}/download/${buildResult.planKey}/build_logs/${buildResult.planResultKey}.log?disposition=attachment">[@ww.text name='chainResult.logs.download'/]</a> or
                                    <a href="${req.contextPath}/download/${buildResult.planKey}/build_logs/${buildResult.planResultKey}.log">[@ww.text name='chainResult.logs.view'/]</a>
                                    [#if buildResult.inProgress]
                                        <span class="grey">[@ww.text name='chainResult.logs.partial'/]</span>
                                    [/#if]
                                </td>
                            [#else]
                                <td><span class="grey">[@ww.text name='chainResult.logs.noLogsAvailable'/]</span></td>
                            [/#if]
                        </tr>
                        <tr class="log-trace">
                            <td class="code" colspan="3">
                               <div>
                                   <table id="${buildResult.planResultKey}">
                                        <tbody>
                                            [#if shouldExpand]
                                                [#list action.retrieveBuildLogs(buildResult) as log]
                                                    [@logLine time=log.formattedDate text=log.log /]
                                                [/#list]
                                            [/#if]
                                        </tbody>
                                   </table>
                               </div>
                            </td>
                        </tr>
                    [/#list]
                [/#list]
            </tbody>
        </table>
    </div>
    <script type="text/x-template" title="logTableRow-template">
        [@logLine time="{time}" text="{log}" /]
    </script>
    <script type="text/javascript">
        BAMBOO.LOGS.chainTableLiveView.init({
            getBuildUrl: "[@ww.url value='/rest/api/latest/result/@KEY@' /]",
            chainStatus: "${resultsSummary.lifeCycleState}",
            noLogsFound: "[@ww.text name='chainResult.logs.noLogsAvailable'/]",
            templates: {
               logTableRow: "logTableRow-template"
            }
        });
    </script>
[/#macro]

[#macro logLine time text]
<tr>
    <td class="time">${time}</td>
    <td class="buildOutputLog">${text}</td>
</tr>
[/#macro]