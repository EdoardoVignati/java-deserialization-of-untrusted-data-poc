[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]

[#import "/lib/chains.ftl" as cn]

<html>
<head>
    [@ui.header object=immutablePlan.name page="Logs" title=true/]
     <meta name="tab" content="config"/>
</head>

<body>
    [@ww.url id='backToChainConfigurationUrl' value='/browse/${buildKey}/config' planKey=buildKey returnUrl=currentUrl /]

    <div class="toolbar">
        [@cp.displayLinkButton buttonId='backToPlanConfiguration' buttonLabel='chain.logs.back.to.configuration' buttonUrl=backToChainConfigurationUrl/]
    </div>
    [@ui.header pageKey='chain.logs.title'/]

    [#--Plan Level Logs--]
    [@dj.reloadPortlet id='activityLogWidget' url='${req.contextPath}/ajax/viewActivityLogSnippet.action?buildKey=${immutablePlan.key}&linesToDisplay=${linesToDisplay}' reloadEvery=secondsToRefresh loadScripts=false]
        [@ww.action name="viewActivityLogSnippet" namespace="/ajax" executeResult="true"]
        [/@ww.action]
    [/@dj.reloadPortlet]

    [@cn.logMenu action="${req.contextPath}/chain/viewChainActivityLog.action" plan=immutablePlan planType="Plan" linesToDisplay=linesToDisplay secondsToRefresh=secondsToRefresh]
        <input name="planKey" value="${immutablePlan.key}" type="hidden">
    [/@cn.logMenu]
</body>
</html>
