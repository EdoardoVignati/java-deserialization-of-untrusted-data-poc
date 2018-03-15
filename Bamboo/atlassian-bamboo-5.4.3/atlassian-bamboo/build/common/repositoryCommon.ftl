[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigBeanImpl" --]
[#-- @ftlvariable name="repo" type="com.atlassian.bamboo.ww2.actions.build.admin.create.RepositoryOption" --]

[#macro basicRepositoryEdit repo plan=mutablePlan]
    [#assign repoCssClass][#if repo.group?has_content]global-repository-details[/#if][/#assign]
    [@ui.bambooSection dependsOn='selectedRepository' showOn=repo.key cssClass=repoCssClass!"" id='repository-edit-${repo.key}' titleKey=repo.group?has_content?string('repository.configuration', '')]
        [#if repo.group?has_content]
            [#if fn.hasAdminPermission()]
                [@ww.url id='editSharedRepositoryUrl' action='configureGlobalRepositories' namespace='/admin' repositoryId=repo.key /]
                [@ww.text name="repository.shared.edit"]
                    [@ww.param ]<a href="${editSharedRepositoryUrl}">[@ww.text name="repository.shared.edit.admin"/]</a>[/@ww.param]
                [/@ww.text]
            [/#if]
            [@displayRepository repo.repositoryData plan false false true /]
        [#else]
        ${repo.repository.getEditHtml(buildConfiguration, plan)!}
        [/#if]
    [/@ui.bambooSection]
[/#macro]

[#macro advancedRepositoryEdit plan=mutablePlan changeDetection=false globalRepository=false dependsOn='' showOn=true]
    [@ui.bambooSection titleKey='repository.advanced.option' dependsOn=dependsOn showOn=showOn collapsible=true isCollapsed=true]
        [#if globalRepository]
            [#list uiConfigBean.standaloneRepositories as repo]
                [#if !decorator?? || decorator != "nothing" || selectedRepository == repo.key]
                    [@ui.bambooSection dependsOn='selectedRepository' showOn=repo.key]
                    ${repo.getAdvancedEditHtml(buildConfiguration)!}
                    [/@ui.bambooSection]
                [/#if]
            [/#list]
        [#else]
            [#list uiConfigBean.repositories as repo]
                [#if !decorator?? || decorator != "nothing" || selectedRepository == repo.key]
                    [@ui.bambooSection dependsOn='selectedRepository' showOn=repo.key]
                    ${repo.getAdvancedEditHtml(buildConfiguration, plan)!}
                    [/@ui.bambooSection]
                [/#if]
            [/#list]
        [/#if]
        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:cvs __com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.checkbox labelKey='repository.common.quietPeriod.enabled' toggle='true' name='repository.common.quietPeriod.enabled' /]
            [@ui.bambooSection dependsOn='repository.common.quietPeriod.enabled' showOn='true' ]
                [@ww.textfield labelKey='repository.common.quietPeriod.period' name='repository.common.quietPeriod.period' required='true' /]
                [@ww.textfield labelKey='repository.common.quietPeriod.maxRetries' name='repository.common.quietPeriod.maxRetries' required='true' /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.select labelKey='filter.pattern.option' name='filter.pattern.option' toggle='true'
            list=uiConfigBean.filterOptions listKey='name' listValue='label' uiSwitch='value']
            [/@ww.select]

            [@ui.bambooSection dependsOn='filter.pattern.option' showOn='regex']
                [@ww.textfield labelKey='filter.pattern.regex' name='filter.pattern.regex' /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.textfield labelKey="changeset.filter.pattern.regex" name="changeset.filter.pattern.regex" /]
        [/@ui.bambooSection]
        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.select id="selectedWebRepositoryViewer" labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
            list='uiConfigBean.webRepositoryViewers' listKey='key' listValue='name']
            [/@ww.select]
            [#list uiConfigBean.webRepositoryViewers as viewer]
                [#if viewer.getEditHtml(buildConfiguration, mutablePlan)!?has_content]
                    [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn=viewer.key]
                    ${viewer.getEditHtml(buildConfiguration, mutablePlan)!}
                    [/@ui.bambooSection]
                [/#if]
            [/#list]
        [/@ui.bambooSection]

    <script type="text/javascript">
        AJS.$(function ($)
              {
                  var mutateSelectedWebRepo = function ()
                          {
                              BAMBOO.DynamicFieldParameters.mutateSelectListContent($(this), $('#selectedWebRepositoryViewer'), $.parseJSON('${uiConfigBean.webRepositoryJson}'));
                          },
                          $selectedRepository = $('#selectedRepository').change(mutateSelectedWebRepo);

                  mutateSelectedWebRepo.call($selectedRepository);
              });
    </script>
    [/@ui.bambooSection]
[/#macro]

[#macro displayRepository repositoryData plan isCollapsed=false condensed=false globalRepository=false]
    [#if repositoryData??]
        [#assign repository = repositoryData.repository/]

        [#if !condensed]
            [@ww.label labelKey='repository.type' value=repository.name /]
        [/#if]

        [#if globalRepository]
        ${repository.getViewHtml()!}
        [#else]
        ${repository.getViewHtml(plan)!}
        [/#if]

        [#if !globalRepository]
            [@ww.label labelKey='repository.config.buildTrigger' value=repositoryData.buildTrigger?string /]
        [/#if]

        [#if !condensed]
            [#if plan?has_content]
            ${repository.getAdvancedViewHtml(plan)!}
            [#else]
            ${repository.getAdvancedViewHtml()!}
            [/#if]

            [#if repository.name != "CVS"]
                [#if repository.quietPeriodEnabled]
                    [@ww.label labelKey='repository.common.quietPeriod.period' value=repository.quietPeriod! hideOnNull='true' /]
                    [@ww.label labelKey='repository.common.quietPeriod.maxRetries' value=repository.maxRetries! hideOnNull='true' /]
                [/#if]
            [/#if]

            [#if repository.filterFilePatternOption?? && repository.filterFilePatternOption == 'includeOnly']
                [#assign filterOptionDescription][@ww.text name='filter.pattern.option.includeOnly' /][/#assign]
            [#elseif repository.filterFilePatternOption?? && repository.filterFilePatternOption == 'excludeAll']
                [#assign filterOptionDescription][@ww.text name='filter.pattern.option.excludeAll' /][/#assign]
            [#else]
                [#assign filterOptionDescription='None' /]
            [/#if]

            [#if filterOptionDescription != 'None']
                [@ww.label labelKey='filter.pattern.option' value=filterOptionDescription /]
                [@ww.label labelKey='filter.pattern.regex' value=repository.filterFilePatternRegex hideOnNull='true' /]
            [/#if]
            [#if plan?has_content && repositoryData.webRepositoryViewer?has_content]
            ${repositoryData.webRepositoryViewer.getViewHtml(plan)!}
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro viewGlobalRepositoryUsages planUsingRepository environmentUsingRepository]
<p>
    [#if planUsingRepository?has_content]
                [@ww.text name="repository.shared.usages.header"/]
    <ul>
        [#list planUsingRepository as planIdentifier]
            <li>[@ui.renderPlanNameLink plan=planIdentifier /]</li>
        [/#list]
    </ul>
    [#else]
        [@ww.text name="repository.shared.noUses"/]
    [/#if]
</p>
<p>
    [#if environmentUsingRepository?has_content]
                [@ww.text name="environment.repository.shared.usages.header"/]
    <ul>
        [#list environmentUsingRepository as environmentRepositoryLink]
            <li>[@ui.renderEnvironmentNameLink environmentRepositoryLink=environmentRepositoryLink /]</li>
        [/#list]
    </ul>
    [#else]
        [@ww.text name="environment.repository.shared.noUses"/]
    [/#if]
</p>
[/#macro]