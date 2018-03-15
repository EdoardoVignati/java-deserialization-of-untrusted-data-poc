[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
[@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.variables"/>
</head>
<body>
[@ui.header pageKey="branch.config.variables.heading" descriptionKey="branch.config.variables.description"/]

[@ww.url id="createVariableUrl" namespace="/build/admin/ajax" action="createPlanVariable" planKey=immutablePlan.key /]
[@ww.url id="deleteVariableUrl" namespace="/build/admin/ajax" action="deletePlanVariable" planKey=immutablePlan.key variableId="VARIABLE_ID"/]
[@ww.url id="updateVariableUrl" namespace="/build/admin/ajax" action="updatePlanVariable" planKey=immutablePlan.key/]

[@variables.configureVariables
    id="planVariables"
    variablesList=action.variables
    createVariableUrl=createVariableUrl
    deleteVariableUrl=deleteVariableUrl
    updateVariableUrl=updateVariableUrl
    availableVariables=inheritedVariables
    overriddenVariablesMap=overriddenVariablesMap
    tableId="branch-variable-config"/]
</body>