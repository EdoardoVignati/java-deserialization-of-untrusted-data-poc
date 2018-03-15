[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
<head>
	[@ui.header pageKey='User Profile' object='${fn.getUserFullName(currentUser)}' title=true/]
    <meta name="decorator" content="atl.userprofile">
    <meta name="tab" content="personalDetails">
</head>
<body>

    [@ww.url id='changePasswordUrl' action='changePassword' namespace='/profile' /]
    [@ww.url id='changeProfileUrl' action='editProfile' namespace='/profile' /]

    [#if !action.isUserReadOnly(user) && !action.isExternallyManaged() && featureManager.passwordChangeAllowed]
        [#assign editProfileLink='<a href="${changePasswordUrl}">Change password</a> | <a href="${changeProfileUrl}" accesskey="${action.getText(\'global.key.edit\')}">Edit profile</a>' /]
    [#else]
        [#assign editProfileLink='<a href="${changeProfileUrl}">Edit profile</a>' /]
    [/#if]

    [@ui.bambooPanel titleKey='Personal Details' tools=editProfileLink!]
        [@ww.label labelKey='user.username' name='currentUser.name' /]
        [@ww.label labelKey='user.fullName' name='currentUser.fullName' /]
        [@ww.label labelKey='user.email' name='currentUser.email' /]
        [@ww.label labelKey='user.jabber' name='currentUser.jabberAddress' /]

        [#-- Check for OnDemandInstance has been added so we don't display groups, ROTP-105 --]
        [#if groups?has_content && !featureManager.onDemandInstance]
           [#assign groupList='' /]
           [#list groups as group]
               [#assign groupList='${groupList} ${group}' /]
               [#if group_has_next]
                   [#assign groupList='${groupList},' /]
               [/#if]
           [/#list]
           [@ww.label labelKey='user.groups' value='${groupList}'/]
        [/#if]

        [#if repositoryAliases?has_content]
            [#assign list='' /]
            [#list repositoryAliases as author]
                [#assign list='${list} ${author.name!?html}' /]
                [#if author_has_next]
                    [#assign list='${list},' /]
                [/#if]
            [/#list]
            [@ww.label labelKey='user.repositoryAliases' value=list escape=false /]
        [/#if]

        [@ww.label labelKey='ideConnector.port.label' name='idePort' /]
    [/@ui.bambooPanel]
</body>