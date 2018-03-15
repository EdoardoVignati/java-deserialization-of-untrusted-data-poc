[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByBuildNumberChart" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.charts.ViewCombinedByBuildNumberChart" --]
${combinedByBuildChart.imageMap}
<img id="combinedByBuildChart" src="${req.contextPath}/chart?filename=${combinedByBuildChart.location}"
     border=0 height="${combinedByBuildChart.height}" width="${combinedByBuildChart.width}" usemap="#${combinedByBuildChart.imageMapName}"/>
