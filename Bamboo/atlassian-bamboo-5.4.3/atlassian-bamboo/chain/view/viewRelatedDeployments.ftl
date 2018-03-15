[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]

[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
[@ui.header pageKey='plan.summary.related.deployments' object=immutablePlan.name title=true /]
    <meta name="tab" content="deployments"/>
</head>
<body>
    [#-- Deployments --]
    <h2>[@ww.text name='plan.summary.related.deployments'/]</h2>
    ${soy.render("bamboo.deployments:related-deployments", "bamboo.feature.deployment.build.relatedDeployments", {
        "id": "related-deployment-project-list",
        "projectsWithEnvironmentStatuses": relatedDeploymentProjects,
        "relatedVersions": relatedVersions,
        "planKey": immutablePlan.key,
        "currentUrl": currentUrl
    })}
</body>
</html>
