[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='agent.capability.edit' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.capability.edit' /] - ${capability.label?html}</h1>

    <p>[@ww.text name='agent.capability.edit.description'/]</p>

    [@ww.form id='editElasticCapability'
              action='updateElasticCapability'
              namespace='/admin/elastic'
              titleKey='agent.capability.edit.details'
              submitLabelKey='global.buttons.update'
              cancelUri='${returnUrl}' ]

        [@ui.messageBox type="info" titleKey="agent.capability.edit.warning" /]
        [@ww.hidden name='capabilityKey' /]
        [@ww.hidden name='returnUrl' /]
        [@ww.hidden name='configurationId' /]

        [#if configuration?has_content]
            [@ww.label labelKey='elastic.image.configuration.heading' escape="false"]
                [@ww.param name='value']<a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id/]">${configuration.configurationName?html}</a>[/@ww.param]
            [/@ww.label]
        [/#if]

        [@agt.displayEditCapabilityFields /]

    [/@ww.form]
</body>
</html>