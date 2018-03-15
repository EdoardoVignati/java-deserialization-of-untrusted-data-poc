[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/plan/displayBuildSummariesBrief.ftl" as planList]
<html>
<head>
    <title>Build Status All</title>
</head>
<body>
    [@planList.displayBuildSummariesBrief builds=plans /]
</body>
</html>