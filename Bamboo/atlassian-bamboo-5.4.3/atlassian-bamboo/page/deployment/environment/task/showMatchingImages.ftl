[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]

<html>
<head>
    <meta name="decorator" content="none"/>
</head>
<body>
    [#import "/agent/agentAvailability.ftl" as bd]
    [@bd.showMatchingImages executableAgentsMatrix "environment"/]
</body>
</html>