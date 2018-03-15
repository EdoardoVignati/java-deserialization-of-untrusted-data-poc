[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
<html>
	<head>
		<title>[@ww.text name='setup.data.title' /]</title>
	</head>

	<body>
        <h1>[@ww.text name='setup.data.title' /]</h1>


    [#if importSuccessful]
        [#assign boxClass="tip"/]
    [#else]
        [#assign boxClass="warning"/]
    [/#if]
    [#import "setupCommon.ftl" as sc/]
    [@sc.setupActionErrors boxClass=boxClass/]
    </body>
</html>