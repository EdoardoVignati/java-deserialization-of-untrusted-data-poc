[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.SearchUserAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.SearchUserAction" --]
<html>
<head>
    <title>[@ww.text name='user.admin.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

<h1>[@ww.text name='user.admin.manage.title' /]</h1>
<p>[@ww.text name='user.admin.manage.description' /]</p>

[@ww.actionerror /]

[#include "/admin/user/viewPaginatedUsers.ftl" /]


[#if !action.isExternallyManaged()]
    <br/>

    [@ww.action name="addUser" executeResult="true" /]
[/#if]

</body>
</html>