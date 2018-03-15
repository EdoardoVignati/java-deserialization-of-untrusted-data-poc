[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticAgentHistoryAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticAgentHistoryAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='elastic.history.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
<h1>[@ww.text name='elastic.history.title' /]</h1>

<p>[@ww.text name='elastic.history.description']
    [@ww.param]${req.contextPath}/admin/elastic/manageElasticInstances.action[/@ww.param]
[/@ww.text]</p>

[#if (pager.page.list)?has_content]
<table id="elastic-agents" class="aui">
    <colgroup>
        <col>
        <col>
        <col>
        <col>
        <col>
        <col width="100">
        <col width="100">
    </colgroup>
    <thead>
    <tr>
        <th>[@ww.text name='elastic.history.agent' /]</th>
        <th>[@ww.text name='elastic.history.configuration' /]</th>
        <th>[@ww.text name='elastic.history.startTime' /]</th>
        <th>[@ww.text name='elastic.history.stopTime' /]</th>
        <th>[@ww.text name='elastic.history.upTime' /]</th>
        <th>[@ww.text name='build.common.successful' /]</th>
        <th>[@ww.text name='elastic.history.operations' /]</th>
    </tr>
    </thead>
    <tbody>
        [#if (pager.page.list)?has_content]
            [#assign resultsList = pager.page.list]
            [#foreach agent in resultsList]
            <tr>
                <td><a href="${req.contextPath}/admin/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>
                </td>
                <td>
                    <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${agent.elasticImageConfiguration.id}">${agent.elasticImageConfiguration.configurationName?html}</a>
                </td>
                <td>
                    [#if agent.lastStartupTime?has_content]
                                    ${agent.lastStartupTime?datetime}
                                [/#if]
                </td>
                <td>
                    [#if agent.lastShutdownTime?has_content]
                                    ${agent.lastShutdownTime?datetime}
                                [/#if]
                </td>
                <td>
                    [#if agent.agentUpTime != 0]
                    ${dateUtils.formatDurationPretty(agent.agentUpTime/1000)}
                    [#else]
                        ?
                    [/#if]
                </td>
                <td>
                    [#assign statistics = action.getStatistics(agent.id) /]
                    [#if statistics.totalNumberOfResults > 0]
                    ${statistics.totalSuccesses} / ${statistics.totalNumberOfResults}
                    [#else]
                        [@ww.text name='build.common.noBuilds' /]
                    [/#if]
                </td>
                <td valign="center">
                    [@displayOfflineOperations agent=agent /]
                </td>
            </tr>
            [/#foreach]
        <tr>
            <td colspan="7">
                [@cp.pagination /]
            </td>
        </tr>
        [/#if]
    </tbody>
</table>
[#else]
    [@ww.text name='elastic.history.empty' /]
[/#if]
<p>
    [#if (pager.page.list)?has_content]
        [@ww.url action='deleteAgentHistory' namespace='/admin/elastic' id='deleteAgentHistoryUrl' /]
        [@cp.displayLinkButton buttonId="disableButton" buttonLabel="elastic.history.delete.all" buttonUrl=deleteAgentHistoryUrl altTextKey="elastic.history.delete.all.description" cssClass="requireConfirmation mutative" /]
    [/#if]
</p>
</body>
</html>


[#macro displayOfflineOperations agent]
<a id="view:${agent.id}" href="${req.contextPath}/admin/agent/viewAgent.action?agentId=${agent.id}">[@ww.text name='global.buttons.view' /]</a>
|
<a id="delete:${agent.id}" href="${req.contextPath}/admin/agent/removeAgent.action?agentId=${agent.id}&amp;returnUrl=/admin/elastic/viewElasticAgentHistory.action" class="requireConfirmation mutative" title="[@ww.text name='elastic.history.delete.description' /]">[@ww.text name='elastic.history.delete' /]</a>
[/#macro]
