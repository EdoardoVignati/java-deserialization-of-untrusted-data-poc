[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]

<html>
<head>
    <title>[@ww.text name='bulkAction.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>

    <h1>[@ww.text name='bulkAction.heading' /]</h1>
    [@ww.form titleKey='bulkAction.selectPlan.title'
          descriptionKey='bulkAction.selectPlan.description'
          action='choosePlansForBulkAction'
          namespace='/admin'
          submitLabelKey='global.buttons.next'
          backLabelKey='global.buttons.back'
          cancelUri='/admin/viewAvailableBulkAction.action'
          cssClass="top-label"
    ]
        [@cp.displayBulkActionSelector  bulkAction=bulkAction
                                        checkboxFieldValueType='key'
                                        planCheckboxName='selectedBuilds'
                                        repoCheckboxName='selectedRepositories'/]

    [/@ww.form]
</body>
</html>
