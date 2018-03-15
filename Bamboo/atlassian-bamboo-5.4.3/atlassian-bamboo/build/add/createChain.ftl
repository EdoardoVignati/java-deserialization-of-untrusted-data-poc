[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#import "/build/common/repositoryCommon.ftl" as rc]
<html>
<head>
    <meta name="decorator" content="createWizard"/>
    <meta name="tab" content="1"/>
    <title>[@ww.text name='plan.create' /] - [@ww.text name='plan.create.new.title' /]</title>
</head>
<body>

<div id="onePageCreate">
[@ui.header pageKey="plan.create" descriptionKey="plan.create.new.description" headerElement="h2"/]

[@ww.form action="createPlan" namespace="/build/admin/create"
          method="post" enctype="multipart/form-data"
          cancelUri='start.action'
          submitLabelKey='plan.create.tasks.button']

        <div class="configSection">
            [@ui.bambooSection titleKey="project.details"]
                [#include "/fragments/project/selectCreateProject.ftl"]
            [/@ui.bambooSection]
            [@ui.bambooSection titleKey="build.details"]
                [#include "/fragments/chains/editChainKeyName.ftl"]
            [/@ui.bambooSection]

            [@ui.bambooSection titleKey="repository.title"]

                [#assign selectableRepositories = uiConfigBean.getRepositoriesForCreate()/]

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

                [#list selectableRepositories as repo]
                    [#assign repoCssClass][#if repo.group?has_content]global-repository-details[/#if][/#assign]
                    [@ui.bambooSection dependsOn='selectedRepository' showOn='${repo.key}' cssClass=repoCssClass!""]
                        [#if repo.group?has_content]
                            [@rc.displayRepository repo.repositoryData "" false false true /]
                        [#else]
                            ${repo.repository.getMinimalEditHtml(buildConfiguration)!}
                        [/#if]
                    [/@ui.bambooSection]
                [/#list]
                [@ww.hidden name="selectedWebRepositoryViewer" value="bamboo.webrepositoryviewer.provided:noRepositoryViewer" /]
            [/@ui.bambooSection]

            [#assign triggersToolbar]
                [@help.url pageKey="plan.triggers.howtheywork"][@ww.text name="plan.triggers.howtheywork.title"/][/@help.url]
            [/#assign]
            [@ui.bambooSection titleKey="create.chain.trigger.header" tools=triggersToolbar]
                [#include "/build/common/configureBuildStrategy.ftl"]
                [@configureBuildStrategy create=true/]
            [/@ui.bambooSection]
        </div>

[/@ww.form]
</div>
</body>
</html>