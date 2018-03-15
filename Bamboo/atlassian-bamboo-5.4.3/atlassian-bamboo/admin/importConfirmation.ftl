[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.migration.Import" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.migration.Import" --]
<html>
<head>
    <title>[@ww.text name='import.title' /]</title>
</head>

<body>
<h1>[@ww.text name='import.heading' /]</h1>

[@ui.messageBox type='warning' titleKey='import.warning.confirm'/]

[#assign importConfirmDescription]
    [@ww.label labelKey='import.path' name='path' /]
    [#if backupSelected ]
        [@ww.label labelKey='import.backup.path' name='backupCanonicalPath' /]
    [/#if]
[/#assign]
    [@ww.form id='importForm'
              action='import'
              submitLabelKey='global.buttons.confirm'
              titleKey='import.form.title'
              description=importConfirmDescription
              cancelUri='/admin/import!default.action']
        [@ww.hidden name='path' value=path /]
        [@ww.hidden name='backupSelected' value=backupSelected /]
        [@ww.hidden name='backupPath' value=backupPath /]
        [@ww.hidden name='backupFileName' value=backupFileName /]    
        [@ww.hidden name='hotSwapSelected' value=hotSwapSelected /]
        [@ww.hidden name='clearArtifacts' value=clearArtifacts /]
    [/@ww.form]
</body>
</html>