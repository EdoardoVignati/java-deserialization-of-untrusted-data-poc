[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ChangeForgottenPassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ChangeForgottenPassword" --]
<html>
<head>
    	<title>Bamboo Profile[#if user?exists]: [@ui.displayUserFullName user=user /][/#if]</title>
</head>
<body>
    <h1>[@ww.text name='user.password.reset' /]</h1>
        <p>
            [@ww.text name='user.password.reset.successful']
                [@ww.param][@ww.url action='userlogin!default' namespace='' os_destination='start.action' /][/@ww.param]
            [/@ww.text]
        </p>
</body>
</html>