[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.execution.actions.ViewDeploymentResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.execution.actions.ViewDeploymentResult" --]
<html>
<head>
    [@ww.text id='header' name='deployment.result.header'][@ww.param value=deploymentResult.environment.name /][@ww.param]${deploymentResult.deploymentVersion.name?html}[/@ww.param][/@ww.text]
    [@ui.header page=header title=true/]
    <meta name="decorator" content="deploymentResultDecorator"/>
</head>
<body>

<div id="deployment-result">
    ${soy.render("bamboo.deployments:view-deployment-result", "bamboo.page.deployment.project.viewDeploymentResult", {
        "deploymentResult": deploymentResult,
        "initialLoad": true,
        "environment": environment
    })}
</div>
[#if deploymentResult.lifeCycleState == 'Finished' || deploymentResult.lifeCycleState == 'NotBuilt']
    [@cp.displayDeploymentErrors deploymentErrors deploymentResult currentUrl/]
[/#if]

<script>
    AJS.$(function () {
        BAMBOO.DeploymentResult.init({
            resultContainerSelector: "#deployment-result",
            resultStatusRibbonSelector: "#deployment-status-ribbon",
            linesToDisplaySelector: "#linesToDisplay",
            resultUrl: "${req.contextPath}/rest/api/latest/deploy/result/${deploymentResult.id}?includeLogs=true",
            environment: ${action.toJson(environment)},
            lifeCycleState: "${deploymentResult.getLifeCycleState().name()}",
            reloadUrl: "${req.contextPath}${currentUrl}"
        });
    });
</script>
</body>
</html>
