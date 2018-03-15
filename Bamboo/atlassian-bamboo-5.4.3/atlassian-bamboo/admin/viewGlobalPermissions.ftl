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

    [#if grantedUsers?has_content]
        <table class="aui permissions">
            <thead>
                <tr>
                    <th>Users</th>
                    <th class="checkboxCell">Access</th>
                    <th class="checkboxCell">Create Plan</th>
                    [#if action.isRestrictedAdminEnabled()]
                    <th class="checkboxCell">Restricted Admin</th>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <th class="checkboxCell">Admin</th>
                    [/#if]
                </tr>
            </thead>
            [#list grantedUsers as user]
                [#if action.hasEditPermissionForUserName(user) ]
                    <tr>
                        <td>
                            [@permissions.displayUserForPermission grantedUsersDisplayNames user /]
                        </td>
                        [@permissionIndicator principal='${user}' permission='READ' /]
                        [@permissionIndicator principal='${user}' permission='CREATE' /]
                        [#if action.isRestrictedAdminEnabled()]
                        [@permissionIndicator principal='${user}' permission='RESTRICTEDADMINISTRATION' /]
                        [/#if]
                        [#if action.hasGlobalAdminPermission()]
                        [@permissionIndicator principal='${user}' permission='ADMINISTRATION' /]
                        [/#if]
                    </tr>
                [/#if]
            [/#list]
        </table>
    [/#if]

    [#if grantedGroups?has_content]
        <table class="aui permissions" id="configureGlobalGroupPermissions">
            <thead>
                <tr>
                    <th>Groups</th>
                    <th class="checkboxCell">Access</th>
                    <th class="checkboxCell">Create Plan</th>
                    [#if action.isRestrictedAdminEnabled()]
                    <th class="checkboxCell">Restricted Admin</th>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <th class="checkboxCell">Admin</th>
                    [/#if]
                </tr>
            </thead>
            [#list grantedGroups as group]
                [#if action.hasEditPermissionForGroup(group) ]
                    <tr>
                        <td>${group}</td>
                        [@permissionIndicator principal='${group}' type='group' permission='READ' /]
                        [@permissionIndicator principal='${group}' type='group' permission='CREATE' /]
                        [#if action.isRestrictedAdminEnabled()]
                        [@permissionIndicator principal='${group}' type='group' permission='RESTRICTEDADMINISTRATION' /]
                        [/#if]
                        [#if action.hasGlobalAdminPermission()]
                        [@permissionIndicator principal='${group}' type='group' permission='ADMINISTRATION' /]
                        [/#if]

                    </tr>
                [/#if]
            [/#list]
        </table>
    [/#if]

    <table class="aui permissions" id="configureGlobalOtherPermissions">
        <thead>
        <tr>
            <th>Other</th>
            <th class="checkboxCell">Access</th>
            <th class="checkboxCell">Create Plan</th>
            [#if action.isRestrictedAdminEnabled()]
            <th class="checkboxCell">Restricted Admin</th>
            [/#if]
            [#if action.hasGlobalAdminPermission()]
            <th class="checkboxCell"></th>
            [/#if]
        </tr>
        </thead>
        <tr>
            <td>All logged in users</td>
            [@permissionIndicator principal='ROLE_USER' type='role' permission='READ' /]
            [@permissionIndicator principal='ROLE_USER' type='role' permission='CREATE' /]
            [#if action.isRestrictedAdminEnabled()]
            <td></td>
            [/#if]
            [#if action.hasGlobalAdminPermission()]
            <td></td>
            [/#if]
        </tr>
        <tr>
            <td>Anonymous users</td>
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
            <td></td>
            [#if action.isRestrictedAdminEnabled()]
            <td></td>
            [/#if]
            [#if action.hasGlobalAdminPermission()]
            <td></td>
            [/#if]
        </tr>
    </table>

    <p>
        <a href="[@ww.url action='configureGlobalPermissions' namespace='/admin' method='view'/]" id="editPermissions" class="aui-button">Edit Global Permissions</a>
    </p>


[#macro permissionIndicator principal permission type='user' ]
    [#assign fieldname='bambooPermission_${type}_${principal?html}_${permission}' /]
    [#assign granted=grantedPermissions.contains(fieldname) /]
    <td class="checkboxCell" id="${fieldname}">
        [#if granted]
            [@ui.icon type="tick" textKey="config.global.permissions.granted" /]
        [#else]
            [@ui.icon type="cross" textKey="config.global.permissions.notgranted" /]
        [/#if]
    </td>
[/#macro]

</body>
</html>
