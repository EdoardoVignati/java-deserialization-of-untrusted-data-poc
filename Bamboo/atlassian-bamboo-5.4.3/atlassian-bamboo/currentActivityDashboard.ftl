[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#assign curTab = "currentTab" /]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <meta name="decorator" content="atl.dashboard"/>
    <meta name="tab" content="${curTab?html}" />
</head>
<body>

[@ww.action namespace='/ajax' name='displayCurrentActivity' executeResult='true' /]
<script type="text/javascript">
    saveCookie("atlassian.bamboo.dashboard.tab.selected", "${curTab?js_string}");
</script>

</body>
</html>
