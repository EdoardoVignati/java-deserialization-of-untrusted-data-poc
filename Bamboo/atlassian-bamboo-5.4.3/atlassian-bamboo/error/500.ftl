[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.error.FiveOhOh" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.error.FiveOhOh" --]
[#assign ver = webwork.bean("com.atlassian.bamboo.util.BuildUtils")]
<html>
<head>
    <title>[@ww.text name='error.500.title' /]</title>
    <meta name="decorator" content="install" />    
</head>

<body>
    <h1>[@ww.text name='error.500.heading' /]</h1>

    [#if (adminErrors.adminErrorHandler)?exists]
        [#include "/fragments/showAdminErrors.ftl"]
    [/#if]

    <h4>[@ww.text name='error.500.nav.title' /]</h4>
    <ul>
        <li><a href="${req.contextPath}/">[@ww.text name='error.500.nav.home' /]</a></li>
    </ul>
    A system error has occurred - our apologies!
    <p>
        Please create a problem report on our <b>support system</b> at <a href="https://support.atlassian.com/secure/CreateIssue.jspa?pid=10060&issuetype=1">http://support.atlassian.com</a> with the following information:
        <ol class="standard">
        <li>a description of your problem and what you were doing at the time it occurred
        <li>cut &amp; paste the error and system information found below
        <li>attach the <strong>atlassian-bamboo.log</strong> log file found in your application home.
        </ol>
        We will respond as promptly as possible.<br/>Thank you!
    </p>

    [#if ver?exists]
    <p>
        <b>Version:</b> ${ver.getCurrentVersion()?if_exists}<br>
        <b>Build:</b> ${ver.getCurrentBuildNumber()?if_exists}<br>
        <b>Build Date:</b> ${(ver.getCurrentBuildDate()?date)?if_exists}
    </p>
    [/#if]

    [#if req?exists]
     <h4>[@ww.text name='system.error.request.information' /]:</h4>
     <ul class="standard">
        <li>[@ww.text name='system.error.request.url' /]: ${req.getRequestURL()!}</li>
        <li>[@ww.text name='system.error.scheme' /]: ${req.getScheme()!}</li>
        <li>[@ww.text name='system.error.server' /]: ${req.getServerName()!}</li>
        <li>[@ww.text name='system.error.port' /]: ${req.getServerPort()!}</li>
        <li>[@ww.text name='system.error.uri' /]: ${req.getRequestURI()!}</li>
        <li>[@ww.text name='system.error.context.path' /]: ${req.getContextPath()!?html}</li>
        <li>[@ww.text name='system.error.servlet.path' /]: ${req.getServletPath()!?html}</li>
        <li>[@ww.text name='system.error.path.info' /]: ${req.pathInfo!?html}</li>
        <li>[@ww.text name='system.error.query.string' /]: ${req.queryString!?html}</li>
    </ul>
    [/#if]


    <p>
        <b>Stack Trace:</b>
        [#if fiveOhOhException?exists]
<pre>
${stackTrace?html}
</pre>
        [/#if]
    </p>
</body>
</html>