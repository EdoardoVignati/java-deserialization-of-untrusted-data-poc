[#-- @ftlvariable name="adminErrors" type="com.atlassian.bamboo.logger.AdminErrorAction" --]
[#assign adminErrors = webwork.bean("com.atlassian.bamboo.logger.AdminErrorAction") ]
[#assign adminHandler = adminErrors.adminErrorHandler ]

[#if !adminHandler.errors.empty]
    [#list adminHandler.errors.entrySet() as error]
        [@ui.messageBox cssClass="admin-errors" type="warning"]
            [#if fn.hasGlobalPermission('ADMINISTRATION') ]
                <a class="adminErrorBoxLinks mutative" href="${req.contextPath}/admin/adminErrors!removeError.action?errorKey=${error.key}">Acknowledge</a>
            [/#if]
            ${error.value}
        [/@ui.messageBox]
    [/#list]
[/#if]
