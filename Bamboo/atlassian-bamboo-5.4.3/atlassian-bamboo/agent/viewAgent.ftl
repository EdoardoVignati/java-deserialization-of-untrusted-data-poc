[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#import "/lib/menus.ftl" as menu/]
<html>
<head>
    <title>
    [@ww.text name='agent.view.heading.' + agent.type.identifier /]
    [#switch agent.type.identifier]
    [#case "local"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedLocalCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "remote"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedRemoteCapabilities' namespace='/admin/agent' /]
    [#break]    
    [#case "elastic"]
    [#break]
    [/#switch]    
     - ${agent.name?html}
    </title>
    <meta name="decorator" content="bamboo.agent"/>
    <meta name="tab" content="recent" />
</head>
<body>

[@cp.filterDropDown filterController=filterController isAgentFilter=true/]
[@ui.header pageKey='agent.recent' /]
[@ui.bambooPanel]
     [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true"][/@ww.action]
[/@ui.bambooPanel]

</body>
</html>