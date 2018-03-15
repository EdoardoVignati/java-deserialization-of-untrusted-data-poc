[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
<html>
<head>
    <title>[@ww.text name='agent.capability.view.title' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [#import "/admin/agent/viewCapabilityKeyMacro.ftl" as capabilityMacro]
    [@capabilityMacro.viewCapabilityKey mode="full" parentUrl=currentUrl/]
<body>
</body>
</html>