[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ForgotPassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ForgotPassword" --]
<html>
<head>
	<title>[@ww.text name='user.password.reset.title' /]</title>
    <meta name="decorator" content="login" />
</head>
<body>
<header>
    [@ui.header pageKey="user.password.reset.heading" descriptionKey="user.password.reset.description" /]
</header>
[#if mailServerConfigured==false]
    [@ww.form action="userlogin!default.action"
        id="forgotPasswordForm"
        submitLabelKey='global.buttons.back'
        method="post"
        cancelUri='${req.contextPath}/userlogin!default.action'
    ]
        [@ui.messageBox type='warning' titleKey='user.password.reset.noMail']
            <a href="[@ww.url action='viewAdministrators' namespace='' /]">Please contact your administrator.</a>
        [/@ui.messageBox]
    [/@ww.form]
[#else]
    [@ww.form action="forgotPassword.action"
        id="forgotPasswordForm"
        submitLabelKey='user.password.reset.button'
        method="post"
        cancelUri='${req.contextPath}/userlogin!default.action'
    ]
        [@ww.textfield labelKey='user.username' name="username" /]
    [/@ww.form]
[/#if]

</body>
</html>