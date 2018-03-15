[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
<html>
<head>
	<title>[@ww.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='buildExpiry.heading' /]</h1>

    <p class="description">
        [@ww.text name="buildExpiry.description"/]
    </p>
    [@ww.form
        id='buildExpiryForm'
        action='buildExpiry.action'
        cancelUri='/admin/buildExpiry!read.action'
        submitLabelKey='global.buttons.update'
        titleKey='buildExpiry.form.title'
        descriptionKey='buildExpiry.cronSection.description'
    ]

        [@dj.cronBuilder name='custom.buildExpiryConfig.cronExpression' /]


        [@ui.bambooSection titleKey="buildExpiry.defaultConfigSection.title"]
            [@ui.displayText]
                [@ww.text name="buildExpiry.defaultConfigSection.description"]
                    [@ww.param][@help.href pageKey="expiry.global"/][/@ww.param]
                [/@ww.text]
            [/@ui.displayText]
            [@ww.checkbox name='custom.buildExpiryConfig.enabled' labelKey="buildExpiry.global.enabled" toggle="true" /]
            [@ui.bambooSection dependsOn='custom.buildExpiryConfig.enabled' showOn='true']
                [#include "/admin/build/editBuildExpiryForm.ftl" /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>
