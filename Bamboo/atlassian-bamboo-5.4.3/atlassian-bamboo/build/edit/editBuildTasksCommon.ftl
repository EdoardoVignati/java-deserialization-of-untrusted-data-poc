[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="planKey" type="java.lang.String" --]
[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]

[@ww.url id="taskSelectorUrl" action="viewTaskTypes" namespace="/build/admin/edit" planKey=planKey returnUrl=currentUrl /]
[@ww.url id="agentAvailabilityUrl" action="showAgentNumbers" namespace="/ajax/build/admin" planKey=immutablePlan.key /]
[@ww.url id="editTaskUrl" action="editTask" namespace="/build/admin/edit" planKey=planKey /]
[@ww.url id="deleteTaskUrl" action="confirmDeleteTask" namespace="/build/admin/edit" planKey=planKey /]
[@ww.url id="moveTaskUrl" action="moveTask" namespace="/build/admin/ajax" planKey=planKey /]
[@ww.url id="moveFinalBarUrl" action="moveFinalBar" namespace="/build/admin/ajax" planKey=planKey /]

[@tcc.editTasksCommon taskSelectorUrl agentAvailabilityUrl editTaskUrl deleteTaskUrl moveTaskUrl moveFinalBarUrl/]
