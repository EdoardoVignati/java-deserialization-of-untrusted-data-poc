[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/plan/displayBuildSummariesBrief.ftl" as planList]

<html>
<head>
    <title>Build Summary Favourites</title>
</head>
<body>
[#if user?exists && favouriteBuilds?has_content]
    [@planList.displayBuildSummariesBrief builds=favouriteBuilds /]
[#else]
<p>You do not have any favourite builds</p>
[/#if]
</body>
</html>