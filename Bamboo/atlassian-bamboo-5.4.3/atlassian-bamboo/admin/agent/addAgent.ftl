[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentDetails" --]
<html>
<head>
    <title>[@ww.text name='agent.local.add' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.local.add' /]</h1>

    <p>[@ww.text name='agent.local.add.description' /]</p>

    [@ww.form id='addAgentForm'
              action='createLocalAgent'
              namespace='/admin/agent'
              titleKey='agent.details'
              submitLabelKey='agent.add'
              cancelUri='/admin/agent/configureAgents!default.action' ]

        [@ww.textfield id='agentNameInput' labelKey='agent.field.name' name='agentName' /]

        [@ww.textarea id='agentDescriptionInput' labelKey='agent.field.description' name='agentDescription' rows='5' cssClass="long-field" spellcheck="true"/]

        <br/>
    [/@ww.form]


</body>
</html>