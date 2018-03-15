[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.schedule.ConfigureElasticInstanceSchedules" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.schedule.ConfigureElasticInstanceSchedules" --]
<html>
<head>
    <title>[@ww.text name='elastic.schedule.list.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewElasticInstanceSchedules">
</head>
<body>

<div class="toolbar">
    <div class="aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="addElasticInstanceSchedule" class="toolbar-trigger" href="${req.contextPath}/admin/elastic/schedule/addElasticInstanceSchedule.action">[@ww.text name='elastic.schedule.add.title' /]</a>
            </li>
            [#if elasticInstanceSchedules?has_content]
                <li class="toolbar-item">
                    <a id="enableAllElasticInstanceSchedules" class="mutative toolbar-trigger" href="${req.contextPath}/admin/elastic/schedule/enableAllElasticInstanceSchedules.action">[@ww.text name='global.buttons.enable.all' /]</a>
                </li>
                <li class="toolbar-item">
                    <a id="disableAllElasticInstanceSchedules" class="mutative toolbar-trigger" href="${req.contextPath}/admin/elastic/schedule/disableAllElasticInstanceSchedules.action">[@ww.text name='global.buttons.disable.all' /]</a>
                </li>
            [/#if]
        </ul>
    </div>
</div>
[@ui.header pageKey='elastic.schedule.list.title' descriptionKey='elastic.schedule.list.description' /]

[@ww.actionerror /]

[#if elasticInstanceSchedules?has_content]
   <table id="elasticInstanceSchedules" class="aui">
        <thead><tr>
            <th>[@ww.text name='elastic.schedule.nextFireTime' /]</th>
            <th>[@ww.text name='elastic.schedule.cronExpression' ][@ww.param]${req.contextPath}[/@ww.param][/@ww.text]</th>
            <th>[@ww.text name='elastic.schedule.elasticImageConfig' /]</th>
            <th>[@ww.text name='elastic.schedule.targetActiveInstances' /]</th>
            <th class="operations">[@ww.text name='global.heading.operations' /]</th>
        </tr></thead>
        <tbody>
            [#foreach elasticInstanceSchedule in elasticInstanceSchedules]
                <tr class="[#rt]
                [#if elasticInstanceSchedule.id == elasticInstanceScheduleId!(0)]selectedRow[/#if][#t]
                [#if !elasticInstanceSchedule.enabled] disabled[/#if][#t]
                    ">[#lt]

                    <td>
                        [#if elasticInstanceSchedule.enabled]
                            [#if elasticInstanceSchedule.runOnStartup]
                                [@ww.text name='elastic.schedule.whenOption.STARTUP' /]
                            [#else]
                                [#assign nextFireTime = (action.getTrigger(elasticInstanceSchedule).nextFireTime)! /]
                                [#if nextFireTime?has_content]
                                    ${(nextFireTime?datetime)}
                                    <span class="small grey">(in ${durationUtils.getRelativeToDate(nextFireTime.time)})</span>
                                [#else]
                                    [@ww.text name='elastic.schedule.noFireTime' /]
                                [/#if]
                            [/#if]
                        [#else]
                            [@ww.text name='elastic.schedule.noFireTime' /]
                        
                        [/#if]
                    </td>
                    <td>
                        [#if !elasticInstanceSchedule.runOnStartup]
                            ${action.getPrettyCronExpression(elasticInstanceSchedule.cronExpression)}
                        [/#if]
                    </td>

                    [#if !elasticInstanceSchedule.allElasticConfigurations]

                    <td>
                        [#assign elasticImageConfiguration = elasticInstanceSchedule.elasticImageConfiguration! /]
                        [#if elasticImageConfiguration?has_content]
                             <a id="viewImage${elasticImageConfiguration.id}"
                                 href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${elasticImageConfiguration.id}"
                                 title="[@ww.text name='elastic.schedule.elasticImageConfig' /]">${elasticImageConfiguration.configurationName?html}</a>
                             [#if elasticImageConfiguration.isDisabled()]
                                <span class="grey"> [@ww.text name="elastic.image.configuration.disabled" /]</span>
                             [/#if]
                        [/#if]
                    </td>
                    <td>
                        [@ww.text name='elastic.schedule.adjust.type.${elasticInstanceSchedule.activeInstanceAdjustmentType}.view' ]
                            [@ww.param]${elasticInstanceSchedule.targetActiveInstances}[/@ww.param]
                        [/@ww.text]
                    </td>
                    [#else]
                        <td colspan="2">
                            [@ww.text name='elastic.schedule.whatOption.KILL_ALL' /]
                        </td>
                    [/#if]
                    <td class="operations">
                        [#--<a id="viewElasticInstanceSchedule${elasticInstanceSchedule.id}" --]
                           [#--href="${req.contextPath}/admin/elastic/schedule/viewElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}" --]
                           [#--title="[@ww.text name='elastic.schedule.view.title' /]">[@ww.text name='global.buttons.view' /]</a>--]
                        [#--| --]

                        <a id="editElasticInstanceSchedule${elasticInstanceSchedule.id}"
                           href="${req.contextPath}/admin/elastic/schedule/editElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}"
                           title="[@ww.text name='elastic.schedule.edit.title' /]">[@ww.text name='global.buttons.edit' /]</a>
                        |
                        [#if elasticInstanceSchedule.enabled]
                            <a id="disableElasticInstanceSchedule${elasticInstanceSchedule.id}"
                               class="mutative"
                               href="${req.contextPath}/admin/elastic/schedule/disableElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}"
                               title="[@ww.text name='elastic.schedule.disable.title' /]">[@ww.text name='global.buttons.disable' /]</a>
                            |
                        [#else]
                            [#if !elasticInstanceSchedule.enabled]
                            <a id="enableElasticInstanceSchedule${elasticInstanceSchedule.id}"
                               class="mutative"
                               href="${req.contextPath}/admin/elastic/schedule/enableElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}"
                               title="[@ww.text name='elastic.schedule.enable.title' /]">[@ww.text name='global.buttons.enable' /]</a>
                            |
                            [/#if]
                        [/#if]
                        <a id="copyElasticInstanceSchedule${elasticInstanceSchedule.id}"
                           href="${req.contextPath}/admin/elastic/schedule/copyElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}"
                           title="[@ww.text name='elastic.schedule.copy.title' /]">[@ww.text name='global.buttons.copy' /]</a>
                        |
                        <a id="deleteElasticInstanceSchedule${elasticInstanceSchedule.id}"
                           class="requireConfirmation mutative"
                           href="${req.contextPath}/admin/elastic/schedule/deleteElasticInstanceSchedule.action?elasticInstanceScheduleId=${elasticInstanceSchedule.id}"
                           title="[@ww.text name='elastic.schedule.delete.title' /]">[@ww.text name='global.buttons.delete' /]</a>
                    </td>
                </tr>
            [/#foreach]
        </tbody>
    </table>
[/#if]
</body>
</html>
