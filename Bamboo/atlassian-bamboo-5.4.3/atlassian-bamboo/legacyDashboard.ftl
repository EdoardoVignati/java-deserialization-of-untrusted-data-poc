[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]

<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <link rel="alternate" type="application/rss+xml" title="Bamboo RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}"/>
</head>
<body>

<h1 id="legacy-dashboard-title"">${instanceName?html}</h1>

[#import "/fragments/plan/displayBuildSummaries.ftl" as planList]
[@planList.displayBuildSummaries builds=plans /]

<p>Successful builds are <span class="successfulLabel">green</span>, failed builds are
    <span class="failedLabel">red</span>.</p>

<p>
    <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}" id="allBuildsRssFeed"><img src="${req.contextPath}/images/rss.gif" border="0" hspace="2" align="absmiddle" title="Point your rss reader at this link"></a>
    Feed for
    <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}">all builds</a> or
    <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed${rssSuffix}" id="allFailedBuildsRssFeed">all failed builds</a>.
</p>

<p>
    <a href="${req.contextPath}/telemetry.action"><img src="${req.contextPath}/images/display.png" border="0" hspace="2" align="absmiddle"></a>
    View plans in <a href="${req.contextPath}/telemetry.action">status summary screen</a>.
</p>
[@ww.action name="showBuilders" namespace="/ajax" executeResult="true"]
[@ww.param name='returnUrl']${currentUrl}[/@ww.param]
[/@ww.action]
[#include "/fragments/showSystemErrors.ftl"]

</body>
</html>
