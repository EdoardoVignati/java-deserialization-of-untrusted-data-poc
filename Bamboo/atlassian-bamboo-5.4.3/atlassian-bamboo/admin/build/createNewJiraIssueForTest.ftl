[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.jira.CreateNewJiraIssueForTestAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.jira.CreateNewJiraIssueForTestAction" --]

[#import "createNewJiraIssueForm.ftl" as cnjif]
[@cnjif.createNewJiraIssueForm "executeCreateNewJiraIssueForTest"]
    [@ww.hidden name='testCaseId' /]
[/@cnjif.createNewJiraIssueForm]
