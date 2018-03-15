<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>[#if title?has_content]${title} - [/#if][#if ctx?? && ctx.instanceName?has_content]${ctx.instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    <script type="text/javascript">
        (function (window) {
            window.BAMBOO = (window.BAMBOO || {});
            BAMBOO.contextPath = '${req.contextPath}';
        })(window);
    </script>
    ${webResourceManager.requireResourcesForContext("atl.general")}
    ${webResourceManager.requiredResources}
    ${head!}
</head>
<body class="aui-layout aui-theme-default">
    <div id="page">
        <section id="content" role="main">
            <div class="aui-panel">${body}</div>
        </section><!-- END #content -->
    </div><!-- END #page -->
</body>
</html>
