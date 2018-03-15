[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsAuthentication" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsAuthentication" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#if enabling ]
    [#assign mode="enable" /]
[#else]
    [#assign mode="disable" /]
[/#if]
[#if !inlineDialog]
    [#assign formTitle]
        [@ww.text name="agent.remote.authentication.${mode}"/]
    [/#assign]
[/#if]

<html>
<head>
[@ui.header pageKey="agent.remote.authentication.${mode}" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>

[#if mode=='enable' && action.unapprovedOnlineAgentsCount > 0]
[#-- so it works nicely in dialog $ standalone page mode --]
    [#assign checkbox]
        [@ww.checkbox value='true' name='autoApprove' labelKey="agent.remote.authentication.enable.confirmAndAutoApprove" /]
    [/#assign]
[/#if]
    [@ww.form title=formTitle!
id='confirmAgentAuthenticationForm'
action='${mode}RemoteAgentAuthentication' namespace='/admin/agent'
submitLabelKey='global.buttons.confirm'
cancelUri='/admin/agent/viewAgents.action'
buttonsBefore=checkbox!
]
    [@ui.messageBox type="warning" titleKey="agent.remote.authentication.${mode}.confirmation.title"]
        [@ww.text name='agent.remote.authentication.${mode}.confirmation']
            [@ww.param][@help.href pageKey="agent.remote.authentication.docs"/][/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]

    [#if mode=='enable' && action.unapprovedOnlineAgentsCount > 0]
        [@ui.messageBox type="info" content=action.getText('agent.remote.authentication.enable.confirmation.autoApproval',
        [action.unapprovedOnlineAgentsCount]) /]
    [/#if]
    [@ww.hidden name='confirmed' value=true /]
[/@ww.form]

</body>
</html>
