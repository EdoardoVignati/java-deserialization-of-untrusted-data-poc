[#include "notificationCommonsText.ftl"]
[@notificationTitleText "${buildKey}-${buildNumber} may have hung."/]

[@ui.displayBuildHungDurationInfoText currentlyBuilding.elapsedTime, currentlyBuilding.averageDuration, currentlyBuilding.buildHangDetails /]
[#if buildAgent?has_content]Running on agent ${buildAgent.name}[/#if][#lt]

[@showLogUrl baseUrl buildKey /]

[@showCommits commits /]

[@showLogs lastLogs baseUrl buildKey /]

[@showEmailFooter /]
