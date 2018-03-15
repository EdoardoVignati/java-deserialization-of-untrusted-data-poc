[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTable" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTable" --]
[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]
[@showBuildResultsTable
    pager=pager
    sort=sort
    showAgent=showAgent     
    showOperations=false
    showArtifacts=false
    showFullBuildName=!singlePlan/]
