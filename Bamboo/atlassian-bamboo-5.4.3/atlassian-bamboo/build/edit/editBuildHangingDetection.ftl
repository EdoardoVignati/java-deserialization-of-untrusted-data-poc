[@ui.bambooSection titleKey='buildMonitoring.hanging.plan.title']
    [@ww.checkbox labelKey='buildMonitoring.hanging.plan.enable' name='custom.buildHangingConfig.enabled' descriptionKey='buildMonitoring.hanging.plan.enable.description' toggle='true'/]
    [@ui.bambooSection dependsOn='custom.buildHangingConfig.enabled' showOn='true']
        <p>[@ww.text name='buildMonitoring.hanging.plan.description'/]</p>
        [@ww.textfield name='custom.buildHangingConfig.multiplier' labelKey='buildMonitoring.hanging.multiplier'/]
        [@ww.textfield name='custom.buildHangingConfig.minutesBetweenLogs' labelKey='buildMonitoring.hanging.logtime' /]
    [/@ui.bambooSection]
    [@ui.bambooSection dependsOn='custom.buildHangingConfig.enabled' showOn='true']
        <p>[@ww.text name='buildMonitoring.queuetimeout.plan.description'/]</p>
        [@ww.textfield name='custom.buildHangingConfig.minutesQueueTimeout' labelKey='buildMonitoring.hanging.queuetimeout' /]
    [/@ui.bambooSection]

[/@ui.bambooSection]