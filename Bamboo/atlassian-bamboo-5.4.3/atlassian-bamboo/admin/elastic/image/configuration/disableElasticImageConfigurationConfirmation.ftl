[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.disable.confirm.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

    <h1>[@ww.text name='elastic.image.configuration.disable.confirm.heading'][@ww.param]${configuration.configurationName?html}[/@ww.param][/@ww.text]</h1>

    [@ww.form namespace="/admin/elastic/image/configuration"
              action="disableElasticImageConfiguration"
              cancelUri='/admin/elastic/image/configuration/viewElasticImageConfigurations.action'
              submitLabelKey='global.buttons.disable'
              titleKey='elastic.image.configuration.disable.confirm.form.title'
    ]
        [@ww.hidden name="confirmDisable" value=true /]
        [@ww.hidden name="configurationId" /]

        [#assign warningHeader]
            [@ww.text name='elastic.image.configuration.disable.confirm.warning.header']
                [@ww.param]${configuration.configurationName?html}[/@ww.param]
            [/@ww.text]
        [/#assign]

        [@ui.messageBox type="warning" title=warningHeader]
            [#assign numSchedules = action.getScheduleCountForImage(configuration)/]

            [#if numSchedules > 0]
                <p>
                [@ww.text name='elastic.image.configuration.disable.confirm.warning.hasSchedules']
                    [@ww.param value=numSchedules /]
                [/@ww.text]
                </p>
            [/#if]

            <p>[@ww.text name='elastic.image.configuration.disable.confirm.warning.footer'/]</p>

        [/@ui.messageBox]

    [/@ww.form]

</body>
</html>