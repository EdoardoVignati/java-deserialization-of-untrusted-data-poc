[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]

<html>
<head>
    <title>[@ww.text name='admin.concurrentBuilds.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
<h1>[@ww.text name='admin.concurrentBuilds.title' /]</h1>

<p>[@ww.text name='admin.concurrentBuilds.description' /]</p>

<p>[@ww.text name='admin.concurrentBuilds.page.description' /]</p>

[#if concurrencyConfig.enabled]
    [@ww.text name='admin.concurrentBuilds.number.view' id='adminConcurrentBuildsViewDescription']
        [@ww.param]${numberConcurrentBuilds}[/@ww.param]
    [/@ww.text]
    [@ui.bambooPanel titleKey='admin.concurrentBuilds.view.title' description=adminConcurrentBuildsViewDescription /]
    [@ww.form action="editConcurrentBuildConfig" id="editConcurrentConfigForm" submitLabelKey='global.buttons.edit' cssClass='top-label']
        [@ww.param name='buttons']
            [@cp.displayLinkButton buttonId="disableButton" buttonLabel="global.buttons.disable" buttonUrl="${req.contextPath}/admin/disableConcurrentBuildConfig.action" mutative=true/]
        [/@ww.param]
    [/@ww.form]
[#else]
    [@ui.bambooPanel titleKey='admin.concurrentBuilds.view.title' descriptionKey='admin.concurrentBuilds.disabled' /]
    [@ww.form action="editConcurrentBuildConfig" id="enableConcurrentConfigForm" submitLabelKey='global.buttons.enable' cssClass='top-label' /]
[/#if]

</body>
