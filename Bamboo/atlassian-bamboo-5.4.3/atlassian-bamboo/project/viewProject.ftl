[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

<html>
<head>
    [@ui.header pageKey='project.summary.title' object='${project.name}' title=true /]
</head>

<body>

[#if !plans?has_content]
    [#if !(fn.hasAdminPermission() && ec2ConfigurationWarningRequired)]
        <p>
            [@ww.text name='project.no.plans'/]
        </p>
        <p>
            <a id="createNewPlanLink" href="${req.contextPath}/build/admin/create/newPlan.action?existingProjectKey=${project.key}">[#rt]
                                    [@ui.icon type="plan-create" showTitle=false /][#t]
                                    [@ww.text name='plan.create.new.title' /][#t]
            </a>[#lt]
        </p>
    [/#if]
[#else]
    [@planList.displayWideBuildPlansList builds=plans showProject=false/]
[/#if]
[#include "/fragments/showEc2Warning.ftl"]

</body>
</html>