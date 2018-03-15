[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentDetails" --]
<html>
<head>
    <title>[@ww.text name='agent.edit' /] - ${agent.name?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.edit' /] - ${agent.name?html}</h1>

    <p>[@ww.text name='agent.edit.description' /]</p>

    [@ww.form id='editAgentForm'
              action='updateAgentDetails'
              namespace='/admin/agent'
              titleKey='agent.details'
              submitLabelKey='agent.update'
              cancelUri='${returnUrl}' ]

        [@ww.hidden name='agentId' /]
        [@ww.hidden name='returnUrl' /]

        [@ww.textfield id='agentNameInput' labelKey='agent.field.name' name='agentName' /]
        [@ww.textfield id='agentDescriptionInput' labelKey='agent.field.description' name='agentDescription' rows='5' /]

        <br/>
    [/@ww.form]

</body>
</html>