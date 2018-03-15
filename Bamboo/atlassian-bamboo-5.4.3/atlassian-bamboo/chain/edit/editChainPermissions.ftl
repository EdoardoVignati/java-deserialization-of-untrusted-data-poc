[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#import "/lib/build.ftl" as bd]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab='permissions' titleKey='build.permissions.title' descriptionKey='build.permissions.description']
        [@bd.configurePermissions action='updateChainPermissions' cancelUri='/browse/${immutablePlan.key}/config' /]
[/@eccc.editChainConfigurationPage]
