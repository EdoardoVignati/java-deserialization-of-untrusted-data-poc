[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
<html>
<head>
	<title>[@ww.text name='buildMonitoring.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	[@ui.header pageKey='buildMonitoring.title' /]

    [@ww.text name='buildMonitoring.hanging.description' /]

    [@ww.form
        id='buildHangingDetectionForm'
        action='buildHangingDetection'
        cancelUri='/admin/buildHangingDetection!read.action'
        submitLabelKey='global.buttons.update'
        titleKey='buildMonitoring.hanging.form.title'
    ]

    [@ww.textfield name='buildHangingConfig.multiplier' labelKey='buildMonitoring.hanging.multiplier'/]
    [@ww.textfield name='buildHangingConfig.minutesBetweenLogs' labelKey='buildMonitoring.hanging.logtime' /]

    [@ww.text name='buildMonitoring.queuetimeout.description' /]
    
    [@ww.textfield name='buildHangingConfig.minutesBeforeQueueTimeout' labelKey='buildMonitoring.hanging.queuetimeout' /]

    [/@ww.form]
</body>
</html>
