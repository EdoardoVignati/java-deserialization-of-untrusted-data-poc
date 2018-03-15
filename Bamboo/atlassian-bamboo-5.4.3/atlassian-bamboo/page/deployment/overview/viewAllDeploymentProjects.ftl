[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ViewAllDeploymentProjects" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ViewAllDeploymentProjects" --]
<html>
<head>
[@ui.header pageKey="deployment.title" title=true/]
    <meta name="decorator" content="deploymentMinimal"/>

</head>

<body>

[#if deploymentProjects?has_content]

    [@ww.text id="allDeploymentsHeader" name="deployment.project.all"/]

    [#assign content]
    ${soy.render("bamboo.deployments:deployment-project-list", "bamboo.feature.deployment.project.projectList.container", {
    "id": "deployment-project-list",
    "showProject": true,
    "currentUrl": currentUrl
    })}
    [/#assign]

    ${soy.render("bamboo.deployments:deployments-main", "bamboo.layout.deployment", {
        "headerText": allDeploymentsHeader,
        "content": content
    })}

[#else]
    ${webResourceManager.requireResourcesForContext("atl.dashboard")}

    ${soy.render("bamboo.deployments:deployments-main", "bamboo.layout.deployment", {
                 "headerText": action.getText("deployment.welcome.heading"),
                 "content": soy.render('bamboo.feature.dashboard.welcomeMat.welcomeMessageDeploy', {
                                       "hasGlobalCreatePermission": fn.hasGlobalPermission('CREATE'),
                                       "hasBuilds": ctx.hasBuilds()
                            })
    })}
[/#if]

</body>
</html>