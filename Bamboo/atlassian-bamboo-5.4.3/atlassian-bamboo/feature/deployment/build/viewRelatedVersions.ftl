[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
${webResourceManager.requireResource("bamboo.deployments:deployment-project-list")}

[#if relatedDeployments?has_content]
${soy.render("bamboo.deployments:related-deployments", "bamboo.feature.deployment.build.relatedVersions", {
    "relatedDeployments": relatedDeployments,
    "planResultKey": resultsSummary.planResultKey,
    "buildState": resultsSummary.buildState
})}
[/#if]