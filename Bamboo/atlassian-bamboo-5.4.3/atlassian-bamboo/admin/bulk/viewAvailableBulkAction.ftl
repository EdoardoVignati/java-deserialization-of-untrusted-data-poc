[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
<html>
<head>
	<title>[@ww.text name='bulkAction.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='bulkAction.heading' /]</h1>
    <p>[@ww.text name='bulkAction.description' /]</p>

    [@ww.form action='chooseBulkAction' namespace='/admin'
              titleKey='bulkAction.selectAction.title'
              submitLabelKey='global.buttons.next'
    ]

        [@ww.select labelKey='bulkAction.selectAction.label' name='selectedBulkActionKey'
                    list=availableBulkActions?sort_by('title')
                    listKey='key' listValue='title'
                    descriptionKey='bulkAction.selectField.description']
        [/@ww.select]

    [/@ww.form]
</body>
</html>