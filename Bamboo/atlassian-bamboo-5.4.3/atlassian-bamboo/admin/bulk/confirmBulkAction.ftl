[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
<html>
<head>
	<title>[@ww.text name='bulkAction.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='bulkAction.heading' /]</h1>

    [@ui.messageBox type='warning' titleKey='bulkAction.confirm.warning'/]

    [#assign buildsToBeUpdatedDescription]
        [#if bulkAction.hasUpdates()]
            [@ww.text name='bulkAction.confirm.plans' /]
        [/#if]
    [/#assign]

    [@ww.form titleKey='bulkAction.confirm.title'
              description=buildsToBeUpdatedDescription
              action='bulkPlan' namespace='/admin'
              submitLabelKey='global.buttons.confirm'
              backLabelKey='global.buttons.back'              
              cancelUri='/admin/viewAvailableBulkAction.action' ]

        [@ww.action name="${bulkAction.viewUpdatedAction.actionName}" namespace="${bulkAction.viewUpdatedAction.namespace}" executeResult="true"  ]
        [/@ww.action]
    
        <table class="aui">
            <thead>
                <tr>
                    <th>[@ww.text name='bulkAction.tableHeading.plan' /]</th>
                    <th>${bulkAction.changedItem}</th>
                </tr>
            </thead>
            <tbody>

            [#list selectedPlans as plan]
                <tr>
                    <td class='bulkEditExistingView'>
                        <a href="${req.contextPath}/browse/${plan.key}">
                        ${plan.name} <em>(${plan.key})</em>
                        </a>
                    </td>
                    <td class='bulkEditExistingView'>
                        [@ww.action name="${bulkAction.viewAction.actionName}" namespace="${bulkAction.viewAction.namespace}" executeResult="true"  ]
                            [@ww.param name="buildKey" value="'${plan.key}'"/]
                        [/@ww.action]
                    </td>
                </tr>
            [/#list]
            </tbody>

        </table>

    [#list params.keySet() as paramKey]
        [#if paramKey = "selectedBuilds"]
            [#list params.get(paramKey) as selectedBuild]
                [@ww.hidden name='selectedBuilds' value=selectedBuild /]
            [/#list]
        [#else]
            [@ww.hidden name='${paramKey}' value=params.get(paramKey) /]
        [/#if]
    [/#list]
    
    [/@ww.form]
</body>
</html>
