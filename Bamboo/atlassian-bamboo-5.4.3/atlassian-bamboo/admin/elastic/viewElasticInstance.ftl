[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
<html>
<head>
    <title>
    [@ww.text name='elastic.main.title' /]
    - [@ww.text name='elastic.instances.title' /]
    - ${instanceId}
    </title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ww.url namespace='/admin/elastic' action='manageElasticInstances' id='elasticMainUrl' /]
    [@ela.headerInstance instanceId=instanceId instanceListUrl=elasticMainUrl elasticMainUrl=elasticMainUrl /]

    [@ww.url id='elasticSnippetUrl' namespace='/ajax' action='viewElasticInstanceSnippet' instanceId=instanceId /]
    [@dj.reloadPortlet id='elasticInstanceWidget' url='${elasticSnippetUrl}' reloadEvery=10]
        [@ww.action name="viewElasticInstanceSnippet" namespace="/ajax" executeResult="true"]
            [@ww.param name='instanceId']${instanceId}[/@ww.param]
        [/@ww.action]
    [/@dj.reloadPortlet]

</body>
</html>