[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="errors" type="com.atlassian.bamboo.logger.SystemErrorList" --]
<html>
<head>
    <title>[@ww.text name='system.errors.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>

[#assign errors = webwork.bean("com.atlassian.bamboo.logger.SystemErrorList")]
[#assign numErrors = errors.systemErrors.size()]


<h1>[@ww.text name='system.errors.heading' /]</h1>

<p>
    [@ww.text name='system.errors.description']
        [@ww.param value=numErrors /]
    [/@ww.text]
    [#if numErrors gt 0]
        <a id="clearAllErrors" href="[@ww.url action='removeErrorFromLog!removeAll' returnUrl='${currentUrl}'/]">Clear all error logs</a>
    [/#if]

</p>

[#if numErrors gt 0]
    [#list errors.systemErrors?sort_by("lastOccurred")?reverse as error]
        [@cp.showSystemError error=error returnUrl=currentUrl /]
    [/#list]
[/#if]

</body>

</html>
