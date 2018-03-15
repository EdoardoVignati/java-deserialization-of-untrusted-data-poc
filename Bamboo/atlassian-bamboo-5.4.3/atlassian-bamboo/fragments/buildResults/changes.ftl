[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]

[#import "/lib/resultSummary.ftl" as ps]
[@ps.showChanges buildResultsSummary = action.resultsSummary /]
