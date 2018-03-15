[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.ConfigureGlobalRepositoryPermissions" --]
[#import "/fragments/permissions/permissions.ftl" as permissions/]
[@ww.text id="title" name="repository.shared.edit.permissions.title"]
    [@ww.param][#if repositoryData??]${repositoryData.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]
<html>
<head>
[@ui.header pageKey=title title=true/]
</head>
<body>
[@ui.header pageKey=title descriptionKey="repository.shared.edit.permissions.description"/]
[@ww.url id="cancelUri" namespace='admin' action='configureGlobalRepositories'  repositoryId=repositoryId/]
[@ww.form action='updateGlobalRepositoryPermissions' submitLabelKey='global.buttons.update' id='permissions' cancelUri='${cancelUri}' cssClass='top-label']
    [@permissions.permissionsEditor entityId=repositoryId anonymousAllowed=false /]
    [@ww.hidden name='repositoryId' /]
[/@ww.form]
</body>
</html>
