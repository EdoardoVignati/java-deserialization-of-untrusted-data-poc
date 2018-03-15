[#include "notificationCommonsHtmlIm.ftl"]
Error detected for [@buildNotificationPlanOrResultLink baseUrl build "plan_failed_16.png" error.buildNumber!""/]
<hr>
[#if error.context?has_content]
${htmlUtils.getTextAsHtml(error.context)}
[/#if]
[#if error.throwableDetails?has_content]
   [#if error.throwableDetails.name?has_content]
${error.throwableDetails.name}[#if error.throwableDetails.message?has_content]: [/#if][#rt]
   [/#if]
   [#if error.throwableDetails.message?has_content]
${htmlUtils.getTextAsHtml(error.throwableDetails.message)}[#lt]
   [/#if]
[/#if]
<br>
<a href='${baseUrl}/browse/${error.parentPlanKey}#buildPlanSummaryErrorLog'>Error Log</a>
