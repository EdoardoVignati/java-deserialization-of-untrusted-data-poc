[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupAdminUserAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupAdminUserAction" --]
<html>
<head>
    <title>[@ww.text name='setup.user.admin.title' /]</title>
    <meta name="step" content="4">
</head>

<body>

[@ui.header pageKey='setup.user.admin.heading' descriptionKey='setup.user.admin.description' headerElement='h2' /]

[@ww.actionerror /]

[@ww.form action="performSetupAdminUser" method="post" submitLabelKey='global.buttons.finish']
    [@ui.bambooSection]
        [@ww.textfield labelKey='user.username' descriptionKey='user.username.description' name="username" required="true" value="${((systemInfo.userName)?lower_case)!'${username!}'}" /]
        [@ww.password labelKey='user.password' name="password" showPassword="true" required="true" /]
        [@ww.password labelKey='user.password.confirm' name="confirmPassword" showPassword="true" required="true" /]
        [@ww.textfield labelKey='user.fullName' name="fullName" required="true" /]
        [@ww.textfield labelKey='user.email' name="email" required="true" /]
    [/@ui.bambooSection]
[/@ww.form]

</body>
</html>