[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
<html>
<head>
    <title>[@ww.text name='error.accessDenied.title' /]</title>
    <meta name="decorator" content="main" />
</head>

<body>
    <h1>[@ww.text name='error.accessDenied.heading' /]</h1>
    <p>
        [@ww.text name='error.accessDenied.message']
            [@ww.param]<a href="${req.contextPath}/viewAdministrators.action">[/@ww.param]
            [@ww.param]</a>[/@ww.param]
        [/@ww.text]
    </p>
    <h4>[@ww.text name='error.accessDenied.nav.title' /]</h4>
    <ul>
        <li><a href="${req.contextPath}/">[@ww.text name='error.accessDenied.nav.home' /]</a></li>
    </ul>
</body>
</html>