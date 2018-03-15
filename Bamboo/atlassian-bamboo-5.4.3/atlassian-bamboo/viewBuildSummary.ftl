[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuild" --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
[#import "/fragments/statistics/recentFailures.ftl" as recentFailures]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    [@ui.header pageKey='job.summary.title.long' object=immutableBuild.name title=true /]
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${immutableBuild.name}&rdquo; all builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${immutableBuild.key}${rssSuffix}" />
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${immutableBuild.name}&rdquo; failed builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${immutableBuild.key}${rssSuffix}" />
    <meta name="tab" content="summary"/>
</head>
<body>
[#include "/fragments/plan/displayPlanSummary.ftl" /]
</body>
</html>