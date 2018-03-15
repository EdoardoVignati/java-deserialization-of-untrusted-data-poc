[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[@ui.header pageKey='build.move.title' title=true /]
[@ui.header pageKey='build.move.title' /]

[#if !buildQueuesDisabled]
    [@ww.text name='build.move.warning' id="buildMoveWarning"]
        [@ww.param]<a href="[@ww.url action='configureAgents!deactivateAll' class="mutative" namespace='/admin/agent' returnUrl='${currentUrl}'/]">[/@ww.param]
        [@ww.param]</a>[/@ww.param]
    [/@ww.text]
    [@ui.messageBox type="warning" title=buildMoveWarning /]
[/#if]

[#if sortedProjects?has_content]
    [@ww.form action="selectBuildsToMove" namespace="/admin"
              submitLabelKey='global.buttons.move'
              titleKey='build.move.form.title'
              descriptionKey='build.move.description']

        [@ww.select labelKey='build.move.destination.project' name='existingProjectKey' toggle='true'
                    list='sortedProjects' listKey='key' listValue='name'
                    headerKey='newProject' headerValue='New Project' groupLabel="Projects" ]
        [/@ww.select]

        [@ui.bambooSection dependsOn='existingProjectKey' showOn='newProject']
            [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
            [@ww.textfield labelKey='project.key' name='projectKey' required='true' /]
        [/@ui.bambooSection]

        [@cp.displayBulkActionSelector bulkAction=action checkboxFieldValueType='id' planCheckboxName='planIds' /]
    [/@ww.form]
[#else]
    [@ww.text name='build.move.plans.none' /]
[/#if]
