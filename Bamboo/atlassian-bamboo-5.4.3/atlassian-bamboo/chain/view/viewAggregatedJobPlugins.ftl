[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewAggregatedJobPlugins" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewAggregatedJobPlugins" --]
<html>
<head>
    [@ui.header pageKey=pluginName object=immutablePlan.key title=true /]
    <meta name="tab" content="${pluginTabName}"/>
</head>

<body>
    [#if availableJobs?size > 1]
        [@ww.select id='jobKeySelector' name='jobKeySelector' list=availableJobs listKey='key' listValue='buildName' labelKey='job.common.title'/]
    [#else]
        [@ww.hidden id='jobKeySelector' name='jobKeySelector' value=availableJobs.get(0).key /]
    [/#if]

    <div id="jobPluginContent"></div>

    <script type="text/javascript">
        BAMBOO.AGGREGATE_PLUGIN_CONTENT.loadPluginContent.init({
            pluginUrl: '${pluginUrl}',
            jobKeySelector: '#jobKeySelector',
            contentSelector: "#jobPluginContent"
        });
    </script>
</body>
</html>




