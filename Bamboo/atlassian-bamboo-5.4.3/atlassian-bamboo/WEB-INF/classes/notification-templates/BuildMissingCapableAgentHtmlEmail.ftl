[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildKey" type="java.lang.String" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#include "notificationCommonsHtml.ftl"]
[#assign customStatusMessage]has been queued, but there's no agent capable of building it[/#assign]

[@templateOuter baseUrl=baseUrl statusMessage=customStatusMessage]

    [@showCommitsNoBuildResult commits baseUrl buildKey /]

    [@showActions]
        [@addAction name="View Online" url="${baseUrl}/browse/${buildKey}/log" first=true /]
        [@addMutativeAction name="Stop Build"  url="${baseUrl}/build/admin/stopPlan.action?planKey=${buildKey}" /]
    [/@showActions]

[/@templateOuter]