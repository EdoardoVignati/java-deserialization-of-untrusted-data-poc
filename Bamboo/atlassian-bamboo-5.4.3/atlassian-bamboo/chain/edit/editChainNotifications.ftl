[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#import "/lib/build.ftl" as bd]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[#assign createNotificationButton]
    [@ww.url id='addNotificationUrl' value='/chain/admin/ajax/addNotification.action' buildKey=buildKey returnUrl=currentUrl lastModified=lastModified conditionKey=conditionKey notificationRecipientType=notificationRecipientType previousTypeData=previousTypeData saved=true /]
    [@cp.displayLinkButton buttonId='addNotification' buttonLabel='chain.config.notifications.add' buttonUrl=addNotificationUrl/]
[/#assign]
[@dj.simpleDialogForm triggerSelector=".edit-notification" width=540 height=420 headerKey="notification.edit.title" submitCallback="redirectAfterReturningFromDialog" /]
[@dj.simpleDialogForm triggerSelector="#addNotification" width=540 height=420 headerKey="notification.add.title" submitCallback="redirectAfterReturningFromDialog" /]


[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab='notifications' titleKey='notification.title' tools=(createNotificationButton)!""]
        <div class="description">[@ww.text name="notification.description"/]</div>
        [@bd.notificationWarnings /]
        [@bd.existingNotificationsTable
           editUrl='${req.contextPath}/chain/admin/config/editChainNotification.action?buildKey=${buildKey}'
           deleteUrl='${req.contextPath}/chain/admin/config/deleteChainNotification.action?buildKey=${buildKey}'
           showColumnSpecificHeading=false
                /]
[/@eccc.editChainConfigurationPage]

