[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    [#assign i18nPrefix = fn.getPlanI18nKeyPrefix(immutablePlan)/]
    [@ui.header pageKey=i18nPrefix+'.summary.title.long' object=immutablePlan.name title=true /]
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${immutablePlan.name}&rdquo; all builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${immutablePlan.key}${rssSuffix}" />
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${immutablePlan.name}&rdquo; failed builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${immutablePlan.key}${rssSuffix}" />
    <meta name="tab" content="summary"/>
</head>
<body>
[#include "/fragments/plan/displayPlanSummary.ftl" /]
</body>
</html>
