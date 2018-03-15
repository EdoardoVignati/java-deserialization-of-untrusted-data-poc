[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.DeleteGlobalRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.DeleteGlobalRepository" --]
<meta name="decorator" content="none"/>
[@ww.form   action="deleteGlobalRepository"
namespace="/admin/"
submitLabelKey="global.buttons.delete"
cancelUri="/admin/configureGlobalRepositories.action"]

    [@ui.messageBox type="warning" titleKey="repository.delete.confirm" /]

    [#import "/build/common/repositoryCommon.ftl" as rc]
    [@rc.viewGlobalRepositoryUsages planUsingRepository environmentUsingRepository /]
    [@ww.hidden name="createRepositoryKey"/]
    [@ww.hidden name="repositoryId"/]
[/@ww.form]