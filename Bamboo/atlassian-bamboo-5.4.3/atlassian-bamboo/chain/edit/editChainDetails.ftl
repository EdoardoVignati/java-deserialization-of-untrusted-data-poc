[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage descriptionKey="chain.details.edit.description" plan=immutablePlan selectedTab='build.details' titleKey="chain.details.edit"]

    [@ww.form action="saveChainDetails" namespace="/chain/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
        [@ww.hidden name="buildKey" /]
        [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
        [@ww.textfield labelKey='chain.name' name='chainName' required='true' /]
        [@ww.textfield labelKey='chainDescription' name='chainDescription' required='false' longField=true /]
        [@ww.checkbox labelKey='plan.enabled' name="enabled" /]
        [@ww.hidden name="returnUrl" /]
        [@ww.hidden name="planKey" /]
    [/@ww.form]

[/@eccc.editChainConfigurationPage]
