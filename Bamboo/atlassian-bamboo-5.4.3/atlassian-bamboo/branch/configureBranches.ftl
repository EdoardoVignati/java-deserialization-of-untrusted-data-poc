[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#import "../chain/edit/editChainConfigurationCommon.ftl" as eccc/]
[#import "/lib/chains.ftl" as cn]
[#import "branchesCommon.ftl" as bc/]

[#assign buttonsToolbar]
    [#if fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@ww.url id='createBranchUrl' action='newPlanBranch' namespace='/chain/admin' planKey=planKey returnUrl=currentUrl /]
        [@cp.displayLinkButton buttonId='createBranch' buttonLabel='branch.create.new.title' buttonUrl=createBranchUrl/]

        <script type="text/javascript">
            var redirectToBranchRepositoryConfig = function (data) {
                window.location = AJS.contextPath() + data.redirectUrl;
            }
        </script>
        [@dj.simpleDialogForm triggerSelector="#createBranch" width=710 height=500 headerKey="branch.create.new.title" submitCallback="redirectToBranchRepositoryConfig" /]
    [/#if]
[/#assign]

[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab='chain.branch' titleKey='chain.config.branches' descriptionKey='chain.config.branches.description' tools=buttonsToolbar ]
    [#if !fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@ui.messageBox type="warning" titleKey='chain.config.branches.permission.error' /]
    [#else]
        [@ww.form action='updateBranches'
            namespace='/chain/admin/config'
            showActionErrors='false'
            id='chain.branch'
            cancelUri='/browse/${immutablePlan.key}/config'
            submitLabelKey='global.buttons.update'
        ]
            [@ww.hidden name="planKey" /]
            [#if action.branchDetectionCapable]
                [@ww.text id='branchDetectionDescription' name='chain.config.branches.detection.description']
                    [@ww.param]${action.automaticBranchDetectionIntervalString!?html}[/@ww.param]
                [/@ww.text]

                [#if action.isSvnRepository()]
                    [@ui.bambooSection titleKey='chain.config.branches.svnBranchesLocation' descriptionKey='chain.config.branches.svnBranchesLocation.description']
                        [@ww.checkbox labelKey='chain.config.branches.svnBranchRootOverridden' name='svnBranchRootOverridden' toggle=true /]
                        [@ui.bambooSection dependsOn='svnBranchRootOverridden' showOn=true]
                            [@ww.textfield labelKey='chain.config.branches.svnBranchRootOverride' name='svnBranchRootOverride' cssClass="long-field" required=true/]
                        [/@ui.bambooSection]
                        [@ui.bambooSection dependsOn='svnBranchRootOverridden' showOn=false]
                            [@ww.label labelKey='chain.config.branches.svnBranchRootOverride' descriptionKey='chain.config.branches.svnBranchRootOverride.description' value=svnRepositoryBranchRoot /]
                        [/@ui.bambooSection]
                    [/@ui.bambooSection]
                [/#if]

                [@ui.bambooSection titleKey='chain.config.branches.detection.title' description=branchDetectionDescription]
                    [@ww.checkbox labelKey='chain.config.branches.enabled' toggle=true name='enabled' helpKey='branch.automatic.detection'/]

                    [#assign inactivityDescription]<span class="aui-form">[@ww.text name="chain.config.branches.autoClean.days.desc"/]</span>[/#assign]
                    [@ui.bambooSection dependsOn='enabled' showOn=true]
                        [@ww.textfield labelKey='chain.config.branches.matchingPattern' name='matchingPattern'/]
                        [@ww.textfield cssClass='short-field' labelKey='chain.config.branches.autoClean.days' name='timeOfInactivityInDays' after=inactivityDescription /]
                    [/@ui.bambooSection]
                [/@ui.bambooSection]
            [#else]
                [@ui.bambooPanel titleKey='chain.config.branches.detection.title' description=branchDetectionDescription headerWeight='h3']
                    [@ui.messageBox titleKey='chain.config.branches.detection.error']
                    <p>[@ww.text name='chain.config.branches.detection.error.message' /]</p>
                    [/@ui.messageBox]
                [/@ui.bambooPanel]
            [/#if]

            [#if mergeCapable]
                [@bc.showIntegrationStrategyConfiguration chain=immutableChain configuringDefaults=true titleKey="chain.config.branches.merging.edit"/]
            [#elseif defaultRepository??]
                [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepository/]
            [/#if]

            [#if jiraApplicationLinkDefined]
                [@ui.bambooSection titleKey="chain.config.branches.issueLinking" descriptionKey='chain.config.branches.issueLinking.description']
                    [@ww.checkbox labelKey='chain.config.branches.issueLinkingEnabled' name='remoteJiraBranchLinkingEnabled' helpKey="branch.featureBranches"/]
                [/@ui.bambooSection]
            [/#if]
            [@ui.bambooSection titleKey='chain.config.branches.notifications' descriptionKey='chain.config.branches.notifications.description']
                [@ww.radio name="defaultNotificationStrategy"
                listKey="key"
                listValue="key"
                i18nPrefixForValue="chain.config.branches.notifications"
                showDescription=true
                list=notificationStrategies /]
            [/@ui.bambooSection]
        [/@ww.form]
    [/#if]

    [#if !hideBranchesSplashScreen]
        [@ww.text name='branch.splash.description' id='branchSplashDescription' /]
        [#assign dialogContent][#rt/]
            <h2>[@ww.text name='branch.splash.heading' /]</h2>[#t/]
            <p>${branchSplashDescription?replace('\n', '<br>')?replace('<br><br>', '</p><p>')}</p>[#t/]
            <p>[@help.url pageKey="branch.using.plan.branches"][@ww.text name='branch.splash.learnmore' /][/@help.url]</p>[#t/]
        [/#assign][#lt/]
        <script type="text/x-template" title="dontShowCheckbox-template">
            [@ww.checkbox name='dontshow' labelKey='branch.splash.dontshowagain' /]
        </script>
        <script type="text/javascript">
            BAMBOO.BRANCHES.BranchesSplashScreen.init({ content: '${dialogContent?js_string}', templates: { dontShowCheckbox: 'dontShowCheckbox-template' } });
        </script>
    [/#if]
[/@eccc.editChainConfigurationPage]