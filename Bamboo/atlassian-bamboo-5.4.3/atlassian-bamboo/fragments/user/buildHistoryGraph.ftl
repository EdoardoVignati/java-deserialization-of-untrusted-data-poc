[#if action.chart?has_content]
<div class="build-graph">
${action.chart.imageMap}
    <img id="chart" src="${req.contextPath}/chart?filename=${action.chart.location}" border="0" height="${action.chart.height}" width="${action.chart.width}" usemap="${action.chart.imageMapName}"/>
    <span>Build History</span>
</div>
[/#if]
