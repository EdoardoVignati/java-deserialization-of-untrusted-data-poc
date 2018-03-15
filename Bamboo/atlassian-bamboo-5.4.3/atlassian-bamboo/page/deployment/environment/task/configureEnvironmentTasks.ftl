[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentTasks" --]
[#if environment.configurationState == 'TASKED']
    [#assign headerText][@ww.text name="deployment.environment.task.update"][@ww.param]${environment.name?html}[/@ww.param][/@ww.text][/#assign]
[#else]
    [#assign headerText][@ww.text name="deployment.environment.task.create"][@ww.param]${environment.name?html}[/@ww.param][/@ww.text][/#assign]
[/#if]

<html>
<head>
    ${webResourceManager.requireResourcesForContext("ace.editor")}
    [@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

[#import "/build/edit/editBuildConfigurationCommon.ftl" as ebcc/]
[#import "/lib/build.ftl" as bd]

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.tasks.howtheywork"][@ww.text name="deployments.tasks.howtheywork.title"/][/@help.url]</div>
[@ui.header page=headerText headerElement="h2"/]


<p>[@ww.text name="deployment.environment.task.description"/]</p>
[#--todo variable help--]

<p class="short-agent-desc">
    [@ww.action name="showAgentNumbers" namespace="/deploy/config" executeResult="true" /]
</p>

[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]
[@ww.url id="taskSelectorUrl" action="viewTaskTypes" namespace="/deploy/config" environmentId=environmentId returnUrl=currentUrl /]
[@ww.url id="editTaskUrl" action="editEnvironmentTask" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="deleteTaskUrl" action="confirmDeleteEnvironmentTask" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="moveTaskUrl" action="moveTask" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="moveFinalBarUrl" action="moveFinalBar" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="agentAvailabilityUrl" action="showAgentNumbers" namespace="/deploy/config" environmentId=environmentId /]

[@tcc.editTasksCommon taskSelectorUrl agentAvailabilityUrl editTaskUrl deleteTaskUrl moveTaskUrl moveFinalBarUrl/]

<div class="aui-toolbar inline tasks-back-button">
    <ul class="toolbar-group">
        <li class="toolbar-item">
            <a id="backToDeploymentProject" href="${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environment.id}" class="toolbar-trigger">
                [#if environment.configurationState == 'CREATED' || environment.configurationState == 'DETAILED']
                    [@ww.text name="deployment.environment.task.finish" /]
                [#else]
                    [@ww.text name="deployment.environment.task.back" /]
                [/#if]
            </a>
        </li>
    </ul>
</div>

</body>
</html>