[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainConfiguration" --]
[#assign planI18nPrefix = fn.getPlanI18nKeyPrefix(immutablePlan)/]
<html>
<head>
    [@ui.header pageKey=planI18nPrefix+'.configuration.title.long' object='${immutableChain.name}' title=true /]
    <meta name="tab" content="config"/>
</head>
<body>

    [#import "/lib/chains.ftl" as chains]

    [#assign dropDownText][@ww.text name=planI18nPrefix+'.edit' /][/#assign]
    [#if immutableChain.suspendedFromBuilding]
        [@ww.text name='build.enable.description' id='buildEnableDescription']
            [@ww.param][@ww.url action='resumeBuild' namespace='/build/admin' buildKey=immutableChain.key returnUrl="/browse/${immutableChain.key}/config"/][/@ww.param]
        [/@ww.text]
        [@ui.messageBox title=buildEnableDescription /]
    [/#if]

    [@cp.configDropDown dropDownText 'chainConfiguration.subMenu'/]

    [@ui.header pageKey=planI18nPrefix+'.configuration.title.long' /]

    [@ui.bambooInfoDisplay titleKey=planI18nPrefix+".config.details" headerWeight="h2"]
        [@ww.label labelKey='project.key' name='chain.project.key' /]
        [@ww.label labelKey='project.name' name='chain.project.name' /]
        [@ww.label labelKey=planI18nPrefix+'.key' name='chain.planKey' /]
        [@ww.label labelKey=planI18nPrefix+'.name' name='chain.buildName' /]
        [@ww.label labelKey='chainDescription' name='chain.description'  hideOnNull='true' /]
        [@ww.label labelKey='chain.lastVcsRevisionKey' name='lastVcsRevisionKey' hideOnNull='true' /]
    [/@ui.bambooInfoDisplay]

    [#include "/build/view/viewRepository.ftl"]

    [#assign pluginHtml = dependenciesBuildConfigurationViewHtml /]
    [#if parentPlanDependencies?has_content || childPlanDependencies?has_content || pluginHtml?has_content]
        [@ui.bambooInfoDisplay titleKey="chain.dependency.title" headerWeight="h2"]
            [#include "/build/view/viewDependencies.ftl"]
            [@showDependencies parentPlanDependencies childPlanDependencies dependencyBlockingStrategy /]
            [#if pluginHtml?has_content]
                <p>${pluginHtml}</p>
            [/#if]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if (immutableChain.notificationSet.notificationRules)?has_content]
        [@ui.bambooInfoDisplay titleKey="notification.title" headerWeight="h2"]
            [#include "/chain/view/viewNotifications.ftl"]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if artifactDefinitions.keySet().size() > 0]
        [@ui.bambooInfoDisplay titleKey="artifact.shared.title" headerWeight="h2"]
            [@chains.displaySharedArtifactDefinitions artifactDefinitions /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if miscellaneousBuildConfigurationViewHtmlList?has_content]
        [@ui.bambooInfoDisplay titleKey="build.miscellaneous" headerWeight="h2"]
            [#include "/build/view/viewMiscellaneous.ftl"]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if fn.hasPlanPermission('ADMINISTRATION', immutableChain) ]
        [@ui.bambooInfoDisplay titleKey="chain.permissions.title" headerWeight="h2"]
            [@ww.action name="viewChainPermissions" executeResult="true"  ]
                 [@ww.param name="planKey" value="'${immutablePlan.key}'"/]
            [/@ww.action]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- Variables --]
    [#if variableDefinitions?has_content]
        [#import "/fragments/variable/variables.ftl" as variables/]
        [@ui.bambooInfoDisplay titleKey="plan.variables.title" headerWeight="h2"]
            [@variables.displayDefinedVariables id="variableDefinitions" variablesList=variableDefinitions /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    <h2>[@ww.text name='chain.logs.title'/]</h2>
    <p><a class="view"  href="[@ww.url value="/chain/viewChainActivityLog.action?planKey=${immutableChain.key}"/]">[@ww.text name="plan.configuration.view.log"/]</a></p>

</body>
</html>
