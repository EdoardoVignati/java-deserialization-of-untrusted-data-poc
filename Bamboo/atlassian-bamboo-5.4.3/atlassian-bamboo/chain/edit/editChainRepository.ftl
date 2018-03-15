[#import "editChainConfigurationCommon.ftl" as eccc/]
[@ww.text id="repositoryDescription" name="repositories.title"]
    [@ww.param]<a href="[@ww.url action="editChainDetails" namespace="/chain/admin/config" planKey=planKey /]">[/@ww.param]
    [@ww.param]</a>[/@ww.param]
[/@ww.text]

[@eccc.editChainConfigurationPage descriptionKey=repositoryDescription  plan=immutablePlan  selectedTab='repository'  titleKey='repository.title']
    [#include "/build/common/configureChangeDetectionRepository.ftl"]
[/@eccc.editChainConfigurationPage]
