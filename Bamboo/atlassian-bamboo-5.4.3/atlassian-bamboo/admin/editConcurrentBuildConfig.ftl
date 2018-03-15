[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]

<html>
<head>
	<title>[@ww.text name='admin.concurrentBuilds.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='admin.concurrentBuilds.title' /]</h1>

    <p>[@ww.text name='admin.concurrentBuilds.description' /]</p>

    [@ww.form action="saveConcurrentBuildConfig.action"
              id="saveConcurrentConfigForm"
              submitLabelKey='global.buttons.update'
              titleKey='admin.concurrentBuilds.edit.title'
              cancelUri='/admin/viewConcurrentBuildConfig.action'
    ]
         [@ww.textfield labelKey='admin.concurrentBuilds.number' name='numberConcurrentBuilds' /]
    [/@ww.form]
</body>
</html>