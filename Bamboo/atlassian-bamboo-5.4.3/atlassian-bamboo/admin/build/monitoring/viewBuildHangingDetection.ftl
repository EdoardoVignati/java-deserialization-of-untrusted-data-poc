[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
<html>
<head>
    <title>[@ww.text name='buildMonitoring.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
<h1>[@ww.text name='buildMonitoring.title' /]</h1>

<h3>[@ww.text name='buildMonitoring.hanging.title' /]</h3>
[@ww.text name='buildMonitoring.hanging.description' /]

<h3>[@ww.text name='buildMonitoring.queuetimeout.title' /]</h3>
[@ww.text name='buildMonitoring.queuetimeout.description' /]

[#if buildHangingConfig?exists && !buildHangingConfig.disabled]
    [@ui.bambooPanel titleKey='buildMonitoring.hanging.form.title']
        [@ww.label labelKey='buildMonitoring.hanging.multiplier' value='${buildHangingConfig.multiplier}' /]
        [@ww.label labelKey='buildMonitoring.hanging.logtime' value='${buildHangingConfig.minutesBetweenLogs}'/]
        [@ww.label labelKey='buildMonitoring.hanging.queuetimeout' value='${buildHangingConfig.minutesBeforeQueueTimeout}'/]
    [/@ui.bambooPanel]
    [@ww.form action='buildHangingDetection!edit.action' submitLabelKey='global.buttons.edit' cssClass='top-label']
        [@ww.param name='buttons']
            [@cp.displayLinkButton buttonId="disableButton" mutative=true buttonLabel="global.buttons.disable" buttonUrl="${req.contextPath}/admin/buildHangingDetection!delete.action" /]
        [/@ww.param]
    [/@ww.form]
[#else]
    [@ui.bambooPanel titleKey='buildMonitoring.hanging.form.title' descriptionKey='buildMonitoring.disabled' /]
    [@ww.form action='buildHangingDetection!add.action' submitLabelKey='global.buttons.enable' cssClass='top-label' /]
[/#if]
</body>
</html>
