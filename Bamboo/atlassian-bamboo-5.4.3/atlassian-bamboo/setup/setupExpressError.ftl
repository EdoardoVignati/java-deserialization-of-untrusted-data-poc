[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDefaultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDefaultsAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.standard.title' /]</title>
</head>

<body>

[@ui.header pageKey='setup.install.standard.heading' descriptionKey='setup.welcome' /]

[@ww.form action="${failedAction}" submitLabelKey='setup.install.express.retry' titleKey='setup.install.express.error' descriptionKey="setup.install.express.error.description" cancelUri="/setup/${customAction}.action" cancelSubmitKey="setup.install.express.switch"]
[/@ww.form]

</body>
</html>
