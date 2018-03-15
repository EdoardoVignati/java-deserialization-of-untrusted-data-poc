[#include "../notificationCommonsText.ftl"]
[#include "notificationCommonsHtmlIm.ftl"]

[@buildNotificationPlanOrResultLink baseUrl build "plan_canceled_16.png" buildNumber/] may have hung.
[@ui.displayBuildHungDurationInfoText currentlyBuilding.elapsedTime, currentlyBuilding.averageDuration, currentlyBuilding.buildHangDetails /]
[#if buildAgent?has_content]Running on agent ${buildAgent.name}[/#if][#lt]
<br>
<a href='[@showLogUrl baseUrl="${baseUrl}" buildKey="${buildKey}"/]'>View Logs</a>
