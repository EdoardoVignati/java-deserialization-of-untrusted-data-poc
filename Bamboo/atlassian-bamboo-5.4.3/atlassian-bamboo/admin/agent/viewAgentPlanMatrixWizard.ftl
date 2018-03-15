[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrixWizard" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrixWizard" --]
<html>
<head>
    <title>[@ww.text name='agent.matrix.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

[@ui.header pageKey='agent.matrix.heading' /]
[@ww.form titleKey='agent.matrix.selector.title'
    descriptionKey='agent.matrix.selector.description'
    action='viewAgentPlanMatrix'
    namespace='/admin/agent'
    submitLabelKey='global.buttons.submit'
    cancelUri='/admin/agent/viewAgentPlanMatrixWizard.action'
]
    [@cp.displayBulkActionSelector
        bulkAction=action
        checkboxFieldValueType='key'
        planCheckboxName='selectedBuilds'
        repoCheckboxName='selectedRepositories'/]
[/@ww.form]


</body>
</html>