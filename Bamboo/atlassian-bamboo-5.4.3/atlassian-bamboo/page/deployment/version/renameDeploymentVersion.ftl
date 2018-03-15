[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.RenameDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.RenameDeploymentVersion" --]

[#assign headerText]
    [@ww.text name='deployment.version.rename.title'/]
[/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='deployments.versions.howtheywork'][@ww.text name='deployments.versions.howtheywork.title'/][/@help.url]</div>
[@ui.header page=headerText headerElement='h2'/]

[@ww.form id='renameDeploymentVersion' action='doRenameDeploymentVersion' namespace='/deploy' cancelUri='${cancelUrl!"/deploy/viewDeploymentVersion.action?versionId=${versionId}"}']
    [@ww.hidden name='versionId'/]
    [@ww.hidden name='cancelUrl'/]
    [@ww.textfield labelKey='deployment.version.create.pick.name' name='newVersionName' required='true' /]
    [@ww.param name='buttons']
        [@ww.submit value=action.getText('deployment.version.actions.rename') name='save' primary=true /]
    [/@ww.param]
[/@ww.form]

</body>
</html>