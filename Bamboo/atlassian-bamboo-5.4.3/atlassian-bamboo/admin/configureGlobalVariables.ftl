[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.variable.ConfigureGlobalVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.variable.ConfigureGlobalVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
    [@ui.header pageKey="globalVariables.title" title=true/]
</head>

<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="variables.howtheywork"][@ww.text name="variables.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey="globalVariables.heading" descriptionKey="globalVariables.description"/]

[@ww.url id="createVariableUrl" namespace="/admin" action="createGlobalVariable" /]
[@ww.url id="deleteVariableUrl" namespace="/admin" action="deleteGlobalVariable" variableId="VARIABLE_ID"/]
[@ww.url id="updateVariableUrl" namespace="/admin" action="updateGlobalVariable" /]

[@variables.configureVariables
    id="globalVariables"
    variablesList=action.variables
    createVariableUrl=createVariableUrl
    deleteVariableUrl=deleteVariableUrl
    updateVariableUrl=updateVariableUrl
    overriddenVariablesMap=overriddenVariablesMap
    tableId="global-variable-config"/]

</body>
</html>
