[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]

[#import "branchesCommon.ftl" as bc/]

<html>
<head>
    [@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.details"/>
</head>
<body>

[@ui.header pageKey="branch.details.edit" descriptionKey="branch.details.edit.description" /]

[@ww.form action="saveChainBranchDetails" namespace="/branch/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
    [@ww.textfield labelKey='branch.name' name='branchName' required='true' /]
    [@ww.textfield labelKey='branch.branchDescription' name='branchDescription' required='false' longField=true /]
    [@ww.checkbox labelKey='branch.enabled' name="enabled" /]
    [@ww.hidden name="returnUrl" /]
    [@ww.hidden name="planKey" /]
    [@ww.hidden name="buildKey" /]

    [#if branchDetectionCapable]
        [@ww.checkbox labelKey='branch.cleanup.disabled' name='branchConfiguration.cleanup.disabled' /]
    [/#if]

    [#include "/build/common/configureBuildStrategy.ftl"]
    [@ui.bambooSection titleKey='repository.change']
        [@ww.checkbox labelKey='branch.trigger.override' name="overrideBuildStrategy" toggle=true helpKey='branch.buildStrategy.override'/]
        [@ui.bambooSection dependsOn="overrideBuildStrategy" showOn=true]
            [@configureBuildStrategy long=true branch=true/]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [#if mergeCapable]
        [@bc.showIntegrationStrategyConfiguration chain=immutableChain/]
    [#elseif defaultRepository??]
        [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepository/]
    [/#if]

[/@ww.form]

</body>
</html>

