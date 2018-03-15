[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#if smtpMailServer?exists]
    [#assign editMode = true /]
    [#assign cancelUri='/admin/viewMailServer.action' /]
[#else]
    [#assign editMode = false /]
    [#assign cancelUri='/admin/administer.action' /]
[/#if]
<html>
<head>
    <title>[@ww.text name='config.email.title' /]</title>
</head>
<body>
<h1>[@ww.text name='config.email.title' /]</h1>
[@ww.form action='saveMailServer.action'
titleKey='config.email.title'
descriptionKey='config.email.description'
submitLabelKey='global.buttons.update'
cancelUri=cancelUri
]
    [@ww.param name='buttons'][@ww.submit value=action.getText('global.buttons.test') name="sendTest" /][/@ww.param]

    [@ww.textfield labelKey='config.email.server.name' name="name" required="true" descriptionKey='config.email.server.name.description' /]
    [@ww.textfield labelKey='config.email.from' name="from" required="true" descriptionKey='config.email.from.description' /]
    [@ww.textfield labelKey='config.email.subject.prefix' name="prefix" required="false" descriptionKey='config.email.subject.prefix.description' /]
    [@ww.checkbox labelKey='config.email.removePrecedence' name='removePrecedence' /]

    [@ww.select labelKey='config.email.emailSettings' name='chosenMailSetting' list=emailSettings toggle='true'/]

    [@ui.bambooSection dependsOn='chosenMailSetting' showOn='SMTP']
        [@ww.textfield labelKey='config.email.smtp' name="hostName" required="true" /]
        [@ww.textfield labelKey='config.email.smtp.port' name="smtpPort" required="false" /]
        [@ww.textfield labelKey='config.email.user.username' name="userName" required="false" /]
        [#if editMode && userName?has_content]
            [@ww.checkbox labelKey='config.email.user.password.change' toggle='true' id='passwordChange' name='passwordChange' /]
            [@ui.bambooSection dependsOn='passwordChange' showOn='true']
                [@ww.password labelKey='config.email.user.password' name="password" showPassword="true" required="false" /]
            [/@ui.bambooSection]
        [#else]
            [@ww.password labelKey='config.email.user.password' name="password" showPassword="true" required="false" /]
        [/#if]
        [@ww.checkbox labelKey='config.email.tlsRequired' name='tlsRequired'/]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='chosenMailSetting' showOn='JNDI']
        [@ww.textfield labelKey='config.email.jndi.location' name="jndiName" required="true" /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='config.email.test.title' descriptionKey='config.email.test.description']
        [@ww.textfield labelKey='config.email.test.recipient' name="testRecipient" required="false" descriptionKey='config.email.test.recipient.description'/]
    [/@ui.bambooSection]

[/@ww.form]

</body>
</html>
