[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.reports.ViewReport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.reports.ViewReport" --]
<html>
<head>
    [@ui.header pageKey='report.title' object='' title=true /]
    <meta name="topCrumb" content="reports" />
</head>

<body>
    <h1>Custom Reports and Statistics</h1>
    <p>Compare trends between different plans. You can choose the different reports and the plans you wish to compare in the form below.</p>
    <div class="reportParam">
    [@ww.form action='generateReport' submitLabelKey='global.buttons.submit' titleKey='report.input.title' method='get']

        [@ww.select labelKey='report.name' name='reportKey' list=availableReports listKey='completeKey' listValue='name'
                    optionDescription='description' toggle='true'
                    headerKey='' headerValue='Select...'/]

        [@ui.bambooSection dependsOn='reportKey' showOn='com.atlassian.bamboo.plugin.system.reports:labelUsageCount com.atlassian.bamboo.plugin.system.reports:labelUsageRatio com.atlassian.bamboo.plugin.system.reports:ratioOfFailureWithLabelUsage']
            [@ww.textfield labelKey='report.label' name='labelTarget' /]
        [/@ui.bambooSection]

        [@ww.select labelKey='report.builds'
                    name='buildIds'
                    list=availablePlans
                    listKey='id'
                    listValue='buildName'
                    groupBy='project.name'
                    multiple="true" ]
            [#if !numberOfProjects?? || (availablePlans.size() + numberOfProjects gt 20) ]
                [@ww.param name='size' value='20'/]
            [#else]
                [@ww.param name='size' value='${availablePlans.size() + numberOfProjects}' /]
            [/#if]

        [/@ww.select]

        [@ww.select labelKey='report.group.by'
                    name='groupByPeriod'
                    list=availableGroupBy
                    listKey='key'
                    listValue='value']
                    [#if groupByPeriod == 'AUTO' && resolvedAutoPeriod??]
                        [@ww.param name='description']Report is grouped by ${availableGroupBy.get(resolvedAutoPeriod)}.[/@ww.param]
                    [/#if]
        [/@ww.select]

        [@ww.select labelKey='report.date.filter' name='dateFilter'
            headerKey='None' headerValue='All'
            footerKey='RANGE' footerValue='Select Range...'
            list=availableDateFilter
            listKey='key' listValue='value'
            toggle='true'/]

        [@ui.bambooSection dependsOn='dateFilter' showOn='RANGE']
            [@ww.textfield labelKey='report.from' name='dateFrom' /]
            [@ww.textfield labelKey='report.to' name='dateTo' /]
        [/@ui.bambooSection]

        [/@ww.form]
    </div>


    [#if dataset?has_content]
        <div class="reportDisplay">

        [#if selectedReport??]
            <h2>${selectedReport.name}</h2>
            [#if selectedReport.description?has_content]
                <p>${selectedReport.description}</p>
            [/#if]
        [/#if]
        [@dj.tabContainer headings=[action.getText('report.tab.chart.title'),action.getText('report.tab.data.title'),'Builds'] selectedTab='${selectedTab!}']
            [@dj.contentPane labelKey='report.tab.chart.title']
                [@ww.action name="viewReportChart" namespace="/charts" executeResult="true" /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='report.tab.data.title' ]
                <table class="aui">
                    <thead>
                        <tr>
                            <th>[@ww.text name="report.timeperiod.title"/]</th>
                            [#assign numSeries=dataset.seriesCount - 1/]
                            [#list 0..numSeries as seriesIndex]
                                [#assign seriesKey=dataset.seriesKey(seriesIndex) /]
                                <th>${action.getBuildNameFromKey(seriesKey)}</th>
                            [/#list]
                        </tr>
                    </thead>
                    <tbody>
                        [#assign numItems=dataset.getItemCount() - 1/]
                        [#list 0..numItems as itemIndex]
                            <tr>
                                <td>${dataset.timePeriod(itemIndex)}</td>
                                [#list 0..numSeries as seriesIndex]
                                    [#assign value=action.getYValue(seriesIndex, itemIndex)!/]
                                    <td>[#if value?has_content]${value?string('#.##')}[#else]-[/#if]</td>
                                [/#list]
                            </tr>
                        [/#list]
                    </tbody>
                </table>
            [/@dj.contentPane]
            [@dj.contentPane labelKey='Builds']
                [@ww.action name="viewBuildResultsTable" namespace="/build" sort="true" executeResult="true" /]
            [/@dj.contentPane]
        [/@dj.tabContainer]
        </div>
    [/#if]
</body>
</html>

[#--[#if agentAwareReport][/#if]--]
[#--<script type="text/javascript">--]
[#--<!----]
    [#--function setDescription${parameters.id?default('')?html}()--]
    [#--{--]
        [#--var selectE = document.getElementById('${parameters.id?default('')?html}');--]
        [#--var selectDescription = document.getElementById('${parameters.id?default('')?html}Desc');--]
        [#--selectDescription.innerHTML = selectE.options[selectE.selectedIndex].title;--]
    [#--}--]

    [#--AJS.$(function()--]
    [#--{--]
        [#--setDescription${parameters.id?default('')?html}();--]
        [#--AJS.$("#${parameters.id?default('')?html}").change(setDescription${parameters.id?default('')?html})--]
    [#--});--]
[#--//-->--]
[#--</script>--]
