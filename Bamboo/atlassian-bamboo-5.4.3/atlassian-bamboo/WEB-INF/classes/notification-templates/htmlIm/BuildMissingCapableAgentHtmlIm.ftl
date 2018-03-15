[#include "../notificationCommonsText.ftl"]
[#include "notificationCommonsHtmlIm.ftl"]

[@buildNotificationPlanOrResultLink baseUrl build "plan_canceled_16.png" buildNumber/] has been queued, but there's no agent capable of building it.
<br>
<a href='[@showLogUrl baseUrl="${baseUrl}" buildKey="${buildKey}"/]'>View Logs</a>

