[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.signup.SignupUser" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.signup.SignupUser" --]
<html>
<head>
    <title>[@ww.text name='user.signup' /]</title>
    <meta name="decorator" content="login" />
</head>

<body>

<header>
    [@ui.header pageKey="user.signup" descriptionKey="user.signup.description" /]
</header>
[@ww.form action="signupUser"
          submitLabelKey='user.signup.button'
          cancelUri='${req.contextPath}/userlogin!default.action'
]
    [@ww.textfield labelKey='user.username' name="username" required="true" /]
    [@ww.password labelKey='user.password' name="password" showPassword="true" required="true" /]
    [@ww.password labelKey='user.password.confirm' name="confirmPassword" showPassword="true" required="true" /]

    [@ww.textfield labelKey='user.fullName' name="fullName" required="true" /]
    [@ww.textfield labelKey='user.email' name="email" required="true" /]
    [@ww.textfield labelKey='user.jabber' name="jabberAddress" /]

    [#if enabledCaptchaOnSignup]
        [@cp.captcha/]
    [/#if]
[/@ww.form]

