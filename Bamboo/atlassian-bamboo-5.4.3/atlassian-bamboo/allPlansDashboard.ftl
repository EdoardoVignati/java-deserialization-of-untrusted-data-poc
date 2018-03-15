[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#assign curTab = "allPlansTab" /]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <meta name="decorator" content="atl.dashboard"/>
    <meta name="tab" content="${curTab?html}" />
</head>
<body>

<div id="dashboard-controls" class="aui-toolbar2">
    <div class="aui-toolbar-2-inner">
        <div class="aui-toolbar2-secondary">
            [#-- Filter --]
            [#if user??]
                [@ww.url id='editFilterByProjects' value='/ajax/configureFilter.action' returnUrl=currentUrl /]
                <div id="project-filter" class="aui-buttons">
                    <a id="toggle-project-filter" title="[@ww.text name='dashboard.filter.title'/]" [#rt]
                        [#if dashboardFilterConfigured || dashboardFilterEnabled]
                            class="aui-button toggleFilter" href="${req.contextPath}/ajax/toggleDashboardFilter.action?filterEnabled=${(!dashboardFilterEnabled)?string}&returnUrl=${currentUrl}"[#t]
                        [#else]
                            class="aui-button edit-project-filter" data-dialog-href="${editFilterByProjects}"[#t]
                        [/#if]
                        [#if dashboardFilterEnabled!false] aria-pressed="true"[/#if][#t]
                    >[#t]
                        [@ui.icon type="filter" showTitle=false /]&nbsp;[#if dashboardFilterEnabled!false][@ww.text name='dashboard.filter.button.on' /][#else][@ww.text name='dashboard.filter.button.off' /][/#if][#t]
                    </a>[#lt]
                    <a class="aui-button edit-project-filter" id="main-edit-project-filter" href="${editFilterByProjects}">[#rt]
                        [@ui.icon type="edit" useIconFont=true textKey="dashboard.filter.edit"/][#t]
                    </a>[#lt]
                </div>
            [/#if]
            [#-- END Filter --]
            <div class="aui-buttons">
                <button class="aui-button collapse-all">[@ui.icon type="collapse-all" textKey="global.buttons.collapse.all"/]</button>
                <button class="aui-button expand-all">[@ui.icon type="expand-all" textKey="global.buttons.expand.all"/]</button>
            </div>
        </div>
    </div>
</div>
[#include "/fragments/errorAjaxRefresh.ftl"]
[#compress] [#-- this cuts down template rendering by 30% (measured on localhost connection!) --]
    [@planList.displayWideBuildPlansList builds=plansForDashboard.items /]
[/#compress]
[#include "/fragments/showEc2Warning.ftl"]
[#include "/fragments/showSystemErrors.ftl"]
<script type="text/javascript">
    saveCookie("atlassian.bamboo.dashboard.tab.selected", "${curTab?js_string}");
</script>
</body>
</html>
