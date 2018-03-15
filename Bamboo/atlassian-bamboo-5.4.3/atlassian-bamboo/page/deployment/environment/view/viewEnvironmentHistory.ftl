[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ViewEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ViewEnvironment" --]
<html>
<head>
    <meta name="decorator" content="deploymentEnvironmentDecorator"/>
    <meta name="tab" content="history"/>
    [@ww.text name="deployment.environment.header" id='deploymentHeader'][@ww.param value=environment.name/][/@ww.text]
    [@ui.header object=deploymentProject.name page=deploymentHeader title=true /]
</head>
<body>
    ${soy.render("bamboo.deployments:view-environment", "bamboo.page.deployment.environment.view.environmentHistory", {
        "environment": environment,
        "deploymentProject": deploymentProject,
        "deploymentResults": deploymentResults,
        "deploymentResultsCount": deploymentResultsCount,
        "latestDeploymentResult": latestDeploymentResult!,
        "currentUrl": currentUrl
    })}
</body>
</html>
