[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.EditSharedCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.EditSharedCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#if agent?has_content]
    [#assign shared = '' /]
[#else]
    [#assign shared = 'Shared' /]
[/#if]
<html>
<head>
    <title>[@ww.text name='agent.capability.edit' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.capability.edit' /] - ${capability.label?html}</h1>

    <p>[@ww.text name='agent.capability.edit.description' /]</p>

    [@ww.form
              action='update${shared}Capability'
              namespace='/admin/agent'
              titleKey='agent.capability.edit.details'
              submitLabelKey='agent.update'
              cancelUri='${returnUrl}' ]

        [@ww.hidden name='agentId' /]
        [@ww.hidden name='capabilityKey' /]
        [@ww.hidden name='sharedCapabilitySetType' /]
        [@ww.hidden name='returnUrl' /]

        [#if agent?has_content]
            [@ww.label labelKey='agent.table.heading.name' escape="false"]
                [@ww.param name='value']<a href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId=agent.id /]">${agent.name?html}</a>[/@ww.param]
            [/@ww.label]
        [#else]
            [@ww.label labelKey='agent.capability.inherited.shared.title' escape="false"]
                [@ww.param name='value']<a href="[@ww.url action='configureShared${sharedCapabilitySetType?html}Capabilities' namespace='/admin/agent' /]">[@ww.text name='agent.capability.shared.${sharedCapabilityType?html}.title' /]</a>[/@ww.param]
            [/@ww.label]
        [/#if]

        [@agt.displayEditCapabilityFields /]

    [/@ww.form]
</body>
</html>