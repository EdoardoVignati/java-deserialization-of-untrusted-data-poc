[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.variable.ConfigureVariablesForEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.variable.ConfigureVariablesForEnvironment" --]
[#import "/fragments/variable/variables.ftl" as variables/]

[#assign headerText][@ww.text name="deployment.variables.title"][@ww.param]${environment.name?html}[/@ww.param][/@ww.text][/#assign]

<html>
<head>
${webResourceManager.requireResourcesForContext("ace.editor")}
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.variables.howtheywork"][@ww.text name="deployments.variables.howtheywork.title"/][/@help.url]</div>
[@ui.header page=headerText headerElement="h2" descriptionKey="deployment.variables.description"/]

[@ww.url id="createVariableUrl" namespace="/deploy/config" action="createEnvironmentVariable" environmentId=environmentId /]
[@ww.url id="deleteVariableUrl" namespace="/deploy/config" action="deleteEnvironmentVariable" environmentId=environmentId variableId="VARIABLE_ID"/]
[@ww.url id="updateVariableUrl" namespace="/deploy/config" action="updateEnvironmentVariable" environmentId=environmentId/]

    [@variables.configureVariables
        id="environmentVariables"
        variablesList=action.variables
        createVariableUrl=createVariableUrl
        deleteVariableUrl=deleteVariableUrl
        updateVariableUrl=updateVariableUrl
        overriddenVariablesMap=overriddenVariablesMap
        globalNotOverriddenVariables=globalNotOverriddenVariables
        tableId="environment-variable-config"/]

<div class="aui-toolbar inline tasks-back-button">
    <ul class="toolbar-group">
        <li class="toolbar-item">
            <a id="backToDeploymentProject" href="${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environment.id}" class="toolbar-trigger">
            [@ww.text name="deployment.environment.task.back" /]
            </a>
        </li>
    </ul>
</div>

</body>
</html>