[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.migration.Backup" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.migration.Backup" --]
<html>
<head>
    [@ui.header pageKey="backup.heading" title=true /]
</head>

<body>
[@ui.header pageKey="backup.heading" /]
<p>[@ww.text name='backup.description' /]</p>

[@ww.form id='importForm' action='configureBackups.action' submitLabelKey='global.buttons.edit' cancelUri='/admin/administer.action' titleKey='backup.form.title']

    [#if backupConfigured='false']
        [@ui.messageBox type="info" titleKey="backup.notConfigured" /]
    [#elseif backupDisabled='true' ]
        [@ui.messageBox type="warning" titleKey="backup.disabled.message" /]
    [#else]
        [@ww.label labelKey='backup.path' name='backupPath' /]
        [@ww.label labelKey='backup.example' name='fileExample' /]
        [@dj.cronDisplay "backupCronExpression" /]
        [#assign nextFireTimeText ]
            [#if nextFireTime?has_content]
                ${(nextFireTime?datetime)}
            [#else]
                [@ww.text name='backup.nextFireTime.none' /]
            [/#if]
        [/#assign]
        [@ww.label labelKey='backup.nextFireTime' value='${nextFireTimeText}' /]
        [@ww.label labelKey='backup.artifacts' name='exportArtifacts' /]
        [@ww.label labelKey='backup.awaitJobCompletion' name='awaitJobCompletion' /]
    [/#if]
[/@ww.form]

</body>
</html>