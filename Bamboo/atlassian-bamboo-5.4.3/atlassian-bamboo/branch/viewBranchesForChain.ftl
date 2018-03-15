[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.ViewChainBranches" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.ViewChainBranches" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

<html>
<head>
    [@ui.header pageKey='branch.title' object=immutableChain.name title=true /]
    <meta name="tab" content="branches"/>
</head>

<body>
[@ui.header pageKey='chain.branches.title.long' /]

[#if immutableChainBranches?has_content]
    [@planList.displayWideBuildPlansList builds=immutableChainBranches showProject=false/]
[#else]
    <p>[@ww.text name="branch.none" ]
        [@ww.param][@ww.url action="configureBranches" namespace="/chain/admin/config" planKey=planKey /][/@ww.param]
    [/@ww.text]</p>
[/#if]
</body>
</html>