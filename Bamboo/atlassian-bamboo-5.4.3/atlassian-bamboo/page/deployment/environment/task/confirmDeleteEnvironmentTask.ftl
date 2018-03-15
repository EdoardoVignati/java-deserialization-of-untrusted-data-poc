[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DeleteEnvironmentTask" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DeleteEnvironmentTask" --]

[@ww.form   action="deleteEnvironmentTask"
            namespace="/deploy/config"
            submitLabelKey="global.buttons.delete"
            cancelUri="/deploy/config/configureEnvironmentTasks.action?environmentId=${environmentId}"
]
    [@ui.messageBox type="warning" titleKey="tasks.delete.confirm" /]
    [@ww.hidden name="taskId"/]
    [@ww.hidden name="environmentId"/]
[/@ww.form]