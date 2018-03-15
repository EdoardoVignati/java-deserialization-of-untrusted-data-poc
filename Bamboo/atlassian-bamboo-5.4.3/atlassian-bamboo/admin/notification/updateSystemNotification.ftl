[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]

[#import "/lib/build.ftl" as bd]

<title>[@ww.text name="system.notifications"/]</title>
[#assign updateUrl='/admin/updateSystemNotification.action?notificationId=${notificationId}' /]
[#assign cancelUrl='/admin/viewSystemNotifications.action' /]
[#assign titleKey="notification.edit.title" /]

[@ww.form action=updateUrl
cancelUri=cancelUrl
submitLabelKey='global.buttons.update'
id='updateSystemNotificationForm'
showActionErrors='false'

]
    [@bd.configureSystemNotificationsForm edit=true /]
[/@ww.form]
</body>
