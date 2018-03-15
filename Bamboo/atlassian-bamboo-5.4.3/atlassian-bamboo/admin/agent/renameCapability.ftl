[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ExecuteRenameAgentCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ExecuteRenameAgentCapability" --]
<html>
<head>
    <title>[@ww.text name='agent.capability.rename' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ww.form
              action='confirmRename'
              namespace='/admin/agent'
              titleKey='agent.capability.rename'
              descriptionKey='agent.capability.rename.description'
              submitLabelKey='agent.capability.rename'
              cancelUri='/admin/agent/viewCapabilityKey.action?capabilityKey=${capabilityKey}' ]

        [@ww.hidden name='capabilityKey' /]
        [@ww.hidden name='returnUrl' /]

        [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
        [@ww.label labelKey='agent.capability.type' value="${typeText}" /]

        [@ww.label labelKey='agent.capability.type.${capabilityType}.key.old' name='capability.label' /]
        [@ww.textfield labelKey='agent.capability.type.${capabilityType}.key.new' name='newCapabilityLabel' /]

    [/@ww.form]
</body>
</html>