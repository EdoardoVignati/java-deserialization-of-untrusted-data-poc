[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentCapability" --]
<html>
<head>
    <title>[@ww.text name='agent.capability.add' /] - ${agent.name?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
[@ww.form id='addCapability'
          title='${action.getText("agent.capability.add")} - ${agent.name?html}'
          descriptionKey='agent.capability.add.description'
          submitLabelKey='global.buttons.add'
          action='addAgentCapability'
          cancelUri='/admin/agent/viewAgent.action?agentId=${agentId}'
          namespace='/admin/agent' ]
    [@ww.hidden name='agentId' value=agentId /]
    [#include '/admin/agent/addCapabilityFragment.ftl' /]
[/@ww.form]
</body>
</html>
