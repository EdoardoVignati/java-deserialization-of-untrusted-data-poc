[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ajax.ViewPlanStatusByJiraKey"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ajax.ViewPlanStatusByJiraKey" --]

[#--used for jira bamboo plugin, when the by plan status tab is selected --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
<html>
<head>
   <title>
        Plans related to JIRA Issue
    </title>
    <link rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/buildResultsList.css" type="text/css" />
</head>
<body>
[#if resultsList?has_content]
    <ol class="build_result_list">
    [#list resultsList as summary]
        [@planList.showBuildResultSummary summary=summary/]
    [/#list]
    </ol>
[#else]
    <p>
        [@ww.text name='jira.issues.none' /]
    </p>
[/#if]

</body>
</html>