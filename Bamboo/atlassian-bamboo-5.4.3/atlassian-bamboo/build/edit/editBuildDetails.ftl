[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDetails" --]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=immutablePlan selectedTab='build.details' titleKey='job.details.edit']
        [@ww.form action="updateBuildDetails" namespace="/build/admin/edit"
              cancelUri='/build/admin/edit/editBuildDetails.action?buildKey=${immutableBuild.key}'
              submitLabelKey='global.buttons.update' ]
            [@ww.hidden name="buildKey" /]
            [@ww.textfield labelKey='job.name' name='buildName' required='true' /]
            [@ww.textfield labelKey='job.description' name='buildDescription' required='false' longField=true /]
            [@ww.checkbox labelKey='job.enabled' name="enabled" /]

            [#if repositoriesForWorkingDirSelection?has_content]
                [@ww.select labelKey='job.workingDirectory'
                            name='workingDirSelector'
                            list='workingDirSelectorOptions'
                            toggle='true'
                /]
                [@ui.bambooSection dependsOn='workingDirSelector' showOn='REPOSITORY']
                    [@ww.select labelKey='job.workingDirectory.definingRepository'
                                name='repositoryDefiningWorkingDirectory'
                                list='repositoriesForWorkingDirSelection'
                    /]
                [/@ui.bambooSection]
            [/#if]
        [/@ww.form]
[/@ebcc.editConfigurationPage]