[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#if smtpMailServer?exists]
<html>
<head>
    <title>[@ww.text name='config.email.title' /]</title>
</head>
<body>
<h1>[@ww.text name='config.email.view.title' /]</h1>

    [@ww.form action='configureMailServer'
    titleKey='config.email.view.current.title'
    submitLabelKey='global.buttons.edit'
    descriptionKey='config.email.view.description']
        [@ww.param name='buttons']
            [@cp.displayLinkButton
                 buttonId="deleteButton"
                 buttonLabel="global.buttons.delete"
                 buttonUrl="${req.contextPath}/admin/deleteMailServer.action"
                 mutative=true
                 cssClass="requireConfirmation"
                 altText="delete this mail server configuration" /]
            [@ww.submit value=action.getText('global.buttons.test') name="sendTest" /]
        [/@ww.param]

        [@ww.label labelKey='config.email.server.name' value=smtpMailServer.name /]
        [@ww.label labelKey='config.email.from' value=smtpMailServer.defaultFrom /]
        [@ww.label labelKey='config.email.subject.prefix' value=smtpMailServer.prefix /]
        [#if smtpMailServer.isRemovePrecedence()] [#assign precedence='Yes'] [#else]  [#assign precedence='No']  [/#if]
        [@ww.label labelKey='config.email.removePrecedence' value=precedence /]

        [#if smtpMailServer.hostname?has_content]
            [@ww.label labelKey='config.email.emailSettings' value=smtpChoice /]
            [@ww.label labelKey='config.email.smtp' value=smtpMailServer.hostname /]
            [#if smtpMailServer.smtpPort?has_content && smtpMailServer.smtpPort != "25"]
                [@ww.label labelKey='config.email.smtp.port' value=smtpMailServer.smtpPort /]
            [/#if]
            [#if smtpMailServer.username?has_content]
                [@ww.label labelKey='config.email.user.username' value=smtpMailServer.username /]
            [/#if]
            [#if smtpMailServer.tlsRequired] [#assign tlsText='Yes'] [#else]  [#assign tlsText='No']  [/#if]
            [@ww.label labelKey='config.email.tlsRequired' value=tlsText/]
        [#else]
            [@ww.label labelKey='config.email.emailSettings' value=jndiChoice /]
            [@ww.label labelKey='config.email.jndi.location' value=smtpMailServer.jndiLocation /]
        [/#if]
        [@ui.bambooSection titleKey='config.email.test.title' descriptionKey='config.email.test.description']
            [@ww.textfield labelKey='config.email.test.recipient' name="testRecipient" required="false" descriptionKey='config.email.test.recipient.description'/]
        [/@ui.bambooSection]
    [/@ww.form]

</body>
</html>
[#else]
    [@ww.action name="saveMailServer!add" executeResult="true" /]
[/#if]
