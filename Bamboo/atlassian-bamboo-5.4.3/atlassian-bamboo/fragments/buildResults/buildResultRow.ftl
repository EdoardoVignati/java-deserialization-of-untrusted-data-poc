[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.ChainResultProviderAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.ChainResultProviderAction" --]
[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]
[#-- See displayPlanSummary.ftl--]
<table>
[#list buildResults as buildResult]
<tr>
[@showBuildResultRow
    buildResult=buildResult
    showAgent=false
    showOperations=false
    showArtifacts=false
    showDuration=false
    useRelativeDate=true
    showFullBuildName=false/]
</tr>
[/#list]
</table>
