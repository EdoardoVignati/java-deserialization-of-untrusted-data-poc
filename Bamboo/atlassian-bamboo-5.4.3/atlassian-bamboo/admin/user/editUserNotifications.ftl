[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureNotificationPreferences" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureNotificationPreferences" --]
<head>
	[@ui.header pageKey='User Notifications' object='${fn.getUserFullName(currentUser)}' title=true/]
    <meta name="decorator" content="atl.userprofile"/>
    <meta name="tab" content="userNotifications" />
</head>
<body>

[@ww.form action='updateUserNotifications'
          namespace='/profile'
          submitLabelKey='global.buttons.update'
          cancelUri='/profile/userNotifications.action'
          showActionMessages='false'
          showActionWarnings='false'
          titleKey='user.edit.title']
           [@ww.select labelKey='user.notification.preference.label' name='notificationPreference'
                    list=notificationTypes listKey='key' listValue='value' toggle='true'/]

            <div class="dependsOnnotificationPreference showOntextEmail showOnboth" >
                [@ww.radio labelKey='user.notification.transportPreference.label' name='notificationTransportPreference' listKey='key' listValue='value' list=notificationTransportPreferenceTypes descriptionKey='user.notification.transportPreference.description' /]            
            </div>
[/@ww.form]
</body