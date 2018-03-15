[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewOfflineAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewOfflineAgents" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]


[#-- Description at the top--]
[#if  offlineRemoteAgents?has_content]
    [#if elasticBambooEnabled]
        [@ww.text name="agent.remote.offline.description.elastic"]
            [@ww.param]${req.contextPath}/admin/elastic/viewElasticAgentHistory.action[/@ww.param]
        [/@ww.text]
    [#else]
        [@ww.text name="agent.remote.offline.description"/]
    [/#if]
    [@ui.clear/]
[#else]
  [#if elasticBambooEnabled]
    [@ww.text name="agent.remote.offline.none.elastic"]
            [@ww.param]${req.contextPath}/admin/elastic/viewElasticAgentHistory.action[/@ww.param]
    [/@ww.text]
  [#else]
    [@ww.text name="agent.remote.offline.none"/]
  [/#if]
[/#if]



[#--The Data Table--]
[#if offlineRemoteAgents?has_content]
    [@ww.form action="configureAgents!reconfigure.action" namespace="/admin/agent" id="remoteAgentConfiguration" theme="simple"]

    [#if fn.hasGlobalAdminPermission()]
        [@agt.displayOperationsHeader agentType='RemoteOffline' deleteOnly=true basicSelectorsOnly=true isPaginated=true isCompleteContentSelected=action.isCompleteContentSelected() /]
    [/#if]
    <table id="remote-agents" class="aui">
        <colgroup>
            [#if fn.hasGlobalAdminPermission()]
                <col width="5">
            [/#if]
            <col />
            <col />
            <col />
            <col width="120" />
            [#if fn.hasGlobalAdminPermission()]
                <col width="160" />
            [/#if]
        </colgroup>
        <thead>
            <tr>
                [#if fn.hasGlobalAdminPermission()]
                    <th>&nbsp;</th>
                [/#if]
                <th>[@ww.text name='agent.table.heading.name' /]</th>
                <th>[@ww.text name='agent.remote.offline.startTime' /]</th>
                <th>[@ww.text name='agent.remote.offline.stopTime' /]</th>
                <th>[@ww.text name='agent.remote.offline.upTime' /]</th>
                [#if fn.hasGlobalAdminPermission()]
                    <th>[@ww.text name='agent.table.heading.operations' /]</th>
                [/#if]
            </tr>
        </thead>
        <tfoot>
            <tr>
                <td colspan="[#if fn.hasGlobalAdminPermission()]6[#else]4[/#if]">
                    [@agentPagination /]
                </td>
            </tr>
        </tfoot>
        <tbody>
            [#if (pager.page.list)?has_content]
                [#assign resultsList = pager.page.list]
                [#foreach agent in resultsList]
                    <tr>
                        [#if fn.hasGlobalAdminPermission()]
                            <td> <input name="selectedAgents" type="checkbox" value="${agent.id}" [#if completeContentSelected]checked[/#if] class="selectorAgentType_RemoteOffline"> </td>
                        [/#if]
                        <td>[@ui.renderAgentNameAdminLink agent/]</td>
                        <td>
                            [#if agent.definition.lastStartupTime?has_content]
                                ${agent.definition.lastStartupTime?datetime}
                            [/#if]
                        </td>
                        <td>
                            [#if agent.definition.lastShutdownTime?has_content]
                                ${agent.definition.lastShutdownTime?datetime}
                            [/#if]
                        </td>
                        <td>
                             [#if agent.definition.agentUpTime != 0]
                                ${dateUtils.formatDurationPretty(agent.definition.agentUpTime/1000)}
                            [#else]
                                ?
                            [/#if]
                        </td>
                        [#if fn.hasGlobalAdminPermission()]
                        <td>
                            [@agt.displayOperationsCell agent=agent /]
                        </td>
                        [/#if]
                    </tr>
                [/#foreach]
            [/#if]
        </tbody>
    </table>
    [/@ww.form]
[/#if]

[#macro agentPagination ]
    [#--This does not use the generic macro because we want to do it inline--]
    <ul class="pager">
    [#if pager.hasPreviousPage]
        <li><a href="[@ww.url value='${firstPageUrl}' /]" class="firstLink">[@ww.text name='global.pager.first' /]</a></li>
        <li><a href="[@ww.url value='${previousPageUrl}' /]" class="previousLink" accesskey="P">[@ww.text name='global.pager.previous' /]</a></li>
    [#else]
        <li><span class="firstLink">[@ww.text name='global.pager.first' /]</span></li>
        <li><span class="previousLink">[@ww.text name='global.pager.previous' /]</span></li>
    [/#if]
    <li class="label">Showing ${pager.page.startIndex + 1}-${pager.page.endIndex} of ${pager.totalSize}</li>
    [#if pager.hasNextPage]
        <li><a href="[@ww.url value='${nextPageUrl}' /]" class="nextLink" accesskey="N">[@ww.text name='global.pager.next' /]</a></li>
        <li><a href="[@ww.url value='${lastPageUrl}' /]" class="lastLink">[@ww.text name='global.pager.last' /]</a></li>
    [#else]
        <li><span class="nextLink">[@ww.text name='global.pager.next' /]</span></li>
        <li><span class="lastLink">[@ww.text name='global.pager.last' /]</span></li>
    [/#if]
    </ul>

    <script type="text/javascript">
        AJS.$(function () {
            AJS.$(".pager > li > a").bind("click", function (e) {
                updateInlineSection(this.href + "&completeContentSelected=" + AJS.$('.RemoteOffline_completeContentSelected').val(), "offlineAgentSection");
                e.preventDefault();
            });
        });
    </script>
[/#macro]
