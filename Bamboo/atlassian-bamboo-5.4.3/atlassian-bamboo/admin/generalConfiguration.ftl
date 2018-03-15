[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigurationAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigurationAction" --]
<html>
<head>
	<title>[@ww.text name='config.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='config.heading' /]</h1>
	<p>[@ww.text name='config.description' /]</p>

    [@ww.actionmessage /]
    [@ui.actionwarning /]

    [@ww.form action="configure"
              id="configurationForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/administer.action'
              showActionMessages='false'
              showActionWarnings='false'
    ]
        [@ui.bambooSection titleKey='config.instance' ]
            [@ww.textfield name='instanceName' labelKey='config.instance.name' required=true /]
        [/@ui.bambooSection]

        [#if featureManager.changeBaseUrlAllowed]
            [@ui.bambooSection titleKey='config.server']
                [#assign baseUrlDescription]
                    [@ww.text name='config.server.baseUrl.description' ]
                        [@ww.param]${defaultBaseUrl}[/@ww.param]
                    [/@ww.text]
                [/#assign]
                [@ww.textfield labelKey='config.server.baseUrl' name="baseUrl" required="true" description=baseUrlDescription value=baseUrl! size=40 /]
            [/@ui.bambooSection]
        [/#if]
        [@ui.bambooSection titleKey='config.broker']
            [@ww.textfield name='brokerUrl' labelKey='config.options.brokerUrl' cssClass='long-field' /]
            [@ww.textfield name='brokerClientUrl' labelKey='config.options.brokerClientUrl' cssClass='long-field' /]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey='config.options']
            [@ww.textfield name='dashboardPageSize' labelKey='config.server.dashboardPageSize.name' descriptionKey='config.server.dashboardPageSize.description' required=true /]

            [@ww.textfield name='branchDetectionInterval' labelKey='config.server.branchDetectionInterval.name' descriptionKey='config.server.branchDetectionInterval.description' required=true /]

            [#if featureManager.gzipCompressionSupported]
                [@ww.checkbox id='gzipCompression_id' labelKey='config.options.gzip' descriptionKey='config.options.gzip.description' name='gzipCompression' value=gzipCompression  /]
            [/#if]

            [@ww.checkbox id='enableGravatar_id' labelKey='config.options.gravatar' descriptionKey="config.options.gravatar.description" name="enableGravatar" toggle='true'/]
            [@ui.bambooSection dependsOn='enableGravatar' showOn="true" id="changeGravatarUrl"]
                [@ww.textfield id='gravatarServerUrl_id' name='gravatarServerUrl' labelKey='config.server.gravatarUrlField.name' descriptionKey='config.server.gravatarUrlField.description' required=true /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]


    [/@ww.form]
</body>
</html>