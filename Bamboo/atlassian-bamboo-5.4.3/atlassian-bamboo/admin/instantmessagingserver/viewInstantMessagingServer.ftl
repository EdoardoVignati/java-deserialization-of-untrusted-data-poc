[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]

[#assign instantMessagingServers=instantMessagingServers /]

<html>
<head>
[#if instantMessagingServers?has_content]
    [@ui.header pageKey='instantMessagingServer.admin.view' title=true /]
[#else]
    [@ui.header pageKey='instantMessagingServer.admin.add' title=true /]
[/#if]
</head>

<body>
[#if instantMessagingServers?has_content]
    [@ui.header pageKey='instantMessagingServer.admin.view' /]
    [#foreach instantMessagingServer in instantMessagingServers]
        [@ww.form action='editInstantMessagingServer'
        titleKey='instantMessagingServer.admin.view.title'
        descriptionKey='instantMessagingServer.admin.view.description'
        submitLabelKey='global.buttons.edit']
            [@ww.param name='buttons']
                [@cp.displayLinkButton
                    buttonId="deleteButton"
                    buttonLabel="global.buttons.delete"
                    buttonUrl="${req.contextPath}/admin/instantmessagingserver/deleteInstantMessagingServer.action?instantMessagingServerId=${instantMessagingServer.id}"
                    mutative=true
                    cssClass="requireConfirmation"
                    altText="delete this instant messaging server configuration" /]
                [@ww.submit value=action.getText('global.buttons.test') name="messageTest" /]
            [/@ww.param]
            [@ww.hidden name="instantMessagingServerId" value=instantMessagingServer.id /]
        [#-- [@ww.label labelKey='instantMessagingServer.label' value=instantMessagingServer.name /] --]
            [@ww.label labelKey='instantMessagingServer.host' value=instantMessagingServer.host /]
            [#if instantMessagingServer.port?exists]
                [@ww.label labelKey='instantMessagingServer.port' value=instantMessagingServer.port /]
            [/#if]
            [#if instantMessagingServer.username?has_content]
                [@ww.label labelKey='instantMessagingServer.username' value=instantMessagingServer.username /]
            [/#if]
            [#if instantMessagingServer.resource?has_content]
                [@ww.label labelKey='instantMessagingServer.resource' value=instantMessagingServer.resource /]
            [/#if]
            [@ww.label labelKey='instantMessagingServer.secureConnectionRequired' value=instantMessagingServer.secureConnectionRequired /]
            [#if instantMessagingServer.secureConnectionRequired]
                [@ww.label labelKey='instantMessagingServer.enforceLegacySsl' value=instantMessagingServer.enforceLegacySsl /]
            [/#if]
            [@ui.bambooSection titleKey='instantMessagingServer.test.title' descriptionKey='instantMessagingServer.test.description']
                [@ww.textfield labelKey='instantMessagingServer.test.recipient' name="testRecipients" required="false" descriptionKey='instantMessagingServer.test.recipient.description'/]
            [/@ui.bambooSection]
        [/@ww.form]
    [/#foreach]
[#else]
    [@ww.action name="addInstantMessagingServer" executeResult="true" /]
[/#if]
</body>
</html>