[#include "notificationCommonsText.ftl"]

[@notificationTitleText "Build queue timeout (${timeout} minutes) has been exceeded for ${buildKey}-${buildNumber}."/]

[@showLogUrl baseUrl buildKey /]

[@showCommits commits /]

[@showEmailFooter /]

