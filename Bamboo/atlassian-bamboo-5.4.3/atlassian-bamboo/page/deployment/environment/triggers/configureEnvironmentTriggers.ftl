[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.triggers.ConfigureEnvironmentTriggers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.triggers.ConfigureEnvironmentTriggers" --]
[#assign headerText][@ww.text name="deployment.triggers.title"][@ww.param]${environment.name?html}[/@ww.param][/@ww.text][/#assign]

<html>
<head>
${webResourceManager.requireResourcesForContext("ace.editor")}
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.triggers.howtheywork"][@ww.text name="deployments.triggers.howtheywork.title"/][/@help.url]</div>
[@ui.header page=headerText headerElement="h2"/]

<p>[@ww.text name="deployment.triggers.description"/]</p>

[#import "/feature/triggers/triggersEditCommon.ftl" as triggers/]

[@ww.url id="editTriggerUrl" action="editEnvironmentTrigger" namespace="/deploy/config" environmentId=environmentId/]
[@ww.url id="confirmDeleteTriggerUrl" action="confirmDeleteEnvironmentTrigger" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="addTriggerUrl" action="addEnvironmentTrigger" namespace="/deploy/config" environmentId=environmentId returnUrl=currentUrl /]

[@triggers.triggersMainPanel triggers=action.getTriggers() addTriggerUrl=addTriggerUrl editTriggerUrl=editTriggerUrl confirmDeleteTriggerUrl=confirmDeleteTriggerUrl/]

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