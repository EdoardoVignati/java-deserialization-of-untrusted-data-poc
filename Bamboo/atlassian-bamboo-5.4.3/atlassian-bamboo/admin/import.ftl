[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.migration.Import" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.migration.Import" --]
<html>
<head>
    <title>[@ww.text name='import.title' /]</title>
</head>

<body>
<h1>[@ww.text name='import.heading' /]</h1>

[@ui.messageBox type='warning' titleKey='import.warning' /]

[#assign importPathDescription]
    [@ww.text name='import.path.description' ]
        [@ww.param]${defaultExportPath}[/@ww.param]
    [/@ww.text]
[/#assign]
[#assign backupPathDescription]
    [#if pathManipulationAllowed]
    [@ww.text name='import.backup.path.description' ]
        [@ww.param]${defaultMigrationLocation}[/@ww.param]
    [/@ww.text]
    [/#if]
[/#assign]
[@ww.form id='importForm' action='import!confirm.action' submitLabelKey='global.buttons.import' titleKey='import.form.title' descriptionKey='import.description']
    [@ww.textfield labelKey='import.path' name='path' description=importPathDescription cssClass="long-field" /]
    [@ww.checkbox labelKey='import.backup' name='backupSelected' toggle='true' /]
    [@ui.bambooSection dependsOn='backupSelected' showOn='true' ]
        [#if pathManipulationAllowed]
            [@ww.textfield labelKey='import.backup.path' description=backupPathDescription name='backupPath' /]
        [#else]
            [@ww.label labelKey='import.backup.path' name='backupPath' /]
        [/#if]
        [@ww.textfield labelKey='import.backup.filename' name='backupFileName' /]
    [/@ui.bambooSection]

    [@ww.checkbox labelKey='import.clearArtifacts' name='clearArtifacts' /]
    [@ww.checkbox labelKey='import.hotSwap' name='hotSwapSelected' /]
[/@ww.form]
</body>
</html>