[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]
<html>
<head>
    <meta name="decorator" content="deploymentVersionDecorator"/>
    <meta name="tab" content="variables"/>
    [@ww.text id='headerText' name='deployment.version.header'][@ww.param]${deploymentVersion.name?html}[/@ww.param][/@ww.text]
    [@ui.header title=true object=deploymentProject.name pageKey=headerText /]
</head>
<body>
<h2>[@ww.text name='deployment.version.variables' /]</h2>
<p>[@ww.text name='deployment.version.variables.description' /]</p>

[#if availableVariables?has_content]
    [@variables.displaySubstitutedVariables id="versionVariables" variablesList=availableVariables/]
[#else]
<p>[@ww.text name='deployment.version.noVariables'/]</p>
[/#if]
</body>
</html>
