[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="currentlyBuilding" type="com.atlassian.bamboo.v2.build.CurrentlyBuilding" --]
[#-- @ftlvariable name="buildKey" type="java.lang.String" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="timeout" type="int" --]
[#include "notificationCommonsHtml.ftl"]
[#assign customStatusMessage]has exceeded the build queue timeout (${timeout} minutes)[/#assign]

[@templateOuter baseUrl=baseUrl statusMessage=customStatusMessage]

    [@showCommitsNoBuildResult commits baseUrl buildKey /]

    [@showActions]
        [@addAction name="View Online" url="${baseUrl}/browse/${buildKey}/log" first=true /]
        [@addMutativeAction name="Stop Build"  url="${baseUrl}/build/admin/stopPlan.action?planKey=${buildKey}" /]
    [/@showActions]

[/@templateOuter]