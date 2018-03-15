[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigBeanImpl" --]
[#-- snippet displayed in repository config right panel --]
[#import "/build/common/repositoryCommon.ftl" as rc]
[@ww.form   action=submitAction
            method='POST'
            enctype='multipart/form-data'
            namespace="/chain/admin/config"
            submitLabelKey="repository.update.button"
            cancelUri="/chain/admin/config/editChainRepository.action?planKey=${planKey}"
            cssClass="top-label"]

     [@ww.hidden name="planKey" value=planKey /]
     [@ww.hidden name="repositoryId" value=repositoryId /]

     [#assign selectableRepositories =  uiConfigBean.getRepositoriesForAdding(immutablePlan, selectedRepository)/]

    [#if repositoryId > 0 && !repositoryDefinition.global && fn.hasAdminPermission()]
        <div class="aui-toolbar inline share-repository-toolbar">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    [@ww.url id="convertActionUrl" action='convertLocalToGlobalRepository' namespace='/admin' repositoryId=repositoryId planKey=planKey/]
                    <a id="convertActionTrigger_${repositoryId}" href="${convertActionUrl}" class="repositoryTools toolbar-trigger">[@ww.text name="repository.shared.convert"/]</a>
                </li>
            </ul>
        </div>
    [/#if]

     [@ww.select labelKey='repository.type'
                 name='selectedRepository'
                 id='selectedRepository'
                 toggle='true'
                 list=selectableRepositories
                 listKey='key'
                 listValue='name'
                 optionDescription='optionDescription'
                 groupBy='group']
    [/@ww.select]

    [@ui.bambooSection dependsOn='selectedRepository' showOn=repositoryPluginKeys id='repository-id']
        [@ww.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" required=true/]
    [/@ui.bambooSection]

    [@ui.bambooSection id='repository-configuration']
        [#list selectableRepositories as repo]
            [#if !decorator?? || decorator != "nothing" || selectedRepository == repo.key]
                [@rc.basicRepositoryEdit repo mutablePlan /]
            [/#if]
        [/#list]
        [@rc.advancedRepositoryEdit plan=mutablePlan dependsOn='selectedRepository' showOn=repositoryPluginKeys /]
    [/@ui.bambooSection]

[/@ww.form]