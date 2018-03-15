[#-- @ftlvariable name="" type="com.atlassian.bamboo.plan.PlanStatusHistoryAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plan.PlanStatusHistoryAction" --]

[#assign returnUrl = (navigationContext.getCurrentUrl())!currentUrl/]
[#assign hasPreviousBuildResult = buildNumber?? && (action.findLastBuildResultBefore(plan.key, buildNumber))?? /]
[#assign firstBuildNumber = plan.firstBuildNumber!/]
[#-- This is kind of hacky but plan.firstBuildNumber gets cached and not updated until a server restart --]
[#if buildNumber?? && !hasPreviousBuildResult]
    [#assign firstBuildNumber = buildNumber/]
[/#if]
[#assign lastBuildNumber = plan.lastBuildNumber!/]
[#assign keyToNavigate = (jobKey!planKey).toString()/]
${soy.render("bamboo.widget.planStatusHistory.container", {
    "id": "plan-status-history",
    "builds": navigableBuilds,
    "bootstrap": jsonObject.get(navigableSummariesKey).toString(),
    "currentBuildNumber": buildNumber!,
    "firstBuildNumber": firstBuildNumber,
    "lastBuildNumber": lastBuildNumber,
    "planKey": planKey.toString()?js_string,
    "keyToNavigate": keyToNavigate?js_string,
    "returnUrl": returnUrl?url
})}