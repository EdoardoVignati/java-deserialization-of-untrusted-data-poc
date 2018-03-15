[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#include "../notificationCommons.ftl"]
[#include "notificationCommonsHtmlIm.ftl" ]
[#assign authors = buildSummary.uniqueAuthors/]
[@buildNotificationResultLink baseUrl build buildSummary/] commented by [@getUserLink addedComment baseUrl gravatarUrl/]: <br>
${htmlUtils.getTextAsHtml(addedComment.getContent())}
