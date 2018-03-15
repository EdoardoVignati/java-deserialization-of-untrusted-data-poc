[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.agents.ConfigureEnvironmentAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.agents.ConfigureEnvironmentAgents" --]
[#import "/fragments/variable/variables.ftl" as variables/]

[#assign headerText][@ww.text name="deployment.environment.agents"]
    [@ww.param]${environment.name}[/@ww.param]
[/@ww.text][/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.assigned.agents.howtheywork"][@ww.text name="deployments.assigned.agents.howtheywork.title"/][/@help.url]</div>
[@ui.header page=headerText headerElement="h2"/]
<p>[@ww.text name="deployment.environment.agents.description"][@ww.param][@help.href pageKey='capabilities.and.requirements'/][/@ww.param][/@ww.text]</p>
<p>[@ww.text name="deployment.environment.agents.description.note"/]</p>

[@ww.url id="capabilitiesTooltipUrl" value="/ajax/viewRejectedRequirements.action?environmentId=${environmentId}" /]
[@ww.form   action="saveEnvironmentAgents"
            namespace="/deploy/config"
            submitLabelKey="global.buttons.update"
            cancelUri='/deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environment.id}']
    [@ww.hidden name="environmentId"/]
    [@ww.textfield name="addAgentTextField" labelKey='deployment.environment.agents.field' id="addAgentTextField" placeholderKey='deployment.environment.agents.field.hint' cssClass="addAgentTextField"/]
    [@ui.displayFieldGroup]
        <div class="selected-assignments bamboo-selected-set-table">
            ${soy.render("bamboo.feature.agent.assignment.agentList", {
                "agentAssignmentExecutors": existingAgentAssignments,
                "capabilitiesTooltipUrl": capabilitiesTooltipUrl
            })}
        </div>
    [/@ui.displayFieldGroup]
    <script>
        (function ($) {
            new BAMBOO.AgentAssignmentMultiSelect({
                  el: $('#addAgentTextField'),
                  selectedAssignmentsEl: $('.selected-assignments'),
                  bootstrap: ${action.toJson(possibleAgentAssignments)},
                  selectedAssignments: ${action.toJson(existingAgentAssignments)},
                  capabilitiesTooltipUrl: "${capabilitiesTooltipUrl}"
              });
        }(jQuery));
    </script>
[/@ww.form]
</body>
</html>