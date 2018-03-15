[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewInstancesForConfigurationAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewInstancesForConfigurationAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='elastic.manage.shutdown.all.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
[#assign title]
    [@ww.text name='elastic.image.configuration.activeInstances.shutdownAll.heading']
        [@ww.param]${elasticImageConfiguration.configurationName?html}[/@ww.param]
    [/@ww.text]
[/#assign]

[@ww.form title=title
          id='confirmElasticInstanceShutdownForm'
          action='shutdownElasticInstancesForConfiguration.action' namespace='/admin/elastic/image/configuration'
          submitLabelKey='global.buttons.confirm'
          cancelUri='/admin/elastic/image/configuration/viewElasticInstancesForConfiguration.action?configurationId=${elasticImageConfiguration.id}}'
]
    [@ui.messageBox type="warning" titleKey="elastic.image.configuration.activeInstances.shutdownAll.warning" /]
    [@ww.hidden name='confirmed' value=true /]
    [@ww.hidden name='configurationId' value="${elasticImageConfiguration.id}"/]
[/@ww.form]

</body>
</html>

