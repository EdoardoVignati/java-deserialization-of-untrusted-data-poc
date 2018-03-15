[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/decorator/decorators.ftl" as decorators/]
[#import "/lib/menus.ftl" as menu/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "atl.dashboard"] activeNavKey="dashboard" /]

[#include "/fragments/showAdminErrors.ftl"]

[#assign headerActionsButtons]
    [#assign wallboardTriggerText][@ww.text name="dashboard.wallboard"/][/#assign]
    [@ui.standardMenu triggerText=wallboardTriggerText id="wallBoardDropdown" icon="wallboard"]
        [@ui.displayLink titleKey="dashboard.wallboard.all" href="${req.contextPath}/telemetry.action" inList=true /]
        [#if user??]
            [@ui.displayLink titleKey="dashboard.wallboard.favourite" href="${req.contextPath}/telemetry.action?filter=favourites" inList=true /]
            [@ui.displayLink id='filteredWallboardLink' titleKey="dashboard.wallboard.filter" href="${req.contextPath}/telemetry.action?filter=dashboard" inList=true /]
        [/#if]
    [/@ui.standardMenu]
[/#assign]

[#assign footerContent]
    [#if user??]
        [#assign rssSuffix="&amp;os_authType=basic" /]
    [#else]
        [#assign rssSuffix="" /]
    [/#if]
    <p>
        <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}">[@ui.icon type="rss" text="Point your rss reader at this link"/]</a>
        [@ww.text name="dashboard.rss"]
            [@ww.param]allBuildsRssFeed[/@ww.param]
            [@ww.param]${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}[/@ww.param]
            [@ww.param]allFailedBuildsRssFeed[/@ww.param]
            [@ww.param]${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed${rssSuffix}[/@ww.param]
        [/@ww.text]
    </p>
[/#assign]

${soy.render("bamboo.layout.dashboard", {
    "instanceName": instanceName?html,
    "headerActionsButtons": headerActionsButtons,
    "pageFooterContent": footerContent,
    "content": body
})}
[#include "/fragments/decorator/footer.ftl"]