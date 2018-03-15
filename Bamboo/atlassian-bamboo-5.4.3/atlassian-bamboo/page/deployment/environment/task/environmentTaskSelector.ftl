[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentTasks" --]

[#import "/feature/task/taskConfigurationCommon.ftl" as tc/]

[@ww.url id="taskSelectionUrl" action="addEnvironmentTask" namespace="/deploy/config" environmentId=environmentId returnUrl=returnUrl /]
[@tc.taskSelector availableTasks taskSelectionUrl /]
