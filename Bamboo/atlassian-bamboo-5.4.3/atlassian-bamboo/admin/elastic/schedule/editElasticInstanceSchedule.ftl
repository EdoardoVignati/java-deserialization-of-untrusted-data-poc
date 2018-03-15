[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.schedule.ConfigureElasticInstanceSchedule" --]
[#if elasticInstanceScheduleId > 0]
    [#assign mode = "edit" /]
[#else]
    [#assign mode = "add" /]
[/#if]
<html>
<head>
    <title>[@ww.text name='elastic.schedule.${mode}.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewElasticInstanceSchedules">
</head>

<body>
    <h1>[@ww.text name='elastic.schedule.${mode}.title' /]</h1>

    <p>[@ww.text name='elastic.schedule.${mode}.description' /]</p>

    [@ww.form
              action='saveElasticInstanceSchedule'
              namespace='/admin/elastic/schedule'
              titleKey='elastic.schedule.${mode}.details'
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/elastic/schedule/viewElasticInstanceSchedules.action' ]

        [#if mode == "edit"]
            [@ww.hidden name='elasticInstanceScheduleId' /]
        [/#if]

        [@ww.checkbox name='enabled' labelKey="global.buttons.enabled" /]


        [@ww.radio labelKey='elastic.schedule.whenOption' name='whenOption'
                   listValue='name()' i18nPrefixForValue='elastic.schedule.whenOption'
                   toggle='true'
                   list=whenOptions ]
        [/@ww.radio]

        [@ui.bambooSection dependsOn='whenOption' showOn='CRON']
            [@dj.cronBuilder "cronExpression"/]
        [/@ui.bambooSection]

        [@ww.radio labelKey='elastic.schedule.whatOption' name='whatOption'
                   listValue='name()' i18nPrefixForValue='elastic.schedule.whatOption'
                   toggle='true'
                   list=whatOptions ]
        [/@ww.radio]

        [@ui.bambooSection dependsOn='whatOption' showOn='ADJUST']
            
            [@ww.select name='elasticImageConfigurationId' labelKey='elastic.schedule.elasticImageConfig' list=elasticImageConfigurations
                        listKey='id' listValue='configurationName'
                        optionDescription="configurationDescription" /]

            [#assign numInstances]
                [@ww.textfield name='targetActiveInstances' required="true" theme='inline' /]
            [/#assign]
            [@ww.select name='activeInstanceAdjustmentType'
                        labelKey='elastic.schedule.targetActiveInstances'
                        list=activeInstanceAdjustmentTypes
                        listKey='name()'
                        i18nPrefixForValue='elastic.schedule.adjust.type'
                        extraUtility=numInstances
            /]
        [/@ui.bambooSection]

    [/@ww.form]
</body>
</html>
