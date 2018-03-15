[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionCommits" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionCommits" --]
[#import "deploymentComparisonVersionPicker.ftl" as dcvp/]

<html>
<head>
    <meta name="decorator" content="deploymentVersionDecorator"/>
    <meta name="tab" content="commits"/>
    [@ww.text id='headerText' name='deployment.version.header'][@ww.param]${deploymentVersion.name?html}[/@ww.param][/@ww.text]
    [@ui.header title=true object=deploymentProject.name pageKey=headerText /]
</head>
<body>
<h2>[@ww.text name='deployment.version.commits' /]</h2>
<p>[@ww.text name='deployment.version.sameBranchesInfo'/]</p>
[#if hasVersionsToCompare!false]
    [@dcvp.deploymentComparisonVersionPicker "viewDeploymentVersionCommits" deploymentProject deploymentVersion planResultKey compareWithVersion/]
[/#if]

[#include "./viewDeploymentVersionCommitsSnippet.ftl"/]
</body>
</html>

