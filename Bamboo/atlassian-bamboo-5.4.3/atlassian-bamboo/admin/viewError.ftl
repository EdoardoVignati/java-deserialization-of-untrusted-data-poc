[#-- @ftlvariable name="action" type="com.atlassian.bamboo.logger.ViewBuildError" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.logger.ViewBuildError" --]
<html>
<head>
    <title>Bamboo Error Viewer</title>
    <meta name="decorator" content="atl.popup">
</head>

<body>
[@ui.header page="System Error Details" /]

[#if errorDetails??]
<div id="applicationError">
    <em>
       [#if errorDetails.buildSpecific]
           [#assign buildUrl = "/browse/" + errorDetails.buildKey /]
            [#if errorDetails.buildNumber??]
                [#assign buildUrl = buildUrl + "-" + errorDetails.buildNumber /]
            [/#if]
            <a href="[@ww.url value=buildUrl /]" rel="up">Build ${errorDetails.buildName?html} [#if errorDetails.buildNumber?? ] ${errorDetails.buildNumber}[/#if]</a>
        [#elseif errorDetails.elastic]
            Elastic Bamboo Error
        [#else]
            General Error
        [/#if]
    :</em> ${errorDetails.context?html} <br />
    [#if errorDetails.throwableDetails??]
    <div class="grey">(${errorDetails.throwableDetails.name?html} : ${errorDetails.throwableDetails.message!?html})</div>
    [#if errorDetails.numberOfOccurrences == 1]
        <br>Occurred: ${errorDetails.lastOccurred?datetime}
    [#else]
        <br>Occurrences: ${errorDetails.numberOfOccurrences}
        <br>First Occurred: ${errorDetails.firstOccurred?datetime}
        <br>Last Occurred: ${errorDetails.lastOccurred?datetime}
    [/#if]
    [#if errorDetails.agentIds?has_content]
        <br>Agent[#if errorDetails.agentIdentifiers.size() != 1]s[/#if]: [#lt]
        [#list errorDetails.agentIdentifiers as agent]
            [#if agent.name?has_content]
                <a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]" rel="up">${agent.name?html}</a>[#t]
            [#else]
                (${agent.id})
            [/#if]                
            [#if agent_has_next]
                ,[#lt]
            [/#if]
        [/#list]
    [/#if]
    [#if errorDetails.elastic]
        [#if errorDetails.instanceIds?has_content]
            <br>Elastic Instance[#if errorDetails.instanceIds.size() != 1]s[/#if]: [#lt]
            [#list errorDetails.instanceIds as instanceId]
                ${instanceId?html}[#t]
                [#if instanceId_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
    [/#if]
    <hr>

    <pre class="code">${(errorDetails.throwableDetails.stackTrace)!?html}</pre>

    <hr>

    <ul class="floating-toolbar">
        <li><a class="close" tabindex="0">Close This Window</a></li>
        [#if fn.hasAdminPermission()]
            <li>
                <a href="${req.contextPath}/admin/removeErrorFromLog.action?buildKey=${errorDetails.buildKey}&amp;error=${errorDetails.errorNumber}" class="remove">
                    [@ui.icon type="delete" /]
                    <span>Clear error from log</span>
                </a>
            </li>
        [/#if]
        <li>
            <a href="http://support.atlassian.com" rel="external">
                <img src="${req.contextPath}/images/contract.gif" border="0" alt="Report bug" width="16" height="16" align="absmiddle">
                <span>Report Bug</span>
            </a>
        </li>
    </ul>

    [/#if]
</div>
<script type="text/javascript">
    (function (window, $) {
        var originalOpenerURL = (window.opener ? window.opener.location.toString() : null),
            failHandler = function (jqXHR, textStatus, errorThrown) {
                alert("An error occurred while clearing the error from the log, it may have already been cleared.");
                refreshOpenerIfAvailable();
                window.close();
            },
            refreshOpenerIfAvailable = function () {
                if (window.opener && (window.opener.location.toString() == originalOpenerURL)) {
                    window.opener.location.reload(true);
                }
            };

        $(document).delegate("a[rel]", "click", function (e) {
            var $a = $(this),
                rel = $a.attr("rel"),
                href = $a.attr("href");

            if (rel == "up") {
                return !(window.opener && (window.opener.location = href));
            } else if (rel == "external") {
                return !window.open(href);
            }
        }).delegate("a.close", "click", function (e) {
            window.close();
        }).delegate("a.remove", "click", function (e) {
            var $a = $(this),
                href = $a.attr("href");

            e.preventDefault();
            
            $.get(href, { "bamboo.successReturnMode": "json" }, "json").done(function (data, textStatus, jqXHR) {
                if (data.status && data.status == "OK") {
                    refreshOpenerIfAvailable();
                    window.close();
                } else {
                    failHandler(jqXHR, textStatus, null);
                }
            }).fail(failHandler);
        });
    })(window, AJS.$);
</script>
[/#if]
</body>
</html>