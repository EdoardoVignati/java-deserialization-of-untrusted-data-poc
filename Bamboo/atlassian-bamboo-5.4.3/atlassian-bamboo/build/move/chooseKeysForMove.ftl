[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[@ui.header pageKey='build.move.configure.title' title=true /]
[@ui.header pageKey='build.move.configure.title' /]

[#assign chooseKeysToMoveDescription]
    [@ww.text name='build.move.configure.description']
        [@ww.param]${selectedProject.name}[/@ww.param]
    [/@ww.text]
[/#assign]
[#if selectedPlans?has_content]
    [@ww.form action="moveBuilds" namespace="/admin"
              cancelUri='/admin/chooseBuildsToMove.action'
              submitLabelKey='global.buttons.move'
              description=chooseKeysToMoveDescription
              titleKey='build.move.configure.form.title']
        [@ww.hidden name='projectKey' theme='simple' /]
        [@ww.hidden name='projectName' theme='simple' /]
        [@ww.hidden name='existingProjectKey' theme='simple' /]

        [#if !action.isNewProject(existingProjectKey)]
            [#assign projectPlans = action.getSortedTopLevelPlans(selectedProject)/]
            [#if projectPlans?has_content]
                <p>[@ww.text name='build.move.configure.existing' /]</p>
                <ul>
                    [#list projectPlans as chain]
                        <li>${chain.buildName} <i>(${chain.buildKey})</i></li>
                    [/#list]
                </ul>
            [/#if]
        [/#if]  

        <table class="aui">
            <thead>
                <tr>
                    <th>Original Project</th>
                    <th>Original Name</th>
                    <th>New Name</th>
                    <th>Original Key</th>
                    <th>New Key</th>
                </tr>
            </thead>
            <tbody>
            [#list selectedPlans as plan]
                <tr>
                    <td>
                        ${plan.project.name}<br><i>(${plan.project.key})</i>
                    </td>
                    <td>
                        ${plan.buildName}
                    </td>
                    <td>
                        [@ww.hidden name='planIds' value='${plan.id}' theme='simple' /]
                        [@ww.textfield name='planNameMappings[${plan.id}]' theme='inline'/]
                    </td>
                    <td>${plan.buildKey}</td>
                    <td>
                        [@ww.textfield name='planKeyMappings[${plan.id}]' theme='inline'/]
                    </td>
                </tr>
            [/#list]
            </tbody>
        </table>
    [/@ww.form]
[#else]
    [@ww.text name='build.move.plans.none' /]
[/#if]
        