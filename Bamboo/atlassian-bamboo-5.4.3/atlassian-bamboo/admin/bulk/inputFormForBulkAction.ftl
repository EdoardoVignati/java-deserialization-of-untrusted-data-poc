[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
<html>
<head>
    [@ui.header pageKey="bulkAction.title" title=true /]
    <meta name="decorator" content="adminpage">
</head>
<body>
    [@ui.header pageKey="bulkAction.heading" /]
    [#assign formDescriptionText]
        [#if (('${bulkAction.class.simpleName}' == 'EnablePlanBulkAction') || ('${bulkAction.class.simpleName}' == 'DisablePlanBulkAction'))]
            [@ww.text name='bulkAction.performAction.enabledisable.description' /]
        [#else]
            [@ww.text name='bulkAction.performAction.description']
                [@ww.param]${bulkAction.changedItem}[/@ww.param]
            [/@ww.text]
        [/#if]
    [/#assign]

    [@ww.form action='confirmBulkAction' namespace='/admin'
              titleKey='bulkAction.performAction.title'
              descriptionKey='${formDescriptionText}'
              submitLabelKey='global.buttons.next'
              backLabelKey='global.buttons.back'
              cancelUri='/admin/viewAvailableBulkAction.action'
              showActionErrors='false'
    ]
        [#if selectedPlans?has_content]
            <table class="aui">
                <thead>
                    <tr>
                        <th></th>
                        <th>[@ww.text name='bulkAction.tableHeading.plan' /]</th>
                        <th>${bulkAction.changedItem}</th>
                    </tr>
                </thead>
                <tbody>
                    [#list selectedPlans as plan]
                        <tr>
                            <td>
                                [@ww.checkbox name="selectedBuilds" fieldValue="${plan.key}" theme="simple" checked="true" /]
                            </td>
                            <td class='bulkEditExistingView'>
                                <a href="${req.contextPath}/browse/${plan.key}">
                                ${plan.name} <em>(${plan.key})</em>
                                </a>
                            </td>
                            <td class='bulkEditExistingView'>
                                [@ww.action name="${bulkAction.viewAction.actionName}" namespace="${bulkAction.viewAction.namespace}" executeResult="true"  ]
                                    [@ww.param name="planKey" value="'${plan.key}'"/]
                                [/@ww.action]
                            </td>
                        </tr>
                    [/#list]
                </tbody>
            </table>
        [#else]
            [@ui.messageBox type="error" titleKey="bulkAction.result.error" /]
        [/#if]

        [@ww.action name="${bulkAction.editSnippetAction.actionName}" namespace="${bulkAction.editSnippetAction.namespace}" executeResult="true"  /]

        [@ww.hidden name="selectedBulkActionKey" /]
        [@ww.hidden name="mode" value="save" /]
    [/@ww.form]
</body>
</html>