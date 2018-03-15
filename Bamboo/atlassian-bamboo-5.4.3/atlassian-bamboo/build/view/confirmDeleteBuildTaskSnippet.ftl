[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.DeleteTask" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.DeleteTask" --]
<meta name="decorator" content="none"/>
[@ww.form   action="deleteTask"
            namespace="/build/admin/edit"
            submitLabelKey="global.buttons.delete"
            cancelUri="/build/admin/edit/editBuildTasks.action?planKey=${planKey}"]
    [@ui.messageBox type="warning" titleKey="tasks.delete.confirm" /]

    [@ww.hidden name="createTaskKey"/]
    [@ww.hidden name="taskId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]