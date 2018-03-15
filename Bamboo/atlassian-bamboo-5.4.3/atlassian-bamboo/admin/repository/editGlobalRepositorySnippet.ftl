[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.EditGlobalRepository" --]
[#-- snippet displayed in repository config right panel --]
[#import "/build/common/repositoryCommon.ftl" as rc/]
[@ww.form  action=submitAction
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="repository.update.button"
        cancelUri="/admin/editGlobalRepository.action"
        cssClass="top-label"]

    [@ww.hidden name="repositoryId" value=repositoryId /]

    [#if repositoryId > 0]
        <div class="aui-toolbar inline share-repository-toolbar">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    <a class="viewRepositoryUsagesTrigger toolbar-trigger" class="toolbar-trigger" href="[@ww.url action='viewPlansUsingGlobalRepository' namespace='/admin' repositoryId=repositoryId /]">[@ww.text name="repository.shared.view.usages"/]</a>
                </li>
                <li class="toolbar-item">
                    <a class="toolbar-trigger" href="[@ww.url action='configureGlobalRepositoryPermissions' namespace='/admin' repositoryId=repositoryId /]" class="repositoryTools">[@ww.text name="repository.shared.permissions.edit"/]</a>
                </li>
            </ul>
        </div>
    [/#if]

    [@dj.simpleDialogForm
        triggerSelector="#viewPlansTrigger_${repositoryId}"
        width=600
        height=300
        headerKey="repository.shared.view.usages"/]

    [@ww.select labelKey='repository.type'
        name='selectedRepository'
        id="selectedRepository"
        toggle='true'
        list=uiConfigBean.standaloneRepositories
        listKey='key'
        listValue='name'
        optionDescription='optionDescription']
    [/@ww.select]

    [@ui.bambooSection id='repository-id']
        [@ww.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" required=true/]
    [/@ui.bambooSection]

    [@ui.bambooSection id='repository-configuration']
        [#list uiConfigBean.standaloneRepositories as repo]
            [#if !decorator?? || decorator != "nothing" || selectedRepository == repo.key]
                [@ui.bambooSection dependsOn='selectedRepository' showOn=repo.key id='repository-edit-${repo.key}']
                    ${repo.getEditHtml(buildConfiguration)!}
                [/@ui.bambooSection]
            [/#if]
        [/#list]
        [@rc.advancedRepositoryEdit plan='' changeDetection=false globalRepository=true/]
    [/@ui.bambooSection]
[/@ww.form]