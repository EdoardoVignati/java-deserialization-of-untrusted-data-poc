[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='agent.capability.view.title' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>
        [#if (capabilityType.viewTypeAction)?has_content]
            <a href="[@ww.url action='${capabilityType.viewTypeAction}' namespace='/admin/agent' /]">[@ww.text name='${capabilityType}.admin.heading' /]</a>
        [#else]
            [@ww.text name='${capabilityType}.admin.heading' /]
        [/#if]
         >
        ${capability.label?html}
    </h1>

    [@ww.form
            action='updateCapabilityConfiguration'
            namespace='/admin/agent'
            titleKey='agent.capability.configure'
            descriptionKey='agent.capability.configure.description'
            submitLabelKey='global.buttons.update'
            cancelUri='/admin/agent/viewCapabilityKey.action?capabilityKey=${capabilityKey}' ]

        [@ww.hidden name='capabilityKey' /]
        [@ww.hidden name='returnUrl' /]

        [#list capabilityConfiguratorPluginEditHtmlList as capabilityConfiguratorHtml]
            ${capabilityConfiguratorHtml}
        [/#list]

    [/@ww.form]
</body>
</html>
