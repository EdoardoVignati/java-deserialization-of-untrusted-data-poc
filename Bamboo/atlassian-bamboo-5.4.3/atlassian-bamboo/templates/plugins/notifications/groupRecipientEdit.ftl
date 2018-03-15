[#if notificationGroupString?has_content]
    [@ww.textfield labelKey='notification.recipients.groups'  value='${notificationGroupString}' name='notificationGroupString' /]
[#else]
    [@ww.textfield labelKey='notification.recipients.groups' name='notificationGroupString' /]
[/#if]

