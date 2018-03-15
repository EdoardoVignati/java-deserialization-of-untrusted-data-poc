[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=immutablePlan  selectedTab='miscellaneous' titleKey='miscellaneous.title']
        [@ww.form action='updateChainMiscellaneous' namespace='/chain/admin/config'
                  cancelUri='/browse/${immutablePlan.key}/config'
                  submitLabelKey='global.buttons.update']

            [@ww.hidden name='buildKey' value=immutablePlan.key /]

            [#assign pluginPages = miscellaneousBuildConfigurationEditHtmlList/]
            [#if pluginPages?has_content]
                [#list pluginPages as pluginPage]
                    ${pluginPage}
                [/#list]
            [#else]
                [@ui.displayText key='miscellaneous.noContent'/]
            [/#if]
        [/@ww.form]
[/@eccc.editChainConfigurationPage]