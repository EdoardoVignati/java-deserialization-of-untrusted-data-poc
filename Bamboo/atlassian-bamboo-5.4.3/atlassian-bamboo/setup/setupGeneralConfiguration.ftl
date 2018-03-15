[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupGeneralConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupGeneralConfiguration" --]
<html>
<head>
	<title>[@ww.text name='setup.install.configuration.title' /]</title>
    <meta name="step" content="1">
</head>

<body>

[@ui.header pageKey='setup.install.configuration.title' descriptionKey='setup.install.configuration.description' headerElement="h2" /]

[@ww.form action="validateGeneralConfiguration"
    id="setupGeneralConfiguration"
    name="setupGeneralConfiguration"
    submitLabelKey='global.buttons.continue' cssClass="long-label" ]

   [@ui.bambooSection titleKey='config.instance' ]
        [@ww.textfield name='instanceName' labelKey='config.instance.name'/]
   [/@ui.bambooSection]
   [@ui.bambooSection titleKey='config.server']
        [#assign baseUrlDescription]
            [@ww.text name='config.server.baseUrl.description' ]
                [@ww.param]${baseUrl}[/@ww.param]
            [/@ww.text]
        [/#assign]
        [@ww.textfield labelKey='config.server.baseUrl' name="baseUrl" required="true" description=baseUrlDescription value=baseUrl! cssClass="long-field"  /]
   [/@ui.bambooSection]
   [@ui.bambooSection titleKey='setup.install.system.paths.section']
        [@ww.textfield labelKey='setup.install.configuration.directory' name="configDir" required="true"  cssClass="long-field" /]
        [@ww.textfield labelKey='setup.install.build.directory' name="buildDir" required="true"   cssClass="long-field" /]
        [@ww.textfield labelKey='config.server.buildDirectory' name="buildWorkingDir" required="true"   cssClass="long-field" /]
        [@ww.textfield labelKey='config.server.artifactsDirectory' name="artifactsDir" required="true"   cssClass="long-field" /]
   [/@ui.bambooSection]
    [#if remoteAllowed]
       [@ui.bambooSection titleKey='setup.install.brokerUrl.section']
            [@ww.textfield labelKey='setup.install.brokerUrl' name="brokerUrl" required="true" descriptionKey='setup.install.brokerUrl.description'  cssClass="long-field" /]
       [/@ui.bambooSection]
    [/#if]
[/@ww.form]
</body>
</html>