[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AdministerAction" --]


<html>
<head>
    [@ui.header pageKey='admin.title' title=true /]
    <meta name="decorator" content="adminpage">
</head>
<body>
    [@ui.header pageKey='admin.heading' descriptionKey='admin.description' cssClass='admin-home-page-title' /]

    ${soy.render('bamboo.page.admin.overview.overview', {
        "isOnDemandInstance": featureManager.onDemandInstance,
        "hasBuilders": (localBuilders!)?has_content,
        "hasJdks": (localJdks!)?has_content,
        "buildersSize": (localBuilders?size!0),
        "isAllowedRemoteAgents": allowedRemoteAgents,
        "hasGlobalAdminPermission": fn.hasGlobalAdminPermission()
    })}
</body>
</html>