[#import "/fragments/permissions/permissions.ftl" as permissions/]
[#if grantedUsers?has_content]
    <table class="aui permissions">
        <thead>
            <tr>
                <th>Users</th>
                <th class="checkboxCell">View</th>
                <th class="checkboxCell">Edit</th>
                <th class="checkboxCell">Build</th>
                <th class="checkboxCell">Clone</th>
                <th class="checkboxCell">Admin</th>
            </tr>
        </thead>
        <tbody>
            [#list grantedUsers as user]
                <tr>
                    <td>
                        [@permissions.displayUserForPermission grantedUsersDisplayNames user /]
                    </td>
                    [@permissionIndicator principal='${user}' permission='READ' /]
                    [@permissionIndicator principal='${user}' permission='WRITE' /]
                    [@permissionIndicator principal='${user}' permission='BUILD' /]
                    [@permissionIndicator principal='${user}' permission='CLONE' /]
                    [@permissionIndicator principal='${user}' permission='ADMINISTRATION' /]
                </tr>
            [/#list]
        </tbody>
    </table>
[/#if]

[#if grantedGroups?has_content]
    <table class="aui permissions">
        <thead>
            <tr>
                <th>Groups</th>
                <th class="checkboxCell">View</th>
                <th class="checkboxCell">Edit</th>
                <th class="checkboxCell">Build</th>
                <th class="checkboxCell">Clone</th>
                <th class="checkboxCell">Admin</th>
            </tr>
        </thead>
        <tbody>
            [#list grantedGroups as group]
                <tr>
                    <td>${group}</td>
                    [@permissionIndicator principal='${group}' type='group' permission='READ' /]
                    [@permissionIndicator principal='${group}' type='group' permission='WRITE' /]
                    [@permissionIndicator principal='${group}' type='group' permission='BUILD' /]
                    [@permissionIndicator principal='${group}' type='group' permission='CLONE' /]
                    [@permissionIndicator principal='${group}' type='group' permission='ADMINISTRATION' /]
                </tr>
            [/#list]
        </tbody>
    </table>
[/#if]

<table class="aui permissions">
    <thead>
        <tr>
            <th>Other</th>
            <th class="checkboxCell">View</th>
            <th class="checkboxCell">Edit</th>
            <th class="checkboxCell">Build</th>
            <th class="checkboxCell">Clone</th>
            <th class="checkboxCell">Admin</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>All logged in users</td>
            [@permissionIndicator principal='ROLE_USER' type='role' permission='READ' /]
            [@permissionIndicator principal='ROLE_USER' type='role' permission='WRITE' /]
            [@permissionIndicator principal='ROLE_USER' type='role' permission='BUILD' /]
            [@permissionIndicator principal='ROLE_USER' type='role' permission='CLONE' /]
            [@permissionIndicator principal='ROLE_USER' type='role' permission='ADMINISTRATION' /]
        </tr>
        <tr>
            <td>Anonymous users</td>
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='WRITE' /]
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='BUILD' /]
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='CLONE' /]
            [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='ADMINISTRATION' /]
        </tr>
    </tbody>
</table>

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