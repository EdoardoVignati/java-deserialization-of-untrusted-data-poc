[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.migration.Backup" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.migration.Backup" --]
<html>
<head>
    <title>[@ww.text name='backup.heading' /]</title>
</head>

<body>
    <h1>[@ww.text name='backup.heading' /]</h1>
    <p>[@ww.text name='backup.description' /]</p>

    [@ww.form id='backupForm' action='saveBackups.action' submitLabelKey='global.buttons.update' cancelUri='/admin/viewBackups.action' titleKey='backup.form.title']
        [@ui.messageBox type='warning' titleKey='backup.warning'/]

        [@ww.checkbox  name='backupDisabled' labelKey='backup.disabled'  toggle='true'/]
        [@ui.bambooSection dependsOn='backupDisabled' showOn='false']
            [@ww.checkbox  name='exportArtifacts' labelKey='backup.artifacts' /]
            [@ww.checkbox  name='awaitJobCompletion' labelKey='backup.awaitJobCompletion' /]
            [#if pathManipulationAllowed]
                [@ww.textfield labelKey='backup.path' name='backupPath' /]
            [#else]
                [@ww.label labelKey='backup.path' name='backupPath' /]
            [/#if]                            
            [@ww.textfield labelKey='backup.prefix' name='filePrefix' /]
            [@ww.textfield labelKey='backup.format' name='fileDateFormat' /]
            [@dj.cronBuilder "backupCronExpression" /]
        [/@ui.bambooSection ]
[/@ww.form]

</body>
</html>
