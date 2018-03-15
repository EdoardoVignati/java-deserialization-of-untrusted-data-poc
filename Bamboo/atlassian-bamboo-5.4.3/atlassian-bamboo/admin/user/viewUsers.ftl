[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureUser" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureUser" --]
<html>
<head>
    [@ui.header pageKey="user.admin.manage.title" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ui.header pageKey="user.admin.manage.title" descriptionKey="user.admin.manage.description"/]

    [@ww.actionerror /]

    [@ww.action name="browseUsers" executeResult="true" /]


[#if !action.isExternallyManaged() && featureManager.userManagementEnabled]
    [@ww.action name="addUser" executeResult="true" /]
[/#if]

</body>
</html>