[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='elastic.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

[@ww.text name='elastic.manage.description' id='elasticManageDescription']
    [@ww.param]<a href="${req.contextPath}/admin/elastic/allElasticInstances.action">[/@ww.param]
    [@ww.param]</a>[/@ww.param]
    [@ww.param][@help.href pageKey="elastic.instance.manage"/][/@ww.param]
[/@ww.text]
[@ui.header pageKey='elastic.manage.heading' description=elasticManageDescription /]

[@dj.reloadPortlet id='elasticWidget' url='${req.contextPath}/ajax/viewElasticSnippet.action' reloadEvery=10]
    [@ww.action name="viewElasticSnippet" namespace="/ajax" executeResult="true" /]
[/@dj.reloadPortlet]
</body>
</html>

