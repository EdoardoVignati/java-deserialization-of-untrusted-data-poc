[#-- @ftlvariable name="action" type="com.opensymphony.xwork2.ActionSupport" --]
[#-- @ftlvariable name="" type="com.opensymphony.xwork2.ActionSupport" --]
<html>
<head>
    <title>Func Master 3000</title>
    <script language="JavaScript" type="text/javascript" src="${req.contextPath}/scripts/scriptaculous/prototype.js"></script>
    <script language="JavaScript" type="text/javascript" src="${req.contextPath}/scripts/scriptaculous/scriptaculous.js"></script>
    <script language="JavaScript" type="text/javascript" src="${req.contextPath}/func/func.js"></script>
    <script language="JavaScript" type="text/javascript" src="${req.contextPath}/func/obj.js"></script>
    <link type="text/css" rel="StyleSheet" href="${req.contextPath}/func/func.css" />
    <script type="text/javascript" src="${req.contextPath}/scripts/bamboo.js"></script>
    <meta name="decorator" content="none">
</head>
<body>

<form id="urlForm" method="post" action="#" onsubmit="return loadPage();">
    <input type="text" name="currentUrl" id="currentUrl" />
</form>

<div id="commands">
    <a class="deleteLink" href="#" onclick="removeAllCommands();return false">remove all</a>
    <a class="deleteLink" href="#" onclick="extractCommands();return false">extract</a>
    <h2>Commands Executed</h2>
    &nbsp;
    <ol id="commandsList">
    </ol>
    &nbsp;
    <textarea id="commandsText" style="display:none;"></textarea>
</div>

<div id="frameHolderHolder" >
    <iframe id="frameHolder" name="frameHolder" src="${req.contextPath}/start.action">
    </iframe>
</div>
<script language="JavaScript" type="text/javascript">
<!--
    loadUrl();
//-->
</script>

<div class="othercrap">
    <div class="tools">
        <a href="#" onclick="assertPresent();return false;">Assert present</a> |
        <a href="#" onclick="assertBefore();return false;" id="assertBefore">Assert before..</a> |
        <a href="#" onclick="saveUrl(); return false;">Save current url</a>
    </div>

    <iframe id="hiddenIFrame" name="hiddenIFrame"  class="hidden">
    </iframe>
</div>

<script language="JavaScript" type="text/javascript">
<!--

addEventsToListen('a' , 'click', handleAnchor);
addEventsToListen('input' , 'blur', handleInput);
addEventsToListen('textarea' , 'blur', handleInput);
addEventsToListen('select' , 'change', handleSelect);
addEventsToListen('input' , 'click', handleSubmit);

//-->
</script>

</body>
</html>