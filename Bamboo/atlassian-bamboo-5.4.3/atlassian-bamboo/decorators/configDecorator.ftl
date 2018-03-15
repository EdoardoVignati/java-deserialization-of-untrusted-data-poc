[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedPlan" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu]
[#import "/fragments/breadCrumbs.ftl" as bc]
[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.configuration"] /]
[#include "/fragments/showAdminErrors.ftl"]
[#if (navigationContext.currentObject)?? && !navigationContext.currentObject.isResult()]
    [#assign decoratedPlan = navigationContext.currentObject/]
    [#assign metaTabData = page.properties["meta.tab"]! /]

    [#if fn.isBranch(decoratedPlan)]
        [#assign navLocation = decoratedPlan.key /]
        [#assign tabLocation = "branchConfiguration.subMenu" /]
    [#elseif fn.isJob(decoratedPlan)]
        [#assign navLocation = decoratedPlan.key/]
        [#assign tabLocation = "planConfiguration.subMenu"/]
    [#else]
        [#assign navLocation = "chain.general" /]
        [#assign tabLocation = "chainConfiguration.subMenu" /]
    [/#if]

    [#assign headerImageContent]
        [@bc.showProjectIcon decoratedPlan /]
    [/#assign]
    [#assign headerMainContent]
        [@bc.showBreadcrumbs decoratedPlan true /]
    [/#assign]

    [#assign headerActionsContent]
        [#if fn.isChain(immutablePlan)]
            [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(immutablePlan)/]
            [#assign planLevelItems]
                [#if !immutablePlan.suspendedFromBuilding]
                    [@menu.displayPlanSuspendLink immutablePlan planI18nPrefix+'.disable'/]
                [#else]
                    [@menu.displayPlanResumeLink immutablePlan planI18nPrefix+'.enable'/]
                [/#if]
                [@menu.displayAddPlanLabelLink immutablePlan planI18nPrefix+'.add.label' /]
                [#if fn.isBranch(immutablePlan)]
                    [@menu.displayPlanDeleteLink immutablePlan 'branch.delete' '/browse/${immutablePlan.master.key}/editConfig'/]
                [#else]
                    [@menu.displayPlanDeleteLink immutablePlan 'chain.delete' '/start.action'/]
                [/#if]
            [/#assign]
        [#elseif immutablePlan?? && immutablePlan.planType == 'JOB']
            [#assign jobLevelItems]
                [#if !immutablePlan.suspendedFromBuilding]
                    [@menu.displayPlanSuspendLink immutablePlan 'job.disable'/]
                [#else]
                    [@menu.displayPlanResumeLink immutablePlan 'job.enable'/]
                [/#if]
                [@menu.displayPlanDeleteLink immutablePlan 'job.delete' '/browse/${immutablePlan.parent.key}'/]
            [/#assign]
        [/#if]

        [#assign menuButtons]
            [@menu.displayChainRunMenu plan=((immutablePlan.parent)!immutablePlan)/]
            [@menu.displayHeaderActions jobItems=jobLevelItems! planItems=planLevelItems! /]
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

    [/#assign]

    [#assign headerExtraContent]
        [#if decoratedPlan??]
            [#assign planDescription]
                [#if fn.isBranch(decoratedPlan)]
                    ${(decoratedPlan.master.description)!""}
                [#elseif decoratedPlan.parent?has_content && fn.isBranch(decoratedPlan.parent)]
                    ${(decoratedPlan.parent.master.description)!""}
                [#elseif decoratedPlan.parent?has_content]
                    ${(decoratedPlan.parent.description)!""}
                [#elseif decoratedPlan.description?has_content]
                    ${(decoratedPlan.description)!""}
                [/#if]
            [/#assign]
            [#if planDescription?trim?has_content]
                <div class="plan-description" title="${planDescription?trim?html}">${planDescription?trim?html}</div>
            [/#if]
            [#import "/fragments/labels/labels.ftl" as lb /]
            [@lb.showLabelEditorForPlan plan=decoratedPlan /]
        [/#if]
    [/#assign]

    [#assign configSidebar]
        <div id="config-sidebar">
            [#if navigationContext.navObject.master?has_content]
                [#-- TODO: The ?replace() below is a hack to compensate for navigationContext.navObject.master not being a DecoratedPlan --]
                [@ww.url value=navigationContext.getChainUrl(navigationContext.navObject)?replace(navigationContext.navObject.key, navigationContext.navObject.master.planKey.toString()) id='planUrl'/]
            [#else]
                [@ww.url value=navigationContext.getChainUrl(navigationContext.navObject) id='planUrl'/]
            [/#if]
            <h2[#if navLocation="chain.general"] class="active"[/#if]><a href="${planUrl}">[@ww.text name="plan.title"/] Configuration</a></h2>
            [@chains.planNavigator navigationContext true/]
            [@chains.branchNavigator navigationContext/]
            [@ui.renderWebPanels 'plan.navigator' /]
        </div>
    [/#assign]

    [#assign mainContent]
        [@menu.displayTabbedContent location=tabLocation selectedTab=metaTabData historyXhrDisabled=true]
            [#if saved?? && saved]
                [@ui.messageBox type="success" titleKey="${tabLocation}.confirmsave" /]
            [/#if]
            ${body}
        [/@menu.displayTabbedContent]
        <script type="text/javascript">
            BAMBOO.currentPlan = {
                key: '${decoratedPlan.key}',
                name: '${decoratedPlan.displayName?js_string}'
            };
            BAMBOO.ConfigSidebar.init();
        </script>
    [/#assign]

    ${soy.render("bamboo.layout.plan", {
        "headerImageContent": headerImageContent,
        "headerMainContent": headerMainContent,
        "headerActionsContent": headerActionsContent!,
        "headerExtraContent": headerExtraContent,
        "pageItemContent": configSidebar,
        "pageItemClass": "plan-sidebar",
        "content": mainContent,
        "planStatusHistory": chains.getPlanStatusHistoryDetails()
    })}
[#else]
    <section id="content" role="main">
        <div class="aui-panel">
            [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
            ${body}
        </div>
    </section>
[/#if]
[#include "/fragments/decorator/footer.ftl"]
