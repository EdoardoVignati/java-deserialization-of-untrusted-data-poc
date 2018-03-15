[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[@ww.text id="tasksConfigFormTitle" name="tasks.config.form.title"]
    [@ww.param]${taskName!?html}[/@ww.param]
[/@ww.text]


[@ww.form   action=submitAction
            namespace="/build/admin/edit"
            submitLabelKey="global.buttons.update"
            cancelUri="/build/admin/edit/editBuildTasks.action?planKey=${planKey}"
            cssClass="top-label"]


    <div class="task-heading">
        <h2>${tasksConfigFormTitle}</h2>
    </div>
    [#if taskHelpLink??]
    <div class="task-help">
        [#if taskHelpLink.usingPrefix == true]
            [@help.url pageKey="${taskHelpLink.key}"][@ww.text name="${taskHelpLink.key}.title"/][/@help.url]
        [#else]
            <a id='taskHelpLink' href='[@ww.text name="${taskHelpLink.linkKey}"/]'>[@ww.text name="${taskHelpLink.titleKey}"/]</a>
        [/#if]
    </div>
    [/#if]

    [@ww.textfield name="userDescription" labelKey="tasks.userDescription" descriptionClass="assistive" cssClass="long-field"/]
    [@ww.checkbox name="taskDisabled" labelKey="tasks.disable" fieldClass="disable-checkbox" /]

    [#if repositoriesForWorkingDirSelection?has_content]
        [@ww.select labelKey='tasks.workingDirectory'
                    name='workingDirSelector'
                    list='workingDirSelectorOptions'
                    toggle='true'
        /]
        [@ui.bambooSection dependsOn='workingDirSelector' showOn='REPOSITORY']
            [@ww.select labelKey='job.workingDirectory.definingRepository'
                name='repositoryDefiningWorkingDirectory'
                list='repositoriesForWorkingDirSelection'
            /]
        [/@ui.bambooSection]
    [/#if]

    ${editHtml!}

    [@ww.hidden name="createTaskKey"/]
    [@ww.hidden name="taskId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]