[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentAssignments" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgentAssignments" --]
<html>
<head>
    <title>[@ww.text name='agents.assignment.agent.title' /] - ${agent.name?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
<h1>[@ww.text name='agents.assignment.agent.title' /] - ${agent.name?html}</h1>

<p>[@ww.text name='agents.assignment.agent.description' /]</p>

[@ww.form id='saveAgentAssignments'
    action='saveAgentAssignments'
    namespace='/admin/agent'
    submitLabelKey='global.buttons.update'
    cancelUri='${returnUrl}' ]

    [@ww.hidden name='agentId' /]

    [@ww.textfield name="addEnvironmentTextField" labelKey='agents.assignment.agent.environment' id="addEnvironmentTextField" placeholderKey='agents.assignment.agent.hint' cssClass="addEnvironmentTextField"/]
    [@ui.displayFieldGroup]
        [@ww.url id="capabilitiesTooltipUrl" value="/ajax/viewRejectedRequirements.action?agentId=${agentId}" /]

        <div class="selected-assignments bamboo-selected-set-table">
            ${soy.render("bamboo.feature.agent.assignment.environmentList", {
                "environments": existingEnvironments,
                "capabilitiesTooltipUrl": capabilitiesTooltipUrl
            })}
        </div>
        <script>
            (function ($)  {
                new BAMBOO.EnvironmentAssignmentMultiSelect({
                      el: $('#addEnvironmentTextField'),
                      selectedAssignmentsEl: $('.selected-assignments'),
                      bootstrap: ${action.toJson(allEnvironments)},
                      selectedAssignments: ${action.toJson(existingEnvironments)},
                      capabilitiesTooltipUrl: "${capabilitiesTooltipUrl}"
                  });
            }(jQuery));
        </script>
    [/@ui.displayFieldGroup]

<br/>
[/@ww.form]

</body>
</html>