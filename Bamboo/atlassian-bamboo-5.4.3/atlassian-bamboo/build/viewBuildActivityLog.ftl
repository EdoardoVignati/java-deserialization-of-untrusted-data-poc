[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]

[#import "/lib/chains.ftl" as cn]

<html>
<head>
    <title>Logs ${immutablePlan.name}</title>
     <meta name="tab" content="logs"/>
</head>

<body>
[@ui.header pageKey='build.logs.title' /]
[#--Plan Level Logs--]
[@dj.reloadPortlet id='activityLogWidget' url='${req.contextPath}/ajax/viewActivityLogSnippet.action?buildKey=${immutablePlan.key}&linesToDisplay=${linesToDisplay}' reloadEvery=secondsToRefresh loadScripts=false]
    [@ww.action name="viewActivityLogSnippet" namespace="/ajax" executeResult="true"]
    [/@ww.action]
[/@dj.reloadPortlet]

[@cn.logMenu action="${req.contextPath}/build/viewBuildActivityLog.action" plan=immutablePlan planType="Job" linesToDisplay=linesToDisplay secondsToRefresh=secondsToRefresh]
    <input name="buildKey" value="${immutablePlan.key}" type="hidden">
[/@cn.logMenu]
</body>
</html>