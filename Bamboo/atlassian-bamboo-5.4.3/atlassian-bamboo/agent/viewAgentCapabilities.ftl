[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
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
    <meta name="tab" content="capabilities" />
</head>
<body>

[@ui.header pageKey='agent.capability.title' /]
[@ui.bambooPanel]
    [@agt.displayCapabilities capabilitySetDecorator=combinedCapabilitySetDecorator showEdit=false showDelete=false /]
[/@ui.bambooPanel]

</body>
</html>