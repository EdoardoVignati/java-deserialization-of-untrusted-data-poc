[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByTimePeriodChart" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByTimePeriodChart" --]
[#if combinedByTimeChart??]
${combinedByTimeChart.imageMap}
<img id="combinedByTimeChart" src="${req.contextPath}/chart?filename=${combinedByTimeChart.location}" border="0" height="${combinedByTimeChart.height}" width="${combinedByTimeChart.width}" usemap="${combinedByTimeChart.imageMapName}"/>
[/#if]

[@ww.form action="setCookie" namespace="/ajax" cssClass="chartParamForm"]
    [@ww.hidden name="returnUrl" value='${currentUrl}'/]
    [@ww.hidden name="cookieValueFieldName" value="groupSuccessFailureChartBy" /]
    [@ww.hidden name="cookieKey" value="bamboo.build.groupby.type" /]
    Group by:
    [@ww.select name='groupSuccessFailureChartBy'
                list=['DAY', 'WEEK', 'MONTH', 'AUTO']
                theme='simple' submitOnChange='true' /]

    [#if groupSuccessFailureChartBy == 'AUTO']
        ${autoPeriod}
    [/#if]

[/@ww.form]
