[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]
[#assign showDeleteButton=(submitAction=="updateEnvironmentTask")/]
[@ww.url id="deleteUrl" action="confirmDeleteEnvironmentTask" namespace="/deploy/config" environmentId=environmentId taskId=taskId /]
[@tcc.invalidTaskPlugin  showDeleteButton deleteUrl/]