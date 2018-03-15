[#import "/feature/task/taskConfigurationCommon.ftl" as tcc/]
[#assign showDeleteButton=(submitAction=="updateTask")/]
[@ww.url id="deleteUrl" action="confirmDeleteTask" namespace="/build/admin/edit" planKey=planKey taskId=taskId /]
[@tcc.invalidTaskPlugin  showDeleteButton deleteUrl/]
