[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ViewDeploymentProjects" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ViewDeploymentProjects" --]

<html>
<head>
    <meta name="decorator" content="deploymentProjectDecorator"/>
    <meta name="tab" content="versions"/>
[@ui.header title=true object=deploymentProject.name pageKey='deployment.project.versions' /]
</head>
<body>
[#assign helpUrl][@help.href pageKey="deployments.versions.howtheywork"/][/#assign]
${soy.render("bamboo.deployments:view-deployment-project", "bamboo.page.deployment.project.projectVersionsPageBody", {
"deploymentProject": deploymentProject,
"deploymentVersionsWithCurrentEnvironments": deploymentVersionsWithCurrentEnvironments,
"deploymentVersionsWithHistoricalEnvironments": deploymentVersionsWithHistoricalEnvironments,
"helpUrl": helpUrl
})}
</body>
</html>
