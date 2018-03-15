[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProject" --]
<html>
<head>
[@ui.header title=true object=deploymentProject.name pageKey='Config' /]
    <meta name="decorator" content="deploymentConfigDecorator"/>
</head>
<body>
[#assign relatedPlanContent]
    [#if action.relatedPlan??]
        [#assign plan =  action.relatedPlan!/]
        [#if fn.hasPlanPermission('READ', plan) ]
            <a href="${req.contextPath}/browse/${plan.planKey.key}">${plan.project.name} &rsaquo; ${plan.buildName}</a>[#t]
        [#else]
            ${plan.project.name} &rsaquo; ${plan.buildName}[#t]
        [/#if]
    [#else]
        [@ww.text name='deployment.project.what.plan.notAvailable'/]
    [/#if]
[/#assign]
${soy.render("bamboo.deployments:configure-deployment-project", "bamboo.page.deployment.project.configureDeploymentProject", {
    "deploymentProject": deploymentProject,
    "environments": environments,
    "relatedPlan": relatedPlan!,
    "deploymentProjectItems": deploymentProjectItems!,
    "currentUrl": currentUrl?url,
    "selectedEnvironmentId": environmentId!
})}
</body>
</html>
