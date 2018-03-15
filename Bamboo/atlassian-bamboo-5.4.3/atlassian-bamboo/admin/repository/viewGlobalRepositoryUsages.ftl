[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ConfigureGlobalRepository" --]

[#import "/build/common/repositoryCommon.ftl" as rc]

[@ww.form id='viewRepositoryUsagesForm'
action='configureGlobalRepositories'
submitLabelKey='global.buttons.close']
    [@ww.hidden name="repositoryId" value=repositoryId/]

    [@rc.viewGlobalRepositoryUsages planUsingRepository environmentUsingRepository /]
[/@ww.form]
