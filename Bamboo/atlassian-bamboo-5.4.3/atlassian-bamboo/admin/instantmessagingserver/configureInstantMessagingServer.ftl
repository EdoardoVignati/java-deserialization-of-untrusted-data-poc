[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[#if instantMessagingServerId == -1]
    [#assign mode = 'add' /]
    [#assign cancelUri = '/admin/administer.action' /]
[#else]
    [#assign mode = 'edit' /]
    [#assign cancelUri = '/admin/instantmessagingserver/viewInstantMessagingServer.action' /]
[/#if]
<html>
<head>
    [@ui.header pageKey='instantMessagingServer.admin.${mode}' title=true /]
</head>
<body>
[@ui.header pageKey='instantMessagingServer.admin.${mode}' /]
[@ww.form action="createInstantMessagingServer"
titleKey='instantMessagingServer.admin.${mode}'
descriptionKey='instantMessagingServer.admin.${mode}.description'
submitLabelKey='global.buttons.update'
cancelUri=cancelUri
]
    [@ww.param name='buttons']
        [@ww.submit value=action.getText('global.buttons.test') name="messageTest" /]
    [/@ww.param]
    [#if mode == 'edit']
        [@ww.hidden name="instantMessagingServerId" value=instantMessagingServerId /]
    [/#if]
[#-- [@ww.textfield labelKey='instantMessagingServer.label' name="name" required="true" /] --]
    [@ww.textfield labelKey='instantMessagingServer.host' name="host" required="true" /]
    [@ww.textfield labelKey='instantMessagingServer.port' name="port" required="false" /]
    [@ww.textfield labelKey='instantMessagingServer.username' name="username" required="false" /]
    [#if mode == 'edit' && username?has_content]
        [@ww.checkbox labelKey='instantMessagingServer.password.change' toggle='true' name='passwordChange' /]
        [@ui.bambooSection dependsOn='passwordChange' showOn='true']
            [@ww.password labelKey='instantMessagingServer.password' name="password" required="false" showPassword='true'/]
        [/@ui.bambooSection]
    [#else]
        [@ww.password labelKey='instantMessagingServer.password' name="password" required="false" showPassword='true' /]
    [/#if]
    [@ww.textfield labelKey='instantMessagingServer.resource' name="resource" required="false" /]
    [@ww.checkbox labelKey='instantMessagingServer.secureConnectionRequired' name="secureConnectionRequired" toggle='true' /]
    [@ui.bambooSection dependsOn='secureConnectionRequired' showOn='true' ]
        [@ww.checkbox labelKey='instantMessagingServer.enforceLegacySsl' name="enforceLegacySsl" /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='instantMessagingServer.test.title' descriptionKey='instantMessagingServer.test.description']
        [@ww.textfield labelKey='instantMessagingServer.test.recipient' name="testRecipients" required="false" descriptionKey='instantMessagingServer.test.recipient.description'/]
    [/@ui.bambooSection]
[/@ww.form]
</body>
</html>
        