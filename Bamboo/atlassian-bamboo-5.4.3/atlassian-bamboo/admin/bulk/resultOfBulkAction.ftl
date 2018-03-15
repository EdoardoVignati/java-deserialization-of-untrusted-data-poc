[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
<html>
<head>
    <title>[@ww.text name='bulkAction.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
<h1>[@ww.text name='bulkAction.heading' /]</h1>
[@ww.form action='bulkPlan' namespace='/admin'
titleKey='bulkAction.result.title'
descriptionKey='bulkAction.result.description'
]
    [@ww.param name='buttons']
        [@cp.displayLinkButton buttonId="cancelButton" buttonLabel="global.buttons.done" buttonUrl='${req.contextPath}/admin/viewAvailableBulkAction.action' /]
    [/@ww.param]

<table class="aui">
    <thead>
    <tr>
        <th>[@ww.text name='bulkAction.tableHeading.plan' /]</th>
        <th>[@ww.text name='bulkAction.tableHeading.result' /]</th>
        <th>${bulkAction.changedItem}</th>
    </tr>
    </thead>
    <tbody>
        [#list results.entrySet() as entry]
            [#assign plan = entry.key /]
            [#assign nestedAction = entry.value /]
        <tr>
            <td>
                <a href="${req.contextPath}/browse/${plan.key}">
                ${plan.name} <em>(${plan.key})</em>
                </a>
            </td>
            <td>
                [#if nestedAction.totalErrors > 0]
                    <span class="failedLabel">[@ww.text name='bulkAction.result.failure' /]</span>
                    <ul class="failedLabel standard">
                        [#list nestedAction.formattedActionErrors as error]
                            <li>${error}</li>
                        [/#list]
                        [#list nestedAction.fieldErrors.entrySet() as errorEntry]
                            <li>
                                [#list errorEntry.value as fieldError]
                                ${fieldError}<br/>
                                [/#list]
                            </li>
                        [/#list]
                    </ul>
                [#else]
                    <span class="successfulLabel">[@ww.text name='bulkAction.result.success' /]</span>
                [/#if]
            </td>
            <td class='bulkEditExistingView'>
                [@ww.action name="${bulkAction.resultAction.actionName}" namespace="${bulkAction.resultAction.namespace}" executeResult="true"  ]
                                [@ww.param name="buildKey" value="'${plan.key}'"/]
                                [@ww.param name="totalBulkActionErrors" value="${nestedAction.totalErrors}"/]
                            [/@ww.action]
            </td>
        </tr>
        [/#list]
    </tbody>
</table>
[/@ww.form]
</body>
</html>