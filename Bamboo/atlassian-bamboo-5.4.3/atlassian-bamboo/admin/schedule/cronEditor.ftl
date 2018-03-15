[#if cronEditorBean??]
    [@ww.form action="returnCronExpression" namespace="/ajax" cssClass="cron-builder-form"]
        [@ww.radio name='cronEditorBean.mode'
        list='cronEditorBean.availableSchedules'
        i18nPrefixForValue='cronEditorBean.availableSchedules'
        showNewLine='false'
        toggle='true' /]

    <div class="cronEditorForm">

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfWeek']
            [@ww.checkboxlist name='cronEditorBean.checkBoxSpecifiedDaysOfWeek'
            i18nPrefixForValue='cronEditorBean.daysOfWeek'
            list=cronEditorBean.daysOfWeek matrix=true /]
        [/@ui.bambooSection]


        <div class="intervalForm">
            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daily daysOfWeek']
                [@ww.select labelKey='cronEditorBean.time.interval' name='cronEditorBean.incrementInMinutes' toggle='true'
                list='cronEditorBean.intervalOptions'
                i18nPrefixForValue='cronEditorBean.intervalOptions' cssClass='select' mediumField=true /]
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfMonth']
                <div class="timeForm">
                    [@ww.select name='cronEditorBean.monthHoursRunOnce' labelKey='cronEditorBean.time.at'
                    list='cronEditorBean.hourOptions' cssClass='select' shortField=true]
                        [@ww.param name='after']
                            :
                            [@ww.select name='cronEditorBean.monthMinutes' theme='inline'
                            list='cronEditorBean.minuteOptions' cssClass='select' shortField=true /]
                            [@ww.select name='cronEditorBean.monthHoursRunOnceMeridian' theme='inline'
                            list='cronEditorBean.meridianOptions' cssClass='select' shortField=true /]
                        [/@ww.param]
                    [/@ww.select]
                </div>
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daily daysOfWeek']
                <div class="timeForm">
                    [@ui.bambooSection dependsOn='cronEditorBean.incrementInMinutes' showOn='0']
                        [@ww.select name='cronEditorBean.dayHoursRunOnce' labelKey='cronEditorBean.time.at'
                        list='cronEditorBean.hourOptions' cssClass='select' shortField=true]
                            [@ww.param name='after']
                                :
                                [@ww.select name='cronEditorBean.dayMinutes' theme='inline'
                                list='cronEditorBean.minuteOptions' cssClass='select' shortField=true /]
                                [@ww.select name='cronEditorBean.dayHoursRunOnceMeridian' theme='inline'
                                list='cronEditorBean.meridianOptions' cssClass='select' shortField=true /]
                            [/@ww.param]
                        [/@ww.select]
                    [/@ui.bambooSection]
                    [@ui.bambooSection dependsOn='cronEditorBean.incrementInMinutes' showOn='180 120 60 30 15']
                        [@ww.select name='cronEditorBean.hoursFrom' labelKey='cronEditorBean.time.from'
                        list='cronEditorBean.hourOptions' cssClass='select' shortField=true]
                            [@ww.param name='after']
                                :
                                [@ww.textfield name='minutes' value='00' theme='inline' disabled='true' cssClass='text' shortField=true /]
                                [@ww.select name='cronEditorBean.hoursFromMeridian' theme='inline'
                                list='cronEditorBean.meridianOptions' cssClass='select' shortField=true /]
                            [/@ww.param]
                        [/@ww.select]
                        [@ww.select name='cronEditorBean.hoursTo' labelKey='cronEditorBean.time.to'
                        list='cronEditorBean.hourOptions' cssClass='select' shortField=true]
                            [@ww.param name='after']
                                :
                                [@ww.textfield name='minutes' value='00' theme='inline' disabled='true' cssClass='text' shortField=true /]
                                [@ww.select name='cronEditorBean.hoursToMeridian' theme='inline'
                                list='cronEditorBean.meridianOptions' cssClass='select' shortField=true /]
                            [/@ww.param]
                        [/@ww.select]
                    [/@ui.bambooSection]
                </div>
            [/@ui.bambooSection]
        </div>

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfMonth' cssClass='group monthForm']
            <legend><span>[@ww.text name='cronEditorBean.time.on' /]</span></legend>
            <div class="radio">
                [@ww.radio name='cronEditorBean.dayOfWeekOfMonth' template="radio.ftl" theme="simple"  fieldValue='false' cssClass='radio' /]
                [@ww.text name='cronEditorBean.daysOfMonth.the' /]
                [@ww.select name='cronEditorBean.dayOfMonth' theme='inline' list='cronEditorBean.dayOptions' i18nPrefixForValue='cronEditorBean.dayOptions' cssClass='select' shortField=true /]
                [@ww.text name='cronEditorBean.daysOfMonth.dayChoice' /]
            </div>
            <div class="radio">
                [@ww.radio name='cronEditorBean.dayOfWeekOfMonth' template="radio.ftl" theme="simple" fieldValue='true' cssClass='radio' /]
                [@ww.text name='cronEditorBean.daysOfMonth.the' /]
                [@ww.select name='cronEditorBean.dayInMonthOrdinal' theme='inline' list='cronEditorBean.weekOptions' i18nPrefixForValue='cronEditorBean.weekOptions' cssClass='select' shortField=true /]
                [@ww.select name='cronEditorBean.monthSpecifiedDaysOfWeek' theme='inline' list='cronEditorBean.daysOfWeek' i18nPrefixForValue='cronEditorBean.daysOfWeek' cssClass='select' mediumField=true /]
                [@ww.text name='cronEditorBean.daysOfMonth.weekChoice' /]
            </div>
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='advanced']
            <div class="cronStringForm">
                [@ww.textfield name='cronEditorBean.cronString' helpKey='cron.expression'/]
            </div>
        [/@ui.bambooSection]

    </div>
    [/@ww.form]
[#else]
    [@ui.messageBox type="error"][@ww.text name="cronEditorBean.error" /][/@ui.messageBox]
[/#if]