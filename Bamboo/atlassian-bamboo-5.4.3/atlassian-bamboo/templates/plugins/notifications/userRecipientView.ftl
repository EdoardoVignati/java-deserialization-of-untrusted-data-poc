[#if notificationUserFullNameString?has_content]
     <a href="${req.getContextPath()}/browse/user/${notificationUserString}">${notificationUserFullNameString}</a><span class="notificationRecipientType"> (user)</span>
[#else]
    ${notificationUserString} <span class="notificationRecipientType"> (user)</span>
[/#if]

