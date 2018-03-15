[#-- @ftlvariable name="errors" type="com.atlassian.bamboo.logger.SystemErrorList" --]

[#if fn.hasAdminPermission() ]

[#assign errors = webwork.bean("com.atlassian.bamboo.logger.SystemErrorList")]
[#assign numErrors = errors.systemErrors.size() /]

[#if numErrors gt 0]
    [@ww.url id='systemErrorsURL' action='systemErrors' namespace='/admin' /]
    <p><img src="${req.contextPath}/images/icons/warning_16.gif" alt="Errors have been detected" width="16" height="16" style="vertical-align: middle;">
        [@ww.text name='system.errors.description.dashboard']
            [@ww.param value=numErrors /]
            [@ww.param]${systemErrorsURL}[/@ww.param]
        [/@ww.text]
    </p>
[/#if]

[/#if]
