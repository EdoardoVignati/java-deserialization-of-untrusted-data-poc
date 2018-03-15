[#macro showIntegrationStrategyConfiguration chain configuringDefaults=false titleKey="branch.integration.edit"]
    [#assign branchName=chain.buildName?html/]
    [#assign prefix='branchIntegration'/]
    [#if configuringDefaults]
        [#assign branchName][@ww.text name='chain.config.branches.merging.currentBranch'/][/#assign]
        [#assign prefix='branches.defaultBranchIntegration'/]
    [/#if]

    [@ww.text name='repository.global.mergeResult' id='mergeResultText' /]
    [#assign checkoutLozenge][@ui.branchLozenge planBranchName=branchName cssClass="checkout-lozenge"/][/#assign]
    [#assign pushLozenge][@ui.branchLozenge planBranchName=branchName cssClass="push-lozenge"/][/#assign]

    [@ui.bambooSection titleKey=titleKey descriptionKey=titleKey+".description"]
        [@ww.checkbox labelKey='branch.integration.enabled' name=prefix+'.enabled' toggle=true helpKey='branch.mergeStrategy'/]
        [@ui.bambooSection id="integration-strategies" sectionContainer='div' dependsOn=prefix+'.enabled']
        ${branchIntegrationEditHtml!}
        <div class="aui-group">
            <div class="aui-item">
                [@ui.bambooSection id="branch-updater" cssClass="integration-strategy"]
                        [@ww.radio name=prefix+'.strategy'
                            template='radio.ftl'
                            fieldValue='BRANCH_UPDATER'
                            labelKey='branch.integration.strategy.branchUpdater'
                            helpKey='branch.autointegration.branchUpdater'/]

                        [@ww.label nameValue=checkoutLozenge
                            labelKey='repository.global.checkout'
                            escape=false /]

                        [@ww.select name=prefix+'.branchUpdater.mergeFromBranch'
                            listKey='key.planKey.toString()'
                            listValue='key.buildName'
                            list=branchesForAutoIntegration
                            labelKey='repository.global.mergeFrom'
                            fullWidthField=true
                            groupBy='value' /]

                        [@ww.label labelKey='global.verbs.build' nameValue=mergeResultText /]

                        [@pushGroup]
                            [@ww.checkbox name=prefix+".branchUpdater.pushEnabled" label=pushLozenge /]
                        [/@pushGroup]
                    [/@ui.bambooSection]
            </div>
            <div class="aui-item">
                [@ui.bambooSection id="gate-keeper" cssClass="integration-strategy"]
                        [@ww.radio name=prefix+'.strategy'
                            template='radio.ftl'
                            fieldValue='GATE_KEEPER'
                            labelKey='branch.integration.strategy.gateKeeper'
                            helpKey='branch.autointegration.gateKeeper'/]

                        [@ww.select name=prefix+'.gateKeeper.checkoutBranch'
                            listKey='key.planKey.toString()'
                            listValue='key.buildName'
                            list=branchesForAutoIntegration
                            labelKey='repository.global.checkout'
                            fullWidthField=true
                            groupBy='value' /]

                        [@ww.label nameValue=checkoutLozenge
                            labelKey='repository.global.mergeFrom'
                            escape=false /]

                        [@ww.label labelKey='global.verbs.build' nameValue=mergeResultText /]

                        [@pushGroup]
                            [@ww.checkbox name=prefix+".gateKeeper.pushEnabled" label=pushLozenge /]
                        [/@pushGroup]
                    [/@ui.bambooSection]
            </div>
        </div>
        [#assign integrationEnabledName=prefix+".enabled"/]
        [#assign integrationStrategyName=prefix+".strategy"/]
        [#assign gateKeeperCheckoutBranchName=prefix+".gateKeeper.checkoutBranch"/]
        [#assign gateKeeperPushBranchId="#label_saveChainBranchDetails_branchIntegration_gateKeeper_pushEnabled"/]
        [#if configuringDefaults][#assign gateKeeperPushBranchId="#label_chain_branch_branches_defaultBranchIntegration_gateKeeper_pushEnabled"/][/#if]

        <script type="text/javascript">
            BAMBOO.BRANCHES.EditChainBranchDetails({
                                                       controls: {
                                                           form: [#if configuringDefaults]'#chain_branch'[#else]'#saveChainBranchDetails'[/#if],
                                                           integrationEnabled: 'input[name="${integrationEnabledName}"]',
                                                           integrationStrategy: 'input[name="${integrationStrategyName}"]',
                                                           gateKeeperCheckoutBranch: 'select[name="${gateKeeperCheckoutBranchName}"]',
                                                           gateKeeperPushBranch: '${gateKeeperPushBranchId} .name'
                                                       }
                                                   }).init();
        </script>
        [/@ui.bambooSection]
    [/@ui.bambooSection]
[/#macro]

[#macro pushGroup]
    [@ww.text name='repository.global.push' id='pushOnSuccess'][@ww.param]<span class="assistive xxx">[/@ww.param][@ww.param]</span>[/@ww.param][/@ww.text]
<fieldset class="group">
    <legend><span>${pushOnSuccess}[@ui.icon type='successful' /]</span></legend>
    [#nested/]
</fieldset>
[/#macro]

[#macro mergingNotAvailableMessage gitRepository defaultRepositoryDefinition defaultRepository]
    [#if gitRepository]
        [#assign unsupportedWarning]
            [#if fn.hasGlobalAdminPermission()]
                [@ww.text name='branch.integration.unsupported.git.add']
                    [@ww.param][@ww.url action='configureSharedLocalCapabilities' namespace='/admin/agent'/][/@ww.param]
                [/@ww.text]
            [#else]
                [@ww.text name='branch.integration.unsupported.git.contact.admin' /]
            [/#if]
            <a href="[@help.href pageKey="branch.gitCapabilityHelp"/]" rel="help">[@ui.icon type="help"/]</a>
        [/#assign]
    [#else]
        [#assign unsupportedWarning]
            [@ww.text name='branch.integration.unsupported']
                [@ww.param]${defaultRepositoryDefinition.name}[/@ww.param]
                [@ww.param]${defaultRepository.name}[/@ww.param]
            [/@ww.text]
        [/#assign]
    [/#if]
    [@ui.bambooPanel titleKey='branch.integration.edit' headerWeight='h3']
        [@ui.messageBox type="warning" content=unsupportedWarning /]
    [/@ui.bambooPanel]
[/#macro]