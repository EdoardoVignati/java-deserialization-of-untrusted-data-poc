[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
<html>
<head>
    <title>[@ww.text name='error.403.title' /]</title>
</head>

<body>
    <h1>[@ww.text name='error.403.heading' /]</h1>
    <p>
        [@ww.text name='error.403.message' /]
    </p>
    <h4>[@ww.text name='error.403.nav.title' /]</h4>
    <ul>
        <li><a href="${req.contextPath}/">[@ww.text name='error.403.nav.home' /]</a></li>
    </ul>
</body>
</html>