[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.Login" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.Login" --]
<html>
<head>
    <title>[@ww.text name='user.login.title' /]</title>
    <meta name="decorator" content="login" />
    <meta name="topCrumb" content="login" />
</head>

<body>

[#if req.getParameter("os_destination")??]
    [#assign destination = '${req.getParameter(\"os_destination\")}']
[#elseif (session.getAttribute("ACEGI_SAVED_REQUEST_KEY"))??]
    [#assign destination = '${session.getAttribute("ACEGI_SAVED_REQUEST_KEY").servletPath}?${session.getAttribute("ACEGI_SAVED_REQUEST_KEY").queryString!}']
[#else]
    [#assign destination = '/start.action']
[/#if]

<header>
    [@ui.header pageKey="user.login.heading" /]
</header>
[@ww.form action="userlogin"
              id="loginForm"
              method="post"
              submitLabelKey='user.login.button'
              cancelUri='${req.contextPath}/forgotPassword!default.action'
              cancelSubmitKey='user.login.description'
]
    [@ww.hidden name="os_destination" value=destination /]
    [@ww.textfield labelKey='user.username' name="os_username" autofocus=true /]
    [@ww.password labelKey='user.password' name="os_password" showPassword="true" /]
    [@ww.checkbox id="os_cookie_id" labelKey='user.login.remember' name="os_cookie" accesskey="R" /]
[#if elevatedSecurityRequired]
    [@cp.captcha/]
[/#if]
[/@ww.form]