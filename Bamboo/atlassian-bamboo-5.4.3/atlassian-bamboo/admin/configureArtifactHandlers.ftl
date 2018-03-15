[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]

<html>
<head>
    <title>[@ww.text name='webitems.system.admin.plugins.artifactHandlers' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
    <h1>[@ww.text name='webitems.system.admin.plugins.artifactHandlers' /]</h1>

    [@ww.form action="configureArtifactHandlers!save" namespace="/admin" submitLabelKey="global.buttons.update" ]
        [#list artifactHandlers as artifactHandler]
            [#assign artifactHandlerModuleDescriptor = artifactHandler.moduleDescriptor/]
            [#assign editHtml = action.getEditHtml(artifactHandler)!""/]
            [#if editHtml?has_content]
                <h2>${fn.resolveName(artifactHandlerModuleDescriptor.name, artifactHandlerModuleDescriptor.i18nNameKey)}</h2>
                <p>${fn.resolveName(artifactHandlerModuleDescriptor.description, artifactHandlerModuleDescriptor.descriptionKey)}</p>
                ${editHtml}
            [/#if]
        [/#list]
    [/@ww.form]
</body>
</html>