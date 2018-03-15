[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.database' /]</title>
    <meta name="step" content="2">
</head>

<body>

[@ui.header pageKey='setup.install.database' headerElement='h2' /]

[@ww.form action="chooseDatabaseType" submitLabelKey='global.buttons.continue']
    [@ui.bambooSection]
        [@ww.radio labelKey='setup.install.database.form.title' name='dbChoice'
            listKey='key' listValue='value'
            i18nPrefixForValue='setup.install.database' showDescription=true
            list=databaseOptions /]
        [@ww.select id="dbselect" name='selectedDatabase' list=databases listKey='key' listValue='value' toggle="true" cssClass='external-database-type' /]
        [@ui.bambooSection dependsOn='selectedDatabase' showOn="mysql" cssClass='mysql-messages field-group']
            [@ui.messageBox type="info"]
                [@ww.text name='setup.install.database.external.mysql.manualInstall'][@ww.param][@help.href pageKey="db.mysql"/][/@ww.param][/@ww.text]
            [/@ui.messageBox]
            [@ui.messageBox type="info"]
                [@ww.text name='setup.install.database.external.mysql.notice'/]
            [/@ui.messageBox]
        [/@ui.bambooSection]
    [/@ui.bambooSection]
[/@ww.form]

<script type="text/javascript">
    jQuery(function ($) {
        $('#dbselect').change(function() {
            $('#chooseDatabaseType_dbChoicestandardDb').attr("checked", "checked");
        });
    });
</script>

</body>
</html>
