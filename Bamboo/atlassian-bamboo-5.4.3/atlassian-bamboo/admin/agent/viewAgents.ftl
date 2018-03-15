[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='agent.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [#if featureManager.localAgentsSupported || featureManager.remoteAgentsSupported]
        <div class="toolbar">
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    [#if fn.hasGlobalAdminPermission() && featureManager.localAgentsSupported]
                        [#if allowNewLocalAgent]
                        <li class="toolbar-item">
                            <a class="toolbar-trigger" href="[@ww.url action='addLocalAgent' namespace='/admin/agent' /]">[@ww.text name='agent.local.add' /]</a>
                        </li>
                        [/#if]
                    [/#if]
                    [#if featureManager.remoteAgentsSupported]
                        [#if allowedNumberOfRemoteAgents != 0]
                            [#if remoteAgentFunctionEnabled]
                                [#if !remoteAgentAuthenticationEnabled]
                                    <li class="toolbar-item">
                                        <a class="toolbar-trigger mutative" id="enableRemoteAgentAuthentication" data-action="control-remote-agent-authentication"
                                           href="[@ww.url action='enableRemoteAgentAuthentication' namespace='/admin/agent' /]">[@ww.text name='agent.remote.authentication.enable' /]</a>
                                    </li>
                                [/#if]
                                [#if fn.hasGlobalAdminPermission()]
                                    <li class="toolbar-item">
                                        <a class="toolbar-trigger" href="[@ww.url action='addRemoteAgent' namespace='/admin/agent' /]">[@ww.text name='agent.remote.add' /]</a>
                                    </li>
                                [/#if]
                            [#else]
                                 <li class="toolbar-item">
                                     <a class="toolbar-trigger mutative" id="enableRemoteAgentFunction" href="[@ww.url action='enableRemoteAgentFunction' namespace='/admin/agent' /]">[@ww.text name='agent.remote.enableFunction' /]</a>
                                 </li>
                            [/#if]
                        [/#if]
                    [/#if]
                </ul>
            </div>
        </div>
    [/#if]
    <h1>[@ww.text name='agent.heading' /]</h1>

    <p>[@ww.text name='agent.description']
        [@ww.param]${req.contextPath}/admin/agent/viewAgentPlanMatrixWizard.action[/@ww.param]
    [/@ww.text]</p>

    [#if featureManager.remoteAgentsSupported && allowedNumberOfRemoteAgents != 0 && !remoteAgentFunctionEnabled]
        [@ui.messageBox type="warning"][@ww.text name="agent.remote.functionDisabled"][@ww.param][@help.href pageKey="agent.remote.security"/][/@ww.param][/@ww.text][/@ui.messageBox]
    [/#if]

    [@ww.actionerror /]
    [@ui.actionwarning /]
    [@ww.actionmessage /]

    [#if (fn.hasGlobalAdminPermission())]
        [#assign sharedCapabilitiesLink]
            <a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action">${action.getText("agent.capability.shared.local.title")}</a>
        [/#assign]
    [#else]
        [#assign sharedCapabilitiesLink='']
    [/#if]

    [#if featureManager.localAgentsSupported]
        [@ui.bambooPanel titleKey='agent.local.heading' descriptionKey='agent.local.description' tools=sharedCapabilitiesLink]
            [#if localAgents?has_content]
                [@ww.form action="configureAgents!reconfigure.action" id="localAgentConfiguration" theme="simple"]
                [@agt.displayOperationsHeader agentType='Local'/]
                    [#if !allowNewLocalAgent]
                        [@ww.text name='agent.local.limited.description']
                            [@ww.param value=allowedNumberOfLocalAgents /]
                        [/@ww.text]
                    [/#if]
                    <table id="local-agents" class="aui">
                        <colgroup>
                            <col width="5" />
                            <col />
                            <col width="185" />
                            <col width="95" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>&nbsp;</th>
                                <th>[@ww.text name='agent.table.heading.name' /]</th>
                                <th>[@ww.text name='agent.table.heading.status' /]</th>
                                <th>[@ww.text name='agent.table.heading.operations' /]</th>
                            </tr>
                        </thead>
                        <tbody>
                            [#foreach agent in localAgents]
                                <tr>
                                    <td><input name="selectedAgents" type="checkbox" value="${agent.id}" class="selectorAgentType_Local selectorAgentEnabled_${agent.enabled?string} selectorAgentStatus_${agent.agentStatus}" /></td>
                                    <td>[@ui.renderAgentNameAdminLink agent /]</td>
                                    <td>[@agt.displayStatusCell agent=agent /]</td>
                                    <td>[@agt.displayOperationsCell agent=agent /]</td>
                                </tr>
                            [/#foreach]
                        </tbody>
                    </table>
                [/@ww.form]
            [#else]
                [@ww.text name='agent.local.none' /]
            [/#if]
        [/@ui.bambooPanel]
    [#else]
        [@ui.messageBox type="info" titleKey="local.agents.not.supported.for.ondemand"/]
    [/#if]

    [#if featureManager.remoteAgentsSupported]
        [#if allowedNumberOfRemoteAgents != 0]
            [#if remoteAgentFunctionEnabled]
                [#assign configSharedRemoteLink]
                    <a href="[@ww.url action="configureSharedRemoteCapabilities" namespace="/admin/agent" /]">[@ww.text name="agent.capability.shared.remote.title" /]</a>
                [/#assign]
                [#assign disableRemoteLink]
                    <a id="disableRemoteAgentFunction" href="[@ww.url action="disableRemoteAgentFunction" namespace="/admin/agent" /]">[@ww.text name="agent.remote.disableFunction" /]</a>
                [/#assign]
                [#assign remoteAgentToolItems="${configSharedRemoteLink} | ${disableRemoteLink}" /]
                [#if remoteAgentAuthenticationEnabled]
                    [#assign disableRemoteAuthenticationLink]
                        <a id="disableRemoteAgentAuthentication" data-action="control-remote-agent-authentication"
                           href="[@ww.url action="disableRemoteAgentAuthentication" namespace="/admin/agent" /]">[@ww.text name="agent.remote.authentication.disable" /]</a>
                    [/#assign]
                    [#assign remoteAgentToolItems="${remoteAgentToolItems} | ${disableRemoteAuthenticationLink}" /]
                [/#if]

                [@ui.bambooPanel
                    titleKey='agent.remote.heading'
                    descriptionKey='agent.remote.description'
                    tools="${remoteAgentToolItems}"
                ]

                    [#assign tabs=[action.getText('agent.remote.online.tab'),action.getText('agent.remote.offline.tab')] /]
                    [#if remoteAgentAuthenticationEnabled]
                        [#assign tabs=[tabs[0],tabs[1],action.getText('agent.remote.authentication.tab')] /]
                    [/#if]
                    [@dj.tabContainer headings=tabs selectedTab=action.selectedTab! tabViewId="remote-agents-tabs"]
                        [@dj.contentPane labelKey='agent.remote.online.tab' ]
                            [@agt.onlineAgents /]
                        [/@dj.contentPane]
                        [@dj.contentPane labelKey='agent.remote.offline.tab']
                            [@agt.offlineAgents/]
                        [/@dj.contentPane]
                        [#if remoteAgentAuthenticationEnabled]
                            [@dj.contentPane labelKey='agent.remote.authentication.tab']
                                [@agt.remoteAgentAuthentications /]
                            [/@dj.contentPane]
                        [/#if]
                    [/@dj.tabContainer]
                [/@ui.bambooPanel]
            [/#if]
        [/#if]
    [#else]
        [@ui.messageBox type="info" titleKey="remote.agents.not.supported.for.ondemand"/]
    [/#if]

    [#if featureManager.remoteAgentsSupported]
        [@dj.simpleDialogForm triggerSelector="a[data-action=control-remote-agent-authentication]"
            headerKey="agent.remote.authentication" submitCallback="reloadThePage" /]
    [/#if]

</body>
</html>