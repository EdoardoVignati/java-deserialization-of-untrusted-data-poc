[#include "notificationCommonsText.ftl"]

[@notificationTitleText "${buildKey}-${buildNumber} has been queued, but there's no agent capable of building it."/]

[@showLogUrl baseUrl buildKey /]

[@showCommits commits /]

[@showEmailFooter /]
