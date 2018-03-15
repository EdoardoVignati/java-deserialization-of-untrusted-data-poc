[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseConnectionAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseConnectionAction" --]
[#import "setupCommon.ftl" as sc/]

<html>
<head>
    <title>[@ww.text name='setup.install.database.configure' /]</title>
    <meta name="step" content="2">
</head>

<body>

[@ui.header pageKey='setup.install.database.configure' headerElement='h2' /]

[@ww.form action="performSetupDatabaseConnection"
            submitLabelKey='global.buttons.continue']

    [@ww.hidden name='selectedDatabase' value=selectedDatabase /]

    [@ww.radio name='connectionChoice'
                   listKey='key' listValue='value'
                   list=connectionTypes
                   toggle='true'
                   labelKey="setup.install.database.configure.connection.type"/]


    [@ui.bambooSection dependsOn="connectionChoice" showOn="datasourceConnection"]
        [@ui.messageBox type="hint" titleKey="setup.install.database.configure.datasource.form.description" /]
        [@ww.textfield name='datasourceName' labelKey='setup.install.database.configure.datasource.datsourceName' /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn="connectionChoice" showOn="jdbcConnection"]
        [@ui.bambooSection dependsOn='selectedDatabase' showOn="mysql"]
            [@ui.messageBox type="info"]
                [@ww.text name='setup.install.database.external.mysql.manualInstall'][@ww.param][@help.href pageKey="db.mysql"/][/@ww.param][/@ww.text]
            [/@ui.messageBox]
        [/@ui.bambooSection]
        [#if dbConfigInfo.dbNotes.size() > 0 ]
            [@ui.messageBox type="info"]
                [#if dbConfigInfo.dbNotes.size() == 1 ]
                    <p class="title">${dbConfigInfo.dbNotes.iterator().next()}</p>
                [#else ]
                    <ul>
                        [#list dbConfigInfo.dbNotes as note]
                            <li>${note}</li>
                        [/#list]
                    </ul>
                [/#if]
            [/@ui.messageBox]
        [/#if]

        [@ww.textfield name='dbConfigInfo.driverClassName' labelKey='setup.install.database.configure.standard.driver' cssClass="long-field" /]
        [@ww.textfield name='dbConfigInfo.databaseUrl' labelKey='setup.install.database.configure.standard.databaseUrl'  cssClass="long-field" /]
        [@ww.textfield name='dbConfigInfo.userName' labelKey='setup.install.database.configure.standard.userName' /]
        [@ww.password name='dbConfigInfo.password' labelKey='setup.install.database.configure.standard.password' /]
    [/@ui.bambooSection]

    [#if selectedDatabase=="other"]
        [@ww.textfield name='dbConfigInfo.dialect' labelKey='setup.install.database.configure.standard.dialect'  cssClass="long-field"  /]
    [/#if]
    [@ui.bambooSection cssClass='group']
        [@ww.checkbox name="dataOverwrite" labelKey='setup.install.database.configure.overwrite' /]
    [/@ui.bambooSection]
[/@ww.form]

</body>
</html>
