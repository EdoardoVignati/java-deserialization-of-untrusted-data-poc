[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.EditRemoteAgentAuthenticationIp" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.EditRemoteAgentAuthenticationIp" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#if !inlineDialog]
    [#assign formTitle]
        [@ww.text name="agent.remote.authentication.action.editIp.title"/]
    [/#assign]
[/#if]
[#if !action.initError]
    [#assign submitKey='global.buttons.submit']
[/#if]

<html>
<head>
    [@ui.header pageKey="agent.remote.authentication.action.editIp.title" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>

    [@ww.form title=formTitle!
              id='editAgentAuthenticationIpForm'
              action='editAgentAuthenticationIp!editIp' namespace='/admin/agent'
              submitLabelKey=submitKey!
              cancelUri='/admin/agent/viewAgents.action' ]
        [#if !action.initError]
            [@ww.textfield name='ipAddress' value="${action.ipAddress}" labelKey="agent.remote.authentication.ipAddress"
                descriptionKey="agent.remote.authentication.action.editIp.hint" /]
            [@ww.hidden name="authenticationUuid" value="${action.authenticationUuid}" /]
        [/#if]
    [/@ww.form]
</body>
</html>
