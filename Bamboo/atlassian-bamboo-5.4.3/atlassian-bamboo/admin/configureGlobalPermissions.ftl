[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]

[#import "/fragments/permissions/permissions.ftl" as permissions/]

<html>
<head>
    <title>[@ww.text name='config.global.permissions.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
[@ui.header pageKey='config.global.permissions.heading' descriptionKey='config.global.permissions.description' /]

<div class="aui-group permissionForm">
    <div class="aui-item formArea">
        [@ww.form action='configureGlobalPermissions' submitLabelKey='global.buttons.update' titleKey='config.global.permissions.title' id='permissions' cancelUri='/admin/viewGlobalPermissions.action' cssClass='top-label']
            [@permissions.permissionsEditor securedDomainObject.id /]
        [/@ww.form]
    </div>
    <div class="aui-item helpTextArea">
        <h3 class="helpTextHeading">Permission Types</h3>
        <ul>
            <li><strong>Access</strong> - User can access Bamboo.</li>
            <li><strong>Create Plan</strong> - User can create a new plan in Bamboo.</li>
            <li>
                <strong>Restricted Admin</strong> - User can perform some administration operations and view all plans in Bamboo.
            </li>
            [#if action.hasGlobalAdminPermission()]
                <li><strong>Admin</strong> - User can perform all operations and view all plans in Bamboo.</li>
            [/#if]
        </ul>
    </div>
</div>
</body>
</html>


