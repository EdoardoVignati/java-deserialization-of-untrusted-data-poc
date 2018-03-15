[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ListChainResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ListChainResults" --]
[#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(immutablePlan)/]
<html>
<head>
    [@ui.header pageKey=planI18nPrefix+'.completedResults.title.long' object='${immutableChain.name}' title=true /]
    <meta name="tab" content="results"/>
</head>
<body>

[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]
[@ui.header pageKey=planI18nPrefix+'.completedResults.title.long' /]
[@showBuildResultsTable
    pager=pager
    sort=false
    showAgent=false
    showOperations=true
    showArtifacts=false
    showFullBuildName=false
    useRelativeDate=true /]

<ul>
 <li>[@ww.text name="plan.footer.colorCodes"/]</li>
 <li>[@ww.text name="plan.footer.buildCount"][@ww.param value=immutableChain.lastBuildNumber /][/@ww.text]</li>

 [#if immutableChain.buildDefinition.buildStrategies?has_content]
    [#if immutableChain.buildDefinition.buildStrategies.size()==1]
        [#assign buildStrategy='${immutableChain.buildDefinition.buildStrategies.get(0).key}' /]
        [#if buildStrategy='schedule' || buildStrategy='daily']
             <li>[@ww.text name="plan.footer.trigger.scheduled"/]</li>
        [#else]
             <li>[@ww.text name="plan.footer.trigger.repository.noName"/]</li>
        [/#if]
    [#else]
        <li>[@ww.text name="plan.footer.trigger.multiple"/]</li>
    [/#if]
 [#else]
    <li>[@ww.text name="plan.footer.trigger.manual"/]</li>
 [/#if]
 [#--  @TODO: RSS feed links go here but RSS for chain not yet done (?). --]
</ul>
</body>
</html>
