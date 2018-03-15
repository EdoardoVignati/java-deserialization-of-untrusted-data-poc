[#macro displayUserForPermission grantedUsersDisplayNames user]
    [#if grantedUsersDisplayNames.get(user)?has_content]
    <a href="${req.contextPath}/browse/user/${user?html}">${grantedUsersDisplayNames.get(user)?html}</a>
    [#else]
    ${user?html}
    [/#if]
[/#macro]

[#macro permissionCheckBox principal permission type='user' ]
    [#local fieldname='bambooPermission_${type}_${principal?html}_${permission}' /]
    [#local granted=grantedPermissions.contains(fieldname) /]
    <td class="checkboxCell clickable">
        <input type="checkbox" name="${fieldname}"[#if granted] checked[/#if] />
    </td>
[/#macro]

[#macro permissionsEditor entityId=0 anonymousAllowed=true]

    [#if entityId > 0]
        [@ui.displayButtonContainer secondary=true]
            [@ww.text id='createUserPrincipalTitle' name='build.permission.add.user.title' /]
            [@ww.url  id='addUserPrincipal' value='/ajax/addPermissionPrincipal.action?principalType=User&entityId=${entityId}' returnUrl=currentUrl/]
            [@cp.displayLinkButton buttonId='createUserPrincipalButton' buttonLabel=createUserPrincipalTitle buttonUrl=addUserPrincipal cssClass='add-principal' /]

            [@ww.text id='createGroupPrincipalTitle' name='build.permission.add.group.title' /]
            [@ww.url  id='addGroupPrincipal' value='/ajax/addPermissionPrincipal.action?principalType=Group&entityId=${entityId}' returnUrl=currentUrl/]
            [@cp.displayLinkButton buttonId='createGroupPrincipalButton' buttonLabel=createGroupPrincipalTitle buttonUrl=addGroupPrincipal cssClass='add-principal' /]
        [/@ui.displayButtonContainer]
        [@dj.simpleDialogForm
            triggerSelector=".add-principal"
            width=450 height=250
            submitCallback="reloadThePage"
            /]
    [/#if]

    [#if grantedUsers?has_content]
    <table class="aui permissions" id="configureBuildUserPermissions">
        <thead>
        <tr>
            <th>[@ww.text name='repository.shared.permissions.users.title' /]</th>

            [#list editablePermissions.keySet() as key]
                <th class="checkboxCell">[@ww.text name=key /]</th>
            [/#list]
        </tr>
        </thead>
        [#list grantedUsers as user]
            [#if action.hasEditPermissionForUserName(user)]
                <tr>
                    <td>
                        [@displayUserForPermission grantedUsersDisplayNames user /]
                    </td>

                    [#list editablePermissions.keySet() as key]
                        [@permissionCheckBox principal='${user}' permission=editablePermissions.get(key) /]
                    [/#list]
                </tr>
            [/#if]
        [/#list]
    </table>
    [/#if]

    [#if grantedGroups?has_content]
    <table class="aui permissions" id="configureBuildGroupPermissions">
        <thead>
        <tr>
            <th>[@ww.text name='repository.shared.permissions.groups.title' /]</th>
            [#list editablePermissions.keySet() as key]
                <th class="checkboxCell">[@ww.text name=key /]</th>
            [/#list]
        </tr>
        </thead>
        <tbody>
            [#list grantedGroups as group]
            <tr>
                <td>${group}</td>
                [#list editablePermissions.keySet() as key]
                    [@permissionCheckBox principal='${group}' type='group' permission=editablePermissions.get(key) /]
                [/#list]
            </tr>
            [/#list]
        </tbody>
    </table>
    [/#if]

<table class="aui permissions" id="configureBuildOtherPermissions">
    <thead>
    <tr>
        <th>[@ww.text name='repository.shared.permissions.other.title' /]</th>
        [#list editablePermissions.keySet() as key]
            <th class="checkboxCell">[@ww.text name=key /]</th>
        [/#list]
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>[@ww.text name='repository.shared.permissions.loggedIn.title' /]</td>
        [#list editablePermissions.keySet() as key]
            [@permissionCheckBox principal='ROLE_USER' type='role' permission=editablePermissions.get(key) /]
        [/#list]
    </tr>
        [#if anonymousAllowed]
        <tr>
            [#list editablePermissions.keySet() as key]
                [#if key_index == 0]
                    <td>[@ww.text name='build.permissions.anonymous.title' /]</td>
                    [@permissionCheckBox principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
                [#else]
                    <td></td>
                [/#if]
            [/#list]
        </tr>
        [/#if]

    </tbody>
</table>

    [#if entityId == 0]
    <h3>[@ww.text name='build.permission.form.add.title'/]</h3>
        [@ww.select name='principalType' list=['User', 'Group'] toggle='true' /]

        [@ui.bambooSection dependsOn='principalType' showOn='User']
            [#local addUserButton]
                <input type="submit" name="addUserPrincipal" value="Add" class="button"/>
            [/#local]
            [@ww.textfield name='newUser' template='userPicker' multiSelect=false after=addUserButton /]
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='principalType' showOn='Group']
            [#local addGroupButton]
                <input type="submit" name="addGroupPrincipal" value="Add" class="button"/>
            [/#local]
            [@ww.textfield name='newGroup' after=addGroupButton /]
        [/@ui.bambooSection]
    [/#if]

    <script>
        AJS.$(document).on('click', '.checkboxCell', toggleContainingCheckbox);
    </script>
[/#macro]