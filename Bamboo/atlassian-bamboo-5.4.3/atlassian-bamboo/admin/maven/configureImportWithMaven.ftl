[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCheckoutPomAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCheckoutPomAction" --]
<html>
<head>
    [@ui.header pageKey='plan.create.maven.title' title=true /]
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
    [@ui.header pageKey='plan.create.maven.title' descriptionKey='plan.create.maven.description'/]

    [#assign builders=availableMavenBuilders /]

    [#if builders?has_content]
        [@ww.form action='importMavenPlanExecutePomCheckout' namespace='/build/admin/create'
                  method="post" enctype="multipart/form-data"
                  titleKey='importWithMaven.pom.title'
                  submitLabelKey='global.buttons.import'
                  cancelUri='start.action'
        ]
            [#assign repositoryList = filteredRepositories /]

            [@ww.select labelKey='repository.type' name='selectedRepository' toggle='true' list=repositoryList listKey='key' listValue='name']
            [/@ww.select]

            [#list repositoryList as repository]
                [@ui.bambooSection dependsOn='selectedRepository' showOn='${repository.key}']
                    ${repository.mavenPomAccessor.getMavenPomCheckoutAccessEditHtml(buildConfiguration)!}
                [/@ui.bambooSection]
            [/#list]

        [/@ww.form]
    [#else]
        [@ui.messageBox type="error"]
            [#if fn.hasAdminPermission()]
               [@ww.text name='importWithMaven.error.missingMavenBuilder']
                   [@ww.param][@ww.url action='configureSharedLocalCapabilities' namespace='/admin/agent' /][/@ww.param]
               [/@ww.text]
            [#else]
                [@ww.text name='importWithMaven.error.missingMavenBuilder.nonAdmin'/]
            [/#if]
        [/@ui.messageBox]
    [/#if]

</body>
</html>
