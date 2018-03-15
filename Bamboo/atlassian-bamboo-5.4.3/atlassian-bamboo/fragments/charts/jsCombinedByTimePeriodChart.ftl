[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByTimePeriodChart" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByTimePeriodChart" --]
[#if combinedByTimeChart??]
${combinedByTimeChart.imageMap}
<img id="combinedByTimeChart" src="${req.contextPath}/chart?filename=${combinedByTimeChart.location}" border="0" height="${combinedByTimeChart.height}" width="${combinedByTimeChart.width}" usemap="${combinedByTimeChart.imageMapName}"/>
[/#if]
