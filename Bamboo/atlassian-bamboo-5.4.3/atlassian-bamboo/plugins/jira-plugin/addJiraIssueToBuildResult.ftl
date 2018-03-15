[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.EditJiraIssues"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.EditJiraIssues" --]

[#if user??]
    [@ww.form
        action="addJiraIssue"
        namespace="/build"
        submitLabelKey='global.buttons.update'
        cancelUri='/build/viewJiraIssues.action?buildKey=${immutablePlan.key}&buildNumber=${resultsSummary.buildNumber}']

        [@ww.textfield
            id='issueKeyInput'
            labelKey='buildResult.jiraIssues.addLinked.label'
            name='issueKeyInput'
            descriptionKey='buildResult.jiraIssues.addLinked.description' /]

        [@ww.hidden name='buildKey' /]
        [@ww.hidden name='buildNumber' /]
    [/@ww.form]

[#else]
    <p>[@ww.text name='buildResult.jiraIssues.addLinked.permissionError' /]</p>
[/#if]
