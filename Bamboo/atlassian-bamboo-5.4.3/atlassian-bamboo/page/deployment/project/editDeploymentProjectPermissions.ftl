[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectPermissions" --]
[#import "/fragments/permissions/permissions.ftl" as permissions/]
[@ww.text id="title" name="deployment.project.edit.permissions.title"]
    [@ww.param][#if deploymentProject??]${deploymentProject.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]
<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.project.permissions.howtheywork"][@ww.text name="deployments.project.permissions.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=title descriptionKey="deployment.project.edit.permissions.description" headerElement="h2"/]
<div class="aui-group permissionForm">
    <div class="aui-item formArea">
        [@ww.form action='updateDeploymentProjectPermissions' submitLabelKey='global.buttons.update' id='permissions' cancelUri='/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}' cssClass='top-label']
            [@permissions.permissionsEditor deploymentProjectId /]
            [@ww.hidden name='deploymentProjectId' /]
        [/@ww.form]
    </div>
    <div class="aui-item helpTextArea">
        <h3 class="helpTextHeading">[@ww.text name='build.permissions.type.heading' /]</h3>
        <ul>
            <li>
                <strong>[@ww.text name='build.permissions.type.view.heading' /]</strong> - Controls who can see this project and its associated environments.
            </li>
            <li>
                <strong>[@ww.text name='build.permissions.type.edit.heading' /]</strong> - Controls who can change the details of the project, related plan and any of the environment configuration. Users with edit permission can also create releases.
            </li>
        </ul>
        <div class="helpTextNote">
            <h4 class="helpTextHeading">Deploy permission</h4>
            <ul>
                <li>The control over who can deploy is set on a per environment basis</li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
