[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigBeanImpl" --]

[#macro configureBuildStrategy create=false long=false branch=false deployment=false]

    [#assign planBranchLozengeLabel][@s.text  name='deployment.trigger.planBranch'/][/#assign]

    [#assign vcsUsed = true/]
    [#if repositoryDefinitions?? && !repositoryDefinitions?has_content]
        [#assign vcsUsed = false/]
    [/#if]

    [#assign descriptionKey='repository.change.description'/]
    [#if deployment]
        [#assign descriptionKey='deployment.triggerType.description'/]
    [/#if]

    [#if (create || branch) && !deployment ]
        [@s.select labelKey='repository.change'  descriptionKey=descriptionKey
            name='selectedBuildStrategy' id='selectedBuildStrategy'
            listKey='key' listValue='description' toggle='true'
            list=uiConfigBean.getBuildStrategiesForCreate(vcsUsed) required=true /]
    [#else]
        [@s.select labelKey='repository.change' descriptionKey=descriptionKey
                name='selectedBuildStrategy' id='selectedBuildStrategy'
                listKey='key' listValue='description' toggle='true'
                list=action.getTriggerTypes(vcsUsed) required=true /]
    [/#if]

    [#if !create]

        [@s.checkboxlist   labelKey="repository.config.repositoryTrigger"
                            name="repositoryTrigger"
                            list=repositoryTriggerSelectors
                            listKey="id"
                            listValue="name"
                            listChecked="buildTrigger"
                            dependsOn="selectedBuildStrategy" showOn="poll trigger"/]
    [/#if]

    [#-- PollingBuildStrategy --]
    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='poll']
        [@s.radio key='config.repository.polling.strategy' name='repository.change.poll.type' listKey='first' listValue='second' toggle='true' list=uiConfigBean.pollingTypes /]
        [@ui.bambooSection dependsOn="repository.change.poll.type" showOn="PERIOD"]
            [@s.textfield labelKey='repository.change.poll.frequency' name='repository.change.poll.pollingPeriod' shortField=true /]
        [/@ui.bambooSection]
        [@ui.bambooSection dependsOn="repository.change.poll.type" showOn="CRON"]
            [@dj.cronBuilder idPrefix="pt" name='repository.change.poll.cronExpression'/]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [#-- TriggeredBuildStrategy --]
    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='trigger']
        [@s.textfield labelKey='repository.change.trigger.ip' name='repository.change.trigger.triggerIpAddress' /]
    [/@ui.bambooSection]

    [#-- SingleDailyBuildStrategy --]
    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='daily']
        [@s.textfield labelKey='repository.change.daily.buildTime' name='repository.change.daily.buildTime' /]
    [/@ui.bambooSection]

    [#-- CronTriggerBuildStrategy --]
    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='schedule']
        [#if deployment]
            [@s.hidden name="deployment.trigger.schedule.deploymentsMode" value=true /]
            [@s.hidden id="deployment-trigger-schedule-sourcePlan" name="deployment.trigger.schedule.sourcePlan" /]

            [@dj.cronBuilder idPrefix="ct" name='repository.change.schedule.cronExpression'/]

            [#if action.hasDeploymentProjectPlanMultipleBranches()]
                [@s.radio key='deployment.trigger.schedule.branchSelectionMode'
                    name='deployment.trigger.schedule.branchSelectionMode'
                    listKey='key'
                    listValue='value'
                    toggle='true'
                    list=uiConfigBean.deploymentTriggerBranchSelectionOptions ]
                    [@s.param name='content.INHERITED']
                        ${soy.render("bamboo.deployments:deployments-main", "bamboo.widget.deployment.version.branch", {
                        'planBranchName': (action.getBranchName(deploymentProject.planKey))!,
                        'label': planBranchLozengeLabel
                        })}
                    [/@s.param]
                    [@s.param name='content.CUSTOM']
                        [@s.textfield
                            name='deployment.trigger.schedule.sourceBranch'
                            placeholderKey='deployment.trigger.schedule.sourceBranch.placeholder'
                            required=true
                            masterPlanPickerId='deployment-trigger-schedule-sourcePlan'
                            includeMasterBranch=true
                            template='branchPicker'
                            cssClass='long-field'/]
                    [/@s.param]
                [/@s.radio]
            [#else ]
                [@s.hidden name='deployment.trigger.schedule.branchSelectionMode' value='INHERITED'/]
            [/#if]
        [#else ]
            [@dj.cronBuilder idPrefix="ct" name='repository.change.schedule.cronExpression' helpKey='build.strategy.cron'/]
        [/#if]
    [/@ui.bambooSection]

    [#-- AfterSuccessfulPlanTrigger --]
    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='afterSuccessfulPlan']
        [#if deployment]
            [#local triggeringBranchKey = buildConfiguration.getString('deployment.trigger.afterSuccessfulPlan.triggeringBranch', '') /]
            [#if create || !(triggeringBranchKey?has_content) || action.hasTheSameMasterPlanAsDeploymentProject(triggeringBranchKey)]
                [@s.hidden id='deployment-trigger-afterSuccessfulPlan-triggeringPlan' name='deployment.trigger.afterSuccessfulPlan.triggeringPlan' /]

                [#if action.hasDeploymentProjectPlanMultipleBranches()]
                    [@s.radio key='deployment.trigger.afterSuccessfulPlan.branchSelectionMode'
                        name='deployment.trigger.afterSuccessfulPlan.branchSelectionMode'
                        listKey='key'
                        listValue='value'
                        toggle='true'
                        list=uiConfigBean.deploymentTriggerBranchSelectionOptions]
                        [@s.param name='content.INHERITED']
                            ${soy.render("bamboo.deployments:deployments-main", "bamboo.widget.deployment.version.branch", {
                            'planBranchName': (action.getBranchName(deploymentProject.planKey))!,
                            'label': planBranchLozengeLabel
                            })}
                        [/@s.param]
                        [@s.param name='content.CUSTOM']
                            [@s.textfield
                                name='deployment.trigger.afterSuccessfulPlan.triggeringBranch'
                                placeholderKey='deployment.trigger.afterSuccessfulPlan.triggeringBranch.placeholder'
                                required=true
                                masterPlanPickerId='deployment-trigger-afterSuccessfulPlan-triggeringPlan'
                                includeMasterBranch=true
                                template='branchPicker'
                                cssClass='long-field'/]
                        [/@s.param]
                    [/@s.radio]
                [#else ]
                    [@s.hidden name='deployment.trigger.afterSuccessfulPlan.branchSelectionMode' value='INHERITED'/]
                [/#if]
            [#else ]
                [#--backward compatibility for triggers that have external plan configured--]
                [@s.hidden name='deployment.trigger.afterSuccessfulPlan.triggeringPlan' /]
                [@s.hidden name='deployment.trigger.afterSuccessfulPlan.triggeringBranch' /]

                [@ui.messageBox type='warning'][@s.text name='deployment.trigger.afterSuccessfulPlan.triggeringPlan.warning.externalPlanSelected'/][/@ui.messageBox]
                [@s.label key='deployment.trigger.afterSuccessfulPlan.plan' escape=false]
                    [@s.param name='value']
                        [@ui.planLink plan=action.getPlan(buildConfiguration.getString('deployment.trigger.afterSuccessfulPlan.triggeringPlan', ''))/]
                    [/@s.param]
                [/@s.label]
            [/#if]
        [/#if]
    [/@ui.bambooSection]

    [#if long]
        [#assign condtionHtml = triggerConditionEditHtml /]
        [#if condtionHtml?has_content]
            [@ui.bambooSection titleKey='repository.change.conditions']
                ${condtionHtml}
            [/@ui.bambooSection]
        [/#if]
    [/#if]

    [#if create]
        [#assign optionListNoVcs]
            [@strategyOptionList false create/]
        [/#assign]

        [#assign optionListVcs]
            [@strategyOptionList true create/]
        [/#assign]

        <script type="text/javascript">
            BAMBOO.REPOSITORY.buildStrategyToggle.init({
                noVcsStrategyOptions: '${optionListNoVcs?js_string}',
                vcsStrategyOptions: '${optionListVcs?js_string}',
                strategyList: '#selectedBuildStrategy'
            });
        </script>
    [/#if]
[/#macro]

[#macro strategyOptionList withVcs create]
[#if create]
    [#list uiConfigBean.getBuildStrategiesForCreate(withVcs) as option]
        <option value="${option.key}">${option.description}</option>[#t]
    [/#list]
[#else]
    [#list uiConfigBean.getBuildStrategies(withVcs) as option]
        <option value="${option.key}">${option.description}</option>[#t]
    [/#list]
[/#if]
[/#macro]
