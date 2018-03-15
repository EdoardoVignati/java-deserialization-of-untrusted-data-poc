[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.gadgets.ViewGadgetUrls" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.gadgets.ViewGadgetUrls" --]
<html>
<head>
    <title>[@ww.text name='gadgetUrls.heading' /]</title>
</head>

<body>

    <h1>[@ww.text name='gadgetUrls.heading' /]</h1>
    <p>[@ww.text name='gadgetUrls.description' /]</p>

    [#macro gadgetSection gadgetKey imageLocation]
        <h2>[@ww.text name='gadgetUrls.${gadgetKey}.heading' /]</h2>
        <img class='gadgetScreenshot' src="[@cp.getStaticResourcePrefix /]${imageLocation}">
        <div class='gadgetText'>
        [@ww.text name='gadgetUrls.${gadgetKey}.description' /]<br/>
        [@ww.text name='gadgetUrls.${gadgetKey}.url']
            [@ww.param]${baseUrl}[/@ww.param]
        [/@ww.text]
        </div>
        [@ui.clear/]
    [/#macro]

    [@gadgetSection gadgetKey='bambooCharts' imageLocation='/download/resources/com.atlassian.bamboo.gadgets:gadgets.charts/chartsThumb.png' /]
    [@gadgetSection gadgetKey='bambooPlans' imageLocation='/download/resources/com.atlassian.bamboo.gadgets:gadgets.planStatus/planStatusThumb.png' /]
    [@gadgetSection gadgetKey='planSummaryChart' imageLocation='/download/resources/com.atlassian.bamboo.gadgets:gadgets.charts/planSummaryThumb.png' /]
    [@gadgetSection gadgetKey='cloverCoverage' imageLocation='/download/resources/com.atlassian.bamboo.gadgets:gadgets.cloverCoverage/cloverCoverageThumb.png' /]

</body>
</html>