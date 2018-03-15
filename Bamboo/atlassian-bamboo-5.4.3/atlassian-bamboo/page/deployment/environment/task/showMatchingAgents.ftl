[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]

<html>
<head>
    <meta name="decorator" content="none"/>
</head>
<body>
    [#import "/agent/agentAvailability.ftl" as bd]
    [@ww.url id="viewAgentsUrl" value="/agent/viewAgents.action?environmentId=${environmentId}&returnUrl=/config/deploy/configureEnvironmentTasks.action?environmentId=${environmentId}" /]
    [@bd.showMatchingAgents executableAgentsMatrix "environment" viewAgentsUrl/]
</body>
</html>