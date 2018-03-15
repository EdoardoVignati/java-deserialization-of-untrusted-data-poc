[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.edit.title' /]</title>
    <meta name="decorator" content="adminpage">
    ${webResourceManager.requireResourcesForContext("ace.editor")}
</head>

<body>
    <h1>[@ww.text name='elastic.image.configuration.edit.heading' /] - ${configurationName?html}</h1>
    <p>[@ww.text name='elastic.image.configuration.edit.description' /]</p>

    [@ela.editElasticInstance mode="edit" /]
</body>
</html>
