[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]
[#assign reportTitle = ''/]
[#if dataset?has_content &&  reportKey?? && availableReports.containsKey(reportKey)]
    [#assign reportTitle = availableReports.get(reportKey)/]
[/#if]
<html>
<head>
    [@ui.header pageKey='author.report' object=reportTitle title=true /]
    <meta name="decorator" content="bamboo.authors"/>
    <meta name="tab" content="report" />
</head>
<body>

[@ui.header pageKey='author.report' descriptionKey='report.author.description' /]
<div class="reportParam">
    [#if !authors?has_content]
        [@ui.messageBox type="warning" titleKey="report.author.warning" /]
    [#else]
        [@ww.form action='generateAuthorReport' submitLabelKey='global.buttons.submit' titleKey='report.input.title' method='get']
        [@ww.select labelKey='report.name' name='reportKey' list=availableReports listKey='key' listValue='value' optionDescription='description'
                    headerKey='' headerValue='Select...'/]
        [@ww.select labelKey='author.statistics.list.title'
                    name='selectedAuthorNames'
                    list=authors
                    listKey='name'
                    listValue='name'
                    multiple="true" ]
        [/@ww.select]
        [@ww.select labelKey='report.group.by'
                    name='groupByPeriod'
                    list=availableGroupBy
                    listKey='key'
                    listValue='value']
                    [#if groupByPeriod == 'AUTO' && resolvedAutoPeriod?exists]
                        [@ww.param name='description']Report is grouped by ${availableGroupBy.get(resolvedAutoPeriod)}.[/@ww.param]
                    [/#if]
        [/@ww.select]
        [/@ww.form]
    [/#if]
</div>


[#if dataset?has_content]
    <div class="reportDisplay">

    [#if reportTitle?has_content]
        <h2>${reportTitle?html}</h2>
    [/#if]
    [@dj.tabContainer tabViewId="reportContents" headings=[action.getText('report.tab.chart.title'),action.getText('report.tab.data.title')] selectedTab=selectedTab!]
        [@dj.contentPane labelKey='report.tab.chart.title']
            [@ww.action name="viewAuthorChart" namespace="/charts" executeResult="true" /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='report.tab.data.title']
            [#assign numSeries=dataset.seriesCount - 1/]
            [#if numSeries gt -1]
                <table class="aui">
                    <thead>
                        <tr>
                            <th></th>
                            [#list 0..numSeries as seriesIndex]
                                [#assign seriesKey=dataset.seriesKey(seriesIndex) /]
                                <th>${seriesKey}</th>
                            [/#list]
                        </tr>
                    </thead>
                    <tbody>
                        [#assign numItems=dataset.getItemCount() - 1/]
                        [#list 0..numItems as itemIndex]
                            <tr>
                                <th>${dataset.timePeriod(itemIndex)}</th>
                                [#list 0..numSeries as seriesIndex]
                                    <td>
                                        [#assign value=action.getYValue(seriesIndex, itemIndex)!/]
                                        [#if value?has_content]${value?string('#.##')}[#else]-[/#if]
                                    </td>
                                [/#list]
                            </tr>
                        [/#list]
                    </tbody>
                </table>
            [/#if]
        [/@dj.contentPane]
    [/@dj.tabContainer]
    </div>
[/#if]

</body>
</html>