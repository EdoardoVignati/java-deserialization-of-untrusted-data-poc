[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.migration.Export" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.migration.Export" --]
<html>
<head>
    <title>[@ww.text name='export.title' /]</title>
    <meta name="decorator" content="export">
</head>

<body>
<h1>[@ww.text name='export.heading' /]</h1>

    [@ui.messageBox titleKey='export.warning' /]
    [#assign exportPathDescription]
        [#if pathManipulationAllowed]
            [@ww.text name='export.path.description' ]
                [@ww.param]${defaultMigrationLocation}[/@ww.param]
            [/@ww.text]
        [/#if]
    [/#assign]
    [@ww.form id='exportForm' action='export' submitLabelKey='export.button' titleKey='export.form.title' descriptionKey='export.description']
        [#if pathManipulationAllowed]
            [@ww.textfield labelKey='export.path' description=exportPathDescription name='path' /]
        [#else]
            [@ww.label labelKey='export.pathinfo' name='path' /]
        [/#if]
        [@ww.textfield labelKey='export.filename' name='filename' cssClass="long-field" /]
        [@ww.checkbox labelKey='export.results' name='exportResults' toggle=true/]
        [@ui.bambooSection dependsOn='exportResults' showOn=true]
            [@ww.checkbox labelKey='export.artifacts' name='exportArtifacts' /]
            [@ww.checkbox labelKey='export.buildlogs' name='exportBuildLogs' /]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>
