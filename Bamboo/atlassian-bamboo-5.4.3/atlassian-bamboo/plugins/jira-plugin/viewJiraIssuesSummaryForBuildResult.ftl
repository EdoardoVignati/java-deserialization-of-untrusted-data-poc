[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues" --]
[#import 'viewJiraIssueComponents.ftl' as jiraComponents /]

[@jiraComponents.jiraIssueSummary resultsSummary=resultsSummary linkedJiraIssues=linkedJiraIssues maxIssues=maxIssues!2 /]