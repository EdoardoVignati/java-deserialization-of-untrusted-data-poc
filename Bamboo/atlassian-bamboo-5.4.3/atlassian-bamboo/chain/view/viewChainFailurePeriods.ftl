[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
<html>
<head>
    [@ui.header pageKey='chain.failures.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="failures"/>
</head>
<body>
[#import "/fragments/statistics/recentFailures.ftl" as recentFailures]
[@recentFailures.showSummary maxResults=-1/]
</body>
</html>
