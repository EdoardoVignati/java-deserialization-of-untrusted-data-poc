[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsAvailability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsAvailability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#assign shutdownConfirmation]

[/#assign]

<html>
<head>
    [@ui.header pageKey="agent.remote.disableFunction" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>

    <h1>[@ww.text name='agent.remote.disableFunction'/]</h1>

    [@ww.form id='confirmDisableRemoteAgentFunctionForm'
              action='disableRemoteAgentFunction' namespace='/admin/agent'
              submitLabelKey='global.buttons.confirm'
              cancelUri='/admin/agent/configureAgents!default.action'
    ]
        [#if numberOfElasticInstancesRunning > 0]
            [@ui.messageBox type="warning" titleKey="agent.remote.disableFunction.confirmation.elastic" /]
        [#else]
            [@ui.messageBox type="warning" titleKey="agent.remote.disableFunction.confirmation" /]
        [/#if]
        [@ww.hidden name='confirmed' value=true /]
    [/@ww.form]

</body>
</html>
