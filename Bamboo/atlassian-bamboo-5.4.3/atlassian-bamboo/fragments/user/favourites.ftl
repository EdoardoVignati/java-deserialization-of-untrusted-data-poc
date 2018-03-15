[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/plan/displayBuildPlansList.ftl" as planList]
[#if favouriteBuilds?has_content]
    [@planList.displayBuildPlansList id='favourites' builds=favouriteBuilds returnUrl='${req.contextPath}/myBamboo.action' /]
[#else]
    You currently have selected no favourite builds. Click on the star against a build to mark it as your favourite.
[/#if]        