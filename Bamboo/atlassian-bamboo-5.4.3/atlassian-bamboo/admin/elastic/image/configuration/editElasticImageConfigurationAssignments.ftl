[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfigurationAssignments" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfigurationAssignments" --]
<html>
<head>
    <title>[@ww.text name='agents.assignment.image.title' /] - ${image.configurationName?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
<h1>[@ww.text name='agents.assignment.image.title' /] - ${image.configurationName?html}</h1>

<p>[@ww.text name='agents.assignment.image.description' /]</p>

[@ww.form   id='saveElasticImageAssignments'
            action='saveElasticImageAssignments'
            namespace='/admin/elastic/image/configuration'
            submitLabelKey='global.buttons.update'
            cancelUri='${returnUrl}' ]

    [@ww.hidden name='configurationId' /]

    [@ww.textfield name="addEnvironmentTextField" labelKey='agents.assignment.agent.environment' id="addEnvironmentTextField" placeholderKey='agents.assignment.agent.hint' cssClass="addEnvironmentTextField"/]
    [@ui.displayFieldGroup]
        [@ww.url id="capabilitiesTooltipUrl" value="/ajax/viewRejectedRequirements.action?imageConfigurationId=${image.id}" /]
        <div class="selected-assignments bamboo-selected-set-table">
            ${soy.render("bamboo.feature.agent.assignment.environmentList", {
                "environments": existingEnvironments,
                "capabilitiesTooltipUrl": capabilitiesTooltipUrl
            })}
        </div>
        <script>
            (function ($) {
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
[/@ww.form]

</body>
</html>