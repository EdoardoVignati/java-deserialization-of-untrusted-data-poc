[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.jira.LinkTestToJiraIssueAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.jira.LinkTestToJiraIssueAction" --]
[@ww.form action="executeLinkTestToJiraIssue"
        namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        submitLabelKey="build.testResult.linkWithJiraIssue.link"]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='buildNumber' /]
    [@ww.hidden name='returnUrl' /]
    [@ww.hidden name='testCaseId' /]

    [@ww.textfield name="manualIssueKey" labelKey="build.testResult.linkWithJiraIssue.issueKey"/]

[/@ww.form]
