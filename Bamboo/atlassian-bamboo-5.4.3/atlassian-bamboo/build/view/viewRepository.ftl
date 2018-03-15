[#import "/build/common/repositoryCommon.ftl" as rc]

[@ww.text id="i18n_globalButtonsCollapse" name="global.buttons.collapse"/]
[@ww.text id="i18n_globalButtonsExpand" name="global.buttons.expand"/]

[#assign viewRepositoryListToolbar]
<li><a id="collapseAllRepositoryDetails">[@ww.text name="global.buttons.collapse.all"/]</a></li>
<li><a id="expandAllRepositoryDetails">[@ww.text name="global.buttons.expand.all"/]</a></li>
[/#assign]

[@ui.bambooInfoDisplay id="view-repository-list" titleKey="repository.title" headerWeight="h2" tools=viewRepositoryListToolbar toolsContainer="ul"]
    [#if repositoryDefinitions?has_content]
        [#assign isInitiallyCollapsed=(repositoryDefinitions?size > 1) /]
        <ul id="bamboo-repository-list">
            [#list repositoryDefinitions as repositoryDefinition]
                [@viewRepositoryItem repositoryDefinition=repositoryDefinition plan=plan isCollapsed=isInitiallyCollapsed /]
            [/#list]
        </ul>
        <script type="text/javascript">
            BAMBOO.ViewInfoList.init({
                elementSelector: ".repository",
                target: "#view-repository-list",
                collapseAll: "#collapseAllRepositoryDetails",
                expandAll: "#expandAllRepositoryDetails",
                i18n: {
                    collapse: "${i18n_globalButtonsCollapse?js_string}",
                    expand: "${i18n_globalButtonsExpand?js_string}"
                }
            });
        </script>
    [#else]
        <p>[@ww.text name="repositories.view.noRepositoriesDefined" /]</p>
    [/#if]
[/@ui.bambooInfoDisplay]


[#if plan.type != "JOB"]
    [@ui.bambooInfoDisplay titleKey="repository.change" headerWeight="h2"]
        [@ww.label labelKey='repository.change' name='plan.buildDefinition.buildStrategy.name' /]

        [#if plan.buildDefinition.buildStrategy.key == 'poll']
            [#if plan.buildDefinition.buildStrategy.pollingStrategy == "CRON"]
                [@dj.cronDisplay idPrefix="pt" name="plan.buildDefinition.buildStrategy.pollingCronExpression" /]
            [#else]
                [@ww.label labelKey='repository.change.poll.frequency' value='${plan.buildDefinition.buildStrategy.pollingPeriod}' /]
            [/#if]
        [#elseif plan.buildDefinition.buildStrategy.key == 'trigger']
            [@ww.label labelKey='repository.change.trigger.ip' value='${plan.buildDefinition.buildStrategy.triggerIpAddress}' /]
        [#elseif plan.buildDefinition.buildStrategy.key == 'daily']
            [@ww.label labelKey='repository.change.daily.buildTime' value='${plan.buildDefinition.buildStrategy.formattedTime}' /]
        [#elseif plan.buildDefinition.buildStrategy.key == 'schedule']
            [@dj.cronDisplay idPrefix="ct" name="plan.buildDefinition.buildStrategy.cronExpression" /]
        [/#if]
        ${triggerConditionViewHtml!}
    [/@ui.bambooInfoDisplay]
[/#if]

[#macro viewRepositoryItem repositoryDefinition plan isCollapsed=true]
<li class="repository [#if isCollapsed]collapsed[#else ]expanded[/#if]">
    <div class="summary">
        [#if isCollapsed]
            <a tabindex="0" class="toggle">[@ui.icon type="expand" text=i18n_globalButtonsExpand/]</a>
        [#else]
            <a tabindex="0" class="toggle">[@ui.icon type="collapse" text=i18n_globalButtonsCollapse/]</a>
        [/#if]
        <div class="repository-title">
            ${repositoryDefinition.name?html}
            <span class="repository-url">${repositoryDefinition.repository.repositoryUrl!?html}
            [#if repositoryDefinition.global]
                [#if fn.hasAdminPermission()]
                    <a href="[@ww.url action='configureGlobalRepositories' namespace='/admin' repositoryId=repositoryDefinition.id /]">[@ww.text name='repository.shared.title.marker' /]</a>
                [#else]
                    [@ww.text name='repository.shared.title.marker' /]
                [/#if]
            [/#if]
            </span>
        </div>
    </div>
    <div class="details">
        [@rc.displayRepository repositoryData=repositoryDefinition plan=plan isCollapsed=isInitiallyCollapsed /]
    </div>
</li>
[/#macro]
