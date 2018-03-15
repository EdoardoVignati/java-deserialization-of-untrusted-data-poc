[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]


${soy.render("bamboo.deployments:view-deployment-version", "bamboo.page.deployment.version.deploymentStatus", {
"deploymentVersion": deploymentVersion,
"deploymentProject": deploymentProject,
"deploymentEnvironmentStatuses": versionDeploymentStatuses,
"currentUrl" : currentUrl,
"hideActions": true
})}