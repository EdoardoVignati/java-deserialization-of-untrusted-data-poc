[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
<html>
<head>
	<title>User Profile[#if user?exists]: [@ui.displayUserFullName user=user /][/#if]</title>
    <meta name="decorator" content="atl.userprofile"/>
    <meta name="tab" content="personalDetails" />
</head>
<body>

    [#assign externallyManaged = action.isExternallyManaged() /]
    [#assign readOnly = action.isUserReadOnly(user) /]

    [#if readOnly || externallyManaged]
        [#assign actionLink='updateExternalProfile' ]
    [#else]
        [#assign actionLink='updateProfile' ]
    [/#if]

[@ww.form action='${actionLink}'
          namespace='/profile'
          submitLabelKey='global.buttons.update'
          cancelUri='/profile/userProfile.action'
          titleKey='user.edit.title']

    [@ww.label labelKey='user.username' name="user.name" /]

    [#if !readOnly && !externallyManaged]
        [@ww.textfield labelKey='user.fullName' name="fullName" required="true" /]
        [@ww.textfield labelKey='user.email' name="email" required="true" /]
    [#else]
        [@ww.label labelKey='user.fullName' name="fullName" /]
        [@ww.label labelKey='user.email' name="email"  /]
    [/#if]

    [@ww.textfield labelKey='user.jabber' name="jabberAddress" /]
    
    [@dj.simpleDialogForm
        triggerSelector=".addAlias"
        width=540 height=210
        submitCallback="addAliasSubmitCallback"
    /]
    [#assign addAliasLink]
        <a class="addAlias" title="${action.getText('user.repositoryAlias.add')}" href="[@ww.url value='/ajax/configureAlias.action' returnUrl=currentUrl /]">[@ww.text name='user.repositoryAlias.add' /]</a>
    [/#assign]

    [@ww.select labelKey='user.repositoryAliases' name='authors'
                list=availableAuthors
                listKey='id'
                listValue='name'
                multiple=true
                cssClass='selectAlias'
                extraUtility=addAliasLink/]

    [@ww.textfield labelKey='ideConnector.port.label' descriptionKey='ideConnector.port.label.description' name="idePort" /]

[/@ww.form]

</body>
</html>
