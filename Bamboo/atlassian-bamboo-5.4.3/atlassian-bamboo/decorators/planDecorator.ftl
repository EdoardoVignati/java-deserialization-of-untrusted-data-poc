[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedPlan" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu]
[#import "/fragments/breadCrumbs.ftl" as bc]

[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/showAdminErrors.ftl"]
[#if (navigationContext.currentObject)?? && !navigationContext.currentObject.isResult()]
    [#assign decoratedPlan = navigationContext.currentObject/]
    [#assign metaTabData = page.properties["meta.tab"]! /]

    [#assign headerImageContent]
        [@bc.showProjectIcon decoratedPlan /]
    [/#assign]
    [#assign headerMainContent]
        [@bc.showBreadcrumbs decoratedPlan /]
    [/#assign]

    [#assign headerActionsContent]
        [#if immutablePlan??]
            [#if fn.isChain(decoratedPlan)]
                [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(immutablePlan)/]
                [#assign planLevelItems]
                    [#if !immutablePlan.suspendedFromBuilding]
                        [@menu.displayPlanSuspendLink immutablePlan planI18nPrefix+'.disable'/]
                    [#else]
                        [@menu.displayPlanResumeLink immutablePlan planI18nPrefix+'.enable'/]
                    [/#if]
                    [#if user??]
                        [@menu.displayFavouriteToggler plan=immutablePlan/]
                    [/#if]
                    [@menu.displayConfigureLink immutablePlan planI18nPrefix+'.edit'/]
                    [@menu.displayAddPlanLabelLink immutablePlan planI18nPrefix+'.add.label' /]
                    [@menu.displayPlanWallboardLink immutablePlan /]
                [/#assign]
                [#assign buildLevelItems]
                    [@menu.displayPlanStopLink immutablePlan planI18nPrefix+'.stop.all'/]
                [/#assign]
                [#assign pluginItems]
                    [@menu.displayWebItems plan=immutablePlan location="chain.actions" /]
                [/#assign]
            [#else]
                [#assign jobLevelItems]
                    [#if immutablePlan.suspendedFromBuilding]
                        [@menu.displayPlanResumeLink immutablePlan 'job.enable'/]
                    [#else]
                        [@menu.displayPlanSuspendLink immutablePlan 'job.disable'/]
                    [/#if]
                    [#if user??]
                        [@menu.displayFavouriteToggler plan=immutablePlan /]
                    [/#if]
                    [@menu.displayConfigureLink immutablePlan 'job.edit'/]
                [/#assign]
                [#assign pluginItems]
                    [@menu.displayWebItems plan=immutablePlan location="job.actions" /]
                [/#assign]
            [/#if]

            [#assign menuButtons]
                [@menu.displayChainRunMenu plan=((immutablePlan.parent)!immutablePlan)/]
                [@menu.displayHeaderActions buildItems=buildLevelItems! jobItems=jobLevelItems! planItems=planLevelItems! pluginItems=pluginItems! /]
            [/#assign]

            ${soy.render('aui.buttons.buttons', {
                'extraClasses': 'aui-dropdown2-trigger-group',
                'content': menuButtons}
            )}

            [#if immutablePlan??]
                ${soy.render("bamboo.deployments:linked-deployment-shortcut", 'feature.plan.linkedDeployment.linkedDeploymentHeaderDropdown', {
                    'immutablePlan': ((immutablePlan.parent)!immutablePlan),
                    'hasLinkedDeployments': action.hasLinkedDeployments(((immutablePlan.parent)!immutablePlan).planKey)
                })}
            [/#if]

        [/#if]
    [/#assign]

    [#assign headerExtraContent]
        [#if decoratedPlan??]
            [#if decoratedPlan.parent?has_content]
                [#if decoratedPlan.parent.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${decoratedPlan.parent.linkedJiraIssue?html}" data-remote-jira-link-required="${decoratedPlan.parent.remoteJiraLinkRequired?string}"></div>
                [#elseif decoratedPlan.parent.description?has_content]
                    <div class="plan-description" title="${decoratedPlan.parent.description?html}">${decoratedPlan.parent.description?html}</div>
                [/#if]
            [#else]
                [#if decoratedPlan.linkedJiraIssue?has_content]
                    <div class="plan-description" data-jira-issue-key="${decoratedPlan.linkedJiraIssue?html}" data-remote-jira-link-required="${decoratedPlan.remoteJiraLinkRequired?string}"></div>
                [#elseif decoratedPlan.description?has_content]
                    <div class="plan-description" title="${decoratedPlan.description?html}">${decoratedPlan.description?html}</div>
                [/#if]
            [/#if]
            [#import "/fragments/labels/labels.ftl" as lb /]
            [@lb.showLabelEditorForPlan plan=decoratedPlan /]
        [/#if]
    [/#assign]

    [#assign mainContent]
        ${body}
        <a id="editPlanLink" class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${decoratedPlan.key}" accesskey="E">Edit Plan</a>
        <script type="text/javascript">
            AJS.whenIType("e").followLink("#editPlanLink");
            BAMBOO.currentPlan = {
                key: '${decoratedPlan.key}',
                name: '${decoratedPlan.displayName?js_string}'
            };
            [#if decoratedPlan?? && ((decoratedPlan.parent)!decoratedPlan).linkedJiraIssue?has_content]
                BAMBOO.PLAN.LinkedJiraIssueDescription({
                    planKey: '${((decoratedPlan.parent)!decoratedPlan).key}'
                });
            [/#if]
        </script>
    [/#assign]

    ${soy.render("bamboo.layout.plan", {
        "headerImageContent": headerImageContent,
        "headerMainContent": headerMainContent,
        "headerActionsContent": headerActionsContent,
        "headerExtraContent": headerExtraContent,
        "content": mainContent,
        "planStatusHistory": chains.getPlanStatusHistoryDetails(),
        "navItems": menu.getNavItems(metaTabData, fn.isChain(decoratedPlan)?string("chain.subMenu", "build.subMenu"), fn.isChain(decoratedPlan)?string("build.subMenu", ""))
    })}
[#else]
    <section id="content" role="main">
        <div class="aui-panel">
            [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)"/]
            ${body}
        </div>
    </section>
[/#if]
[#include "/fragments/decorator/footer.ftl"]
