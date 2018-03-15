[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[@ww.form action="createInstantMessagingServerInline" namespace="/ajax"]

    [@ww.textfield labelKey='instantMessagingServer.host' name="host" required="true" /]
    [@ww.textfield labelKey='instantMessagingServer.port' name="port" required="false" /]
    [@ww.textfield labelKey='instantMessagingServer.username' name="username" required="false" /]
    [@ww.password labelKey='instantMessagingServer.password' name="password" required="false" showPassword='true' /]
    [@ww.textfield labelKey='instantMessagingServer.resource' name="resource" required="false" /]
    [@ww.checkbox labelKey='instantMessagingServer.secureConnectionRequired' name="secureConnectionRequired" /]
    [@ww.checkbox labelKey='instantMessagingServer.enforceLegacySsl' name="enforceLegacySsl" /]

    [@ww.hidden name='returnUrl' /]
    [@ww.hidden name='testConnection' value='false'/]

[/@ww.form]