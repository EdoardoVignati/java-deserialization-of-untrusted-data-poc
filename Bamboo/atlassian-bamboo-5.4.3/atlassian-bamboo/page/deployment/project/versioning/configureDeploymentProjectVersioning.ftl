[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectVersioning" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectVersioning" --]

[#assign headerText]
    [@ww.text name="deployment.project.version.title"]
        [@ww.param]${(deploymentProject.name)!''}[/@ww.param]
    [/@ww.text]
[/#assign]

<html>
<head>
[@ui.header pageKey=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.versioning.howtheywork"][@ww.text name="deployments.versioning.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=headerText headerElement='h2'/]

[@ww.form action="saveDeploymentProjectVersioning" namespace="/deploy/config" submitLabelKey="global.buttons.update" cancelUri='/deploy/config/configureDeploymentProject.action?id=${id}' descriptionKey="deployment.project.version.description"]
    [@ww.hidden name="id"/]
    <h3>[@ww.text name="deployment.project.version.createname" /]</h3>

    <div class="deployment-project-version-naming">
        [#assign previewButton][@cp.displayLinkButton buttonId='preview-button' buttonLabel='deployment.project.version.preview.button' buttonUrl=""/][/#assign]
        [@ww.textfield id="next-version"  labelKey='deployment.project.version.next' name='nextVersion' required=true cssClass="long-field" after=previewButton /]
        <a class="add-variable">[@ww.text name="deployment.project.version.addvariable" /]</a>
    </div>

    <h3>[@ww.text name="deployment.project.version.autoincrement"/]</h3>
    [@ww.text name="deployment.project.version.autoincrement.description"/]

    <fieldset class="group">
        <legend>
            <span>[@ww.text name="deployment.project.version.autoincrement.numbers"/]</span>
        </legend>
        [@ww.checkbox labelKey='deployment.project.version.autoincrement.numbers.last' name='autoIncrement'/]
    </fieldset>

    ${soy.render("bamboo.deployments:configure-deployment-project", "bamboo.page.deployment.project.versioning.variableIncrementContainer", {})}

    <h3>[@ww.text name="deployment.project.version.preview"/]</h3>
    <div class="aui-group">
        <div id="version-preview" class="aui-item" >
            [@ui.icon type="loading" /]
        </div>
        <div class="aui-item version-preview-hint">
            [@ww.text name='deployment.project.version.preview.hint.title'/]
            <p>[@ww.text name='deployment.project.version.preview.hint.message'/]</p>
        </div>
    </div>

    <script>
        AJS.$(function ($) {
            BAMBOO.deploymentProjectVersioning.init({
                deploymentProjectId: ${deploymentProject.id},
                addVariableDialogUrl: "${req.contextPath}/rest/api/latest/deploy/projectVersioning/${deploymentProject.id}/variables",
                versionPreviewUrl: "${req.contextPath}/rest/api/latest/deploy/projectVersioning/${deploymentProject.id}/namingPreview",
                versionVariablesUrl: "${req.contextPath}/rest/api/latest/deploy/projectVersioning/${deploymentProject.id}/parseVariables",
                currentlySelectedVariables: ${action.toJson(variablesToAutoIncrement)},
                selectors: {
                    addVariable: ".add-variable",
                    nextVersion: "#next-version",
                    versionPreview: "#version-preview",
                    versionPreviewButton: "#preview-button",
                    variableCheckboxList: "#variable-increment-checkboxes",
                    form: "#saveDeploymentProjectVersioning"
                }
            });
        }(jQuery));
    </script>
[/@ww.form]

</body>
</html>
