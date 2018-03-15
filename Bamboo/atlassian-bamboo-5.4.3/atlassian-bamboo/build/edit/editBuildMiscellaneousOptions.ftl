[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=immutablePlan  selectedTab='miscellaneous' titleKey='miscellaneous.title']
        [@ww.form action='updateMiscellaneous' namespace='/build/admin/edit'
                cancelUri='/build/admin/edit/editMiscellaneous.action?buildKey=${immutablePlan.key}'
                submitLabelKey='global.buttons.update']

            [@ww.hidden name='buildKey' value=immutablePlan.key /]

            [@ww.checkbox name='cleanWorkingDirectory' labelKey='repository.common.cleanWorkingDirectory' /]

            [#assign pluginPages = miscellaneousBuildConfigurationEditHtmlList/]
            [#if pluginPages?has_content]
                [#list pluginPages as pluginPage]
                    ${pluginPage}
                [/#list]
            [#else]
                [@ui.displayText key='miscellaneous.noContent'/]
            [/#if]
        [/@ww.form]
[/@ebcc.editConfigurationPage]