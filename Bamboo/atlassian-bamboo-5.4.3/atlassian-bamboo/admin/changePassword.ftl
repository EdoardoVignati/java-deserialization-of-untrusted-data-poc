[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ChangePassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ChangePassword" --]
<html>
<head>
	<title>Bamboo Profile[#if user?exists]: [@ui.displayUserFullName user=user /][/#if]</title>
    <meta name="decorator" content="atl.userprofile">
    <meta name="tab" content="personalDetails">
</head>
<body>
    <h1>[@ww.text name='user.password.change' /]</h1>
    [#if user?exists]
    <p>[@ww.text name='user.password.change.description' /]</p>
    [@ww.form action="changePassword" namespace="/profile" submitLabelKey='user.password.change.button' cancelUri='/profile/userProfile.action' titleKey='user.password.change.title' ]
        [@ww.hidden name="username" value=user.name /]
        [@ww.password labelKey='user.password.change.current' name="currentPassword" showPassword="true" required="true" /]
        [@ww.password labelKey='user.password.change.new' name="newPassword" showPassword="true" required="true" /]
        [@ww.password labelKey='user.password.change.new.confirm' name="confirmedPassword" showPassword="true"
        required="true" /]
    [/@ww.form]
    [#else]
    [@ww.text name='user.password.change.error.login' ]
        [@ww.param]<a href="${req.contextPath}/userlogin!default.action">[/@ww.param]
        [@ww.param]</a>[/@ww.param]
    [/@ww.text]
    [/#if]
</body>
</html>