[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
<html>
<head>
	<title>[@ww.text name='elastic.configure.disable.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='elastic.configure.disable.title' /]</h1>
    [@ui.messageBox type="warning"]
        [#if runningElasticInstancesCount > 0 || requestedElasticInstancesCount > 0]
            [@ww.text name='elastic.configure.confirm.disable']
                [@ww.param value='${runningElasticInstancesCount}' /]
                [@ww.param value='${requestedElasticInstancesCount}' /]
            [/@ww.text]
        [#else]
            [@ww.text name='elastic.configure.confirm.disable.noagents'/]
        [/#if]
    [/@ui.messageBox]
    [@ww.form
         namespace='/admin/elastic'
         action='disableElasticConfig'
         submitLabelKey='global.buttons.confirm'
         cancelUri='/admin/elastic/viewElasticConfig.action'
    ]
    [/@ww.form]
</body>
</html>
