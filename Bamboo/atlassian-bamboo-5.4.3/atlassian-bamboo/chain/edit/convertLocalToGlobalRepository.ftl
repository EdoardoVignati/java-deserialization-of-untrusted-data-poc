[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.ConvertLocalToGlobalRepository" --]
[#assign selectableRepositories=repositoriesForConvertion/]
[#assign description][#if selectableRepositories.size() > 1][@ww.text name="repository.shared.convert.description"/][/#if][/#assign]
[#import "/build/common/repositoryCommon.ftl" as rc]
    [@ww.form   action="executeConvertLocalToGlobalRepository"
                namespace="/admin"
                submitLabelKey="repository.update.button"
                cancelUri="/chain/admin/config/editChainRepository.action?planKey=${planKey}"
                cssClass="top-label"
                description=description]

    [#if selectableRepositories.size() > 1]
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

        [@ui.bambooSection dependsOn='selectedRepository' showOn="0"]
            [@ww.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" required=true/]
        [/@ui.bambooSection]
    [#else]
        [@ww.hidden selectedRepository value="0"/]
        [@ww.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" required=true/]
    [/#if]
    [@ww.hidden name="planKey" value=planKey /]
    [@ww.hidden name="repositoryId" value=repositoryId /]

    [/@ww.form]