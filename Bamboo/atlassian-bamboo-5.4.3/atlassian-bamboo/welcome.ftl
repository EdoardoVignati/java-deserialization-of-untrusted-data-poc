[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <meta name="decorator" content="instanceName"/>
    ${webResourceManager.requireResourcesForContext("atl.dashboard")}
</head>
<body>
${soy.render('bamboo.feature.dashboard.welcomeMat.welcomeMat', {
    "hasAdminPermission": fn.hasAdminPermission(),
    "hasGlobalCreatePermission": fn.hasGlobalPermission('CREATE'),
    "isEc2ConfigurationWarningRequired": ec2ConfigurationWarningRequired,
    "hasUser": user??,
    "importOptions": ctx.getWebItems('system.welcome/welcomeImportOptions', req)
})}
</body>
</html>

