[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]

[#import "/lib/build.ftl" as bd]

[@dj.simpleDialogForm triggerSelector="#addSystemNotification" width=540 height=420 headerKey="notification.add.title" submitCallback="redirectAfterReturningFromDialog" /]
[@dj.simpleDialogForm triggerSelector=".edit-notification" width=540 height=420 headerKey="notification.edit.title" submitCallback="redirectAfterReturningFromDialog" /]

<html>
<head>
    <title>[@ww.text name="system.notifications"/]</title>
</head>
<body>
<div class="floating-toolbar">
    [@ww.url id='addSystemNotificationUrl' value='/chain/admin/ajax/addSystemNotification.action' returnUrl=currentUrl lastModified=lastModified conditionKey=conditionKey notificationRecipientType=notificationRecipientType previousTypeData=previousTypeData /]
    [@cp.displayLinkButton buttonId='addSystemNotification' buttonLabel='chain.config.notifications.add' buttonUrl=addSystemNotificationUrl/]
</div>

[@ui.header pageKey="system.notifications" descriptionKey="system.notifications.description"/]
[#if notificationErrorMessageKey?has_content && featureManager.mailServerConfigurationSupported]
    [@cp.displayNotificationWarnings messageKey=notificationErrorMessageKey addServerKey=notificationAddServerKey cssClass='info' allowInlineEdit=true/]
[/#if]
[#if systemNotificationRules?has_content]
    [@bd.displayNotificationRulesTable
    notificationRules=systemNotificationRules
    showColumnSpecificHeading=false
    editUrl='${req.contextPath}/admin/editSystemNotification.action?'
    deleteUrl='${req.contextPath}/admin/removeSystemNotification.action?'
    /]
[#else]
<p>[@ww.text name="system.notifications.none"/]</p>
[/#if]

</body>
</html>
