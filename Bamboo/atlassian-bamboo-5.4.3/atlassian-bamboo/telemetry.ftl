[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.ViewTelemetryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.ViewTelemetryAction" --]
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Status Summary Screen - [#if instanceName?has_content]${instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="-1"/>

    <meta name="decorator" content="none"/>

    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/>

    ${webResourceManager.requireResourcesForContext("atl.telemetry")}
    ${webResourceManager.requiredResources}
</head>
<body>
[@ui.renderWebPanels "wallboard.before"/]
<div id="wallboard">
    [#assign buildsToList= filteredBuilds]
    [#if buildsToList.size() > 0 && buildsToList.size() < 6]
        [#assign buildWidth = "100%"]
    [#elseif buildsToList.size() > 5 && buildsToList.size() < 9]
        [#assign buildWidth = "50%"]
    [#elseif buildsToList.size() > 8 && buildsToList.size() < 13]
        [#assign buildWidth = "33.33%"]
    [/#if]
    [#if buildsToList.size() < 1]
    <div class="no-builds">
        <h3>Bamboo has found no builds to display</h3>
        (this could be due to a filter or viewing permissions)
    </div>
    [#else]
        [#list buildsToList as build]
            [#if build.latestResultsSummary??]
            <div class="build"[#if buildWidth??] style="width: ${buildWidth};"[/#if]>
                <div class="result ${build.latestResultsSummary.buildState}">
                    <a href="${req.contextPath}/browse/${build.planKey}" class="plan-name">${build.buildName}</a>
                    <div class="build-details">
                        <div class="web-panels">
                            [#list ctx.getWebPanelsForPlan("telemetry.right", build.key) as webpanel]
                                ${webpanel}
                            [/#list]
                        </div>
                        [#if build.active]
                            <div id="${build.key}-indicator" class="indicator[#if build.executing] building[/#if]"></div>
                        [#elseif build.latestResultsSummary.testResultsSummary.quarantinedTestCaseCount > 0]
                            <div class="quarantine" title="buildResult.completedBuilds.quarantined">&#9763;</div>
                        [/#if]
                        <div class="project-name">[#if (build.master)??]${build.master.name}[#else]${build.project.name}[/#if]</div>
                        [#if build.latestResultsSummary.buildDate??]
                            [@ui.time datetime=build.latestResultsSummary.buildDate]${build.latestResultsSummary.relativeBuildDate!}[/@ui.time]
                        [/#if]
                    </div>
                    <div class="details-ext">
                        <div class="details-ext-content">
                            <table>
                                <tr>
                                    <th>Tests:</th>
                                    [#if build.latestResultsSummary.testResultsSummary.totalTestCaseCount > 0]
                                        <td>${build.latestResultsSummary.testSummary}</td>
                                    [#else]
                                        <td>[@ww.text name='buildResult.completedBuilds.noTests'/]</td>
                                    [/#if]
                                </tr>
                                <tr>
                                    <th>Duration:</th>
                                    <td>${durationUtils.getPrettyPrint(build.averageBuildDuration)}</td>
                                </tr>
                                <tr>
                                    <th>Changes:</th>
                                    [#if build.latestResultsSummary.getChangesListSummary() != ""]
                                        <td>${build.latestResultsSummary.getChangesListSummary()}</td>
                                    [#else]
                                        <td>No changes</td>
                                    [/#if]
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="reason">${build.latestResultsSummary.reasonSummary!}</div>
            </div>
            [/#if]
        [/#list]
    [/#if]
</div>
[@ui.renderWebPanels "wallboard.after"/]
[#if serverLifecycleState?string == "PAUSED"]
    [@wallboardMessage "serverstate.pausedMessage" "server-paused" /]
[#elseif serverLifecycleState?string == "PAUSING"]
    [@wallboardMessage "serverstate.pausingMessage" "server-paused" /]
[/#if]
</body>
</html>

[#macro wallboardMessage messageKey messageClass='']
    <div id="message-blanket"></div>
    <div id="message"[#if messageClass?has_content] class="${messageClass?html}"[/#if]>[@ww.text name=messageKey /]</div>
[/#macro]