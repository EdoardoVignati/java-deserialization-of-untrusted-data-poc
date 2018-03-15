[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[@ww.form action='saveMailServerInline' namespace="/ajax"]

    [@ww.textfield labelKey='config.email.server.name' name="name" required="true" descriptionKey='config.email.server.name.description' /]
    [@ww.textfield labelKey='config.email.from' name="from" required="true" descriptionKey='config.email.from.description' /]
    [@ww.textfield labelKey='config.email.subject.prefix' name="prefix" required="false" descriptionKey='config.email.subject.prefix.description' /]
    [@ww.checkbox labelKey='config.email.removePrecedence' name='removePrecedence' /]

    [@ww.select labelKey='config.email.emailSettings' name='chosenMailSetting' list=emailSettings toggle='true'/]

    [@ui.bambooSection dependsOn='chosenMailSetting' showOn='SMTP']
        [@ww.textfield labelKey='config.email.smtp' name="hostName" required="true" /]
        [@ww.textfield labelKey='config.email.smtp.port' name="smtpPort" required="false" /]
        [@ww.textfield labelKey='config.email.user.username' name="userName" required="false" /]
        [@ww.password labelKey='config.email.user.password' name="password" showPassword="true" required="false" /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='chosenMailSetting' showOn='JNDI']
        [@ww.textfield labelKey='config.email.jndi.location' name="jndiName" required="true" /]
    [/@ui.bambooSection]

    [@ww.hidden name='returnUrl' /]

[/@ww.form]
