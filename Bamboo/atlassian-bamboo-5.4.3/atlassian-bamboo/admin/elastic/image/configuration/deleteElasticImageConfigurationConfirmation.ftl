[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.delete.confirm.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

    <h1>[@ww.text name='elastic.image.configuration.delete.confirm.heading'][@ww.param]${configuration.configurationName?html}[/@ww.param][/@ww.text]</h1>

    [@ww.form namespace="/admin/elastic/image/configuration"
              action="deleteElasticImageConfiguration"
              cancelUri='/admin/elastic/image/configuration/viewElasticImageConfigurations.action'
              submitLabelKey='global.buttons.delete'
              titleKey='elastic.image.configuration.delete.confirm.form.title'
    ]
        [@ww.hidden name="confirmDelete" value=true /]
        [@ww.hidden name="configurationId" /]

        [#assign warningHeader]
            [@ww.text name='elastic.image.configuration.delete.confirm.warning.header']
                [@ww.param]${configuration.configurationName?html}[/@ww.param]
            [/@ww.text]
        [/#assign]

        [@ui.messageBox type="warning" title=warningHeader]
            [#assign numAgents = action.getAgentCountForImage(configuration.id)/]
            [#assign numSchedules = action.getScheduleCountForImage(configuration)/]

            [#if numAgents > 0]
                <p>
                [@ww.text name='elastic.image.configuration.delete.confirm.warning.hasAgents']
                    [@ww.param value=numAgents /]
                    [@ww.param value=action.getBuildCountForImage(configuration.id) /]
                [/@ww.text]
                </p>
            [/#if]

            [#if numSchedules > 0]
                <p>
                [@ww.text name='elastic.image.configuration.delete.confirm.warning.hasSchedules']
                    [@ww.param value=numSchedules /]
                [/@ww.text]
                </p>
            [/#if]

            <p>[@ww.text name='elastic.image.configuration.delete.confirm.warning.footer'/]</p>

        [/@ui.messageBox]

    [/@ww.form]

</body>
</html>
