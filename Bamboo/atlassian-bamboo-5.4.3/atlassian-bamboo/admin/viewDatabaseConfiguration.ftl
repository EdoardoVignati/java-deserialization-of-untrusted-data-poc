[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ViewDatabaseConfigurationAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ViewDatabaseConfigurationAction" --]
<html>
<head>
	<title>[@ww.text name='config.database.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
    [@ui.header pageKey='config.database.title'/]

    [@ui.bambooPanel titleKey='config.database.subTitle']
        [@ww.label labelKey='config.database.driverName' name='databaseDriverName' /]
        [@ww.label labelKey='config.database.driverClassName' name='databaseDriverClassName' /]
        [@ww.label labelKey='config.database.driverVersion' name='databaseDriverVersion' /]
        [@ww.label labelKey='config.database.databaseUrl' name='databaseUrl' /]
        [@ww.label labelKey='config.database.username' name='userName' /]
        [@ww.label labelKey='config.database.dialect' name='dialect' /]
    [/@ui.bambooPanel]
</body>
</html>