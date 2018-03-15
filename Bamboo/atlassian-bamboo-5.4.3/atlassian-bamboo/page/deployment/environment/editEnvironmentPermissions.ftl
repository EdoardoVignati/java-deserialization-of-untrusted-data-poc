[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentPermissions" --]
[#import "/fragments/permissions/permissions.ftl" as permissions/]
[@ww.text id="title" name="environment.edit.permissions.title"]
    [@ww.param][#if environment??]${environment.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]
<html>
<head>
[@ui.header pageKey=title title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.environment.permissions.howtheywork"][@ww.text name="deployments.environment.permissions.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=title descriptionKey="environment.edit.permissions.description" headerElement="h2"/]
    <div class="aui-group permissionForm">
        <div class="aui-item formArea">
        [@ww.form action='updateEnvironmentPermissions' submitLabelKey='global.buttons.update' id='permissions' cancelUri='/deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environmentId}' cssClass='top-label']
            [@permissions.permissionsEditor entityId=environmentId /]
            [@ww.hidden name='environmentId' /]
            [@ww.hidden name='deploymentProjectId' /]
        [/@ww.form]
        </div>
        <div class="aui-item helpTextArea">
            <h3 class="helpTextHeading">[@ww.text name='build.permissions.type.heading' /]</h3>
            <ul>
                <li>
                    <strong>[@ww.text name='build.permissions.type.view.heading' /]</strong> - Controls who can see this environment and its deployment results.  Users must have view permission on the deployment project.
                </li>
                <li>
                    <strong>[@ww.text name='build.permissions.type.edit.heading' /]</strong> - Controls who can edit this environment
                </li>
                <li>
                    <strong>[@ww.text name='environment.permissions.type.execute.heading'/]</strong> - Defines who can releases for this project and who can deploy them to this environment.
                </li>
            </ul>

            [#if deploymentProject.operations.canEdit]
                <div class="helpTextNote">
                    <a href="${req.contextPath}/deploy/config/configureDeploymentProjectPermissions.action?deploymentProjectId=${deploymentProject.id}">Edit project permissions</a>
                </div>
            [/#if]
        </div>
    </div>

</body>
</html>
[#-- ======================================================================================== @deployment.project.shared.permissionCheckBox --]

