[#assign pathToAui][@cp.getStaticResourcePrefix /]/layout/setup/aui/aui[/#assign]
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>[#if title?has_content]${title} - [/#if][#if instanceName?has_content]${instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />

    <link rel="shortcut icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.ico" type="image/x-icon"/>

    <link type="text/css" rel="stylesheet" href="${pathToAui}/css/aui.css" media="all" />
    <link type="text/css" rel="stylesheet" href="${pathToAui}/css/aui-experimental.css" media="all" />
    <!--[if lt IE 9]>
        <link type="text/css" rel="stylesheet" href="${pathToAui}/css/aui-ie.css" media="all" />
    <![endif]-->
    <!--[if IE 9]>
        <link type="text/css" rel="stylesheet" href="${pathToAui}/css/aui-ie9.css" media="all" />
    <![endif]-->

    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/layout/setup/setup.less.css" media="all" />

    <script type="text/javascript">
        (function (window) {
            window.BAMBOO = (window.BAMBOO || {});
            BAMBOO.contextPath = '${req.contextPath}';
        })(window);
    </script>
    <script type="text/javascript" src="${pathToAui}/js/aui-dependencies.js"></script>
    <script type="text/javascript" src="${pathToAui}/js/aui-soy.js"></script>
    <script type="text/javascript" src="${pathToAui}/js/aui.js"></script>
    <script type="text/javascript" src="${pathToAui}/js/aui-experimental.js"></script>

    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/widget/setup-spinner/setup-spinner.js"></script>
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/setup/bambooSetup.js"></script>
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/dynamic-field-parameters.js"></script>
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/xsrf.js"></script>
    <!--[if lt IE 9]>
        <script type="text/javascript" src="${pathToAui}/js/aui-ie.js"></script>
    <![endif]-->
${head!}
</head>
<body class="aui-layout aui-theme-default aui-page-focused aui-page-focused-xlarge">
    <ul id="assistive-skip-links" class="assistive">
        <li><a href="#content">Skip to content</a></li>
    </ul>
    <div id="page">
