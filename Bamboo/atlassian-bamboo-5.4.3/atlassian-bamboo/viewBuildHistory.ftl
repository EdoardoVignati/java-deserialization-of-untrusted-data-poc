[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuild" --]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
        
<html>
<head>
    <title>${immutableBuild.name}: Builds</title>
    <link rel="alternate" type="application/rss+xml" title="Bamboo RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${immutableBuild.key}${rssSuffix}" />
    <meta name="tab" content="results"/>
</head>

<body>
    [@ui.header pageKey='build.results.title' /]
    [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true" ]
        [@ww.param name="showAgent" value="true"/]
        [@ww.param name="sort" value="true"/]
        [@ww.param name="singlePlan" value="true"/]
    [/@ww.action]
    <ul>
        <li>Successful builds are <font color="green">green</font>, failed builds are <font color="red">red</font>.</li>
        <li>This plan has been built ${immutableBuild.lastBuildNumber} times.</li>
        [#if immutableBuild.averageBuildDuration??]
            <li>The average build time for recent builds is approximately ${durationUtils.getPrettyPrint(immutableBuild.averageBuildDuration)}</li>
        [/#if]

        <li>
            <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${immutableBuild.key}${rssSuffix}">[@ui.icon type="rss" text="Point your rss reader at this link to get the full ${immutableBuild.name} build feed" /]</a>
            Feed for all <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${immutableBuild.key}${rssSuffix}" title="Point your rss reader at this link to get the full ${immutableBuild.name} build feed">builds</a>
            or just the <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&buildKey=${immutableBuild.key}${rssSuffix}" title="Point your rss reader at this link to get just the failed ${immutableBuild.name} build feed">failed builds</a>.
        </li>
    </ul>
</body>
</html>
