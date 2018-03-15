[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ExecuteRenameAgentCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ExecuteRenameAgentCapability" --]
<html>
<head>
    <title>[@ww.text name='agent.capability.rename.notAllowed' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ww.form
              action='cancel'
              namespace='/admin/agent'
              titleKey='agent.capability.rename.notAllowed'
              descriptionKey='agent.capability.rename.notAllowed.description'
              cancelUri='/admin/agent/viewCapabilityKey.action?capabilityKey=${capabilityKey}' ]

        [@ww.hidden name='returnUrl' /]

        [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
        [@ww.label labelKey='agent.capability.type' value="${typeText}" /]

        [@ww.label labelKey='agent.capability.type.${capabilityType}.key' name='capability.label' /]

    [/@ww.form]
</body>
</html>