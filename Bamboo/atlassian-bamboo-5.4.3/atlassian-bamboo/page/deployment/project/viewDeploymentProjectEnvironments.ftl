[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ViewDeploymentProjects" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ViewDeploymentProjects" --]

<html>
<head>
    <meta name="decorator" content="deploymentProjectDecorator"/>
    <meta name="tab" content="environments"/>
    [@ui.header title=true object=deploymentProject.name pageKey='deployment.project.environments' /]
</head>
<body>
    ${soy.render("bamboo.deployments:view-deployment-project", "bamboo.page.deployment.project.projectEnvironmentsPageBody", {
        "deploymentProject": deploymentProject,
        "relatedPlan": relatedPlan!,
        "deploymentProjectItems": deploymentProjectItems!,
        "environments": environments,
        "currentUrl": currentUrl
    })}
</body>
</html>
