[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#assign newNotification = bulkAction.getNewNotification(params)/]
[#if newNotification?has_content]
    [#if newNotification.notificationTypeForView?has_content]
        [#if newNotification.notificationTypeForView.getViewHtml()?has_content]
           [#assign notificationCondition=newNotification.notificationTypeForView.getViewHtml() /]
        [#else]
           [#assign notificationCondition=newNotification.notificationTypeForView.name /]
        [/#if]
    [#else]
         [#assign notificationCondition=newNotification.conditionKey /]
    [/#if]

    [#if newNotification.notificationRecipient?has_content]
        [#if newNotification.notificationRecipient.getViewHtml()?has_content]
            [#assign notificationRecipient=newNotification.notificationRecipient.getViewHtml() /]
        [#else]
            [#assign notificationRecipient=newNotification.notificationRecipient.description/]
        [/#if]
    [#else]
        [#assign notificationRecipient]
            ${newNotification.recipientType}: ${newNotification.recipient}
        [/#assign]
    [/#if]

    [@ww.label labelKey='notification.condition' value='${notificationCondition}' /]
    [@ww.label labelKey='bulkAction.notification.recipientHeading' value='${notificationRecipient}' escape=true /]
[#else]
    [@ww.label labelKey='notification.condition' value='Error: could not find notification type.' /]

[/#if]






