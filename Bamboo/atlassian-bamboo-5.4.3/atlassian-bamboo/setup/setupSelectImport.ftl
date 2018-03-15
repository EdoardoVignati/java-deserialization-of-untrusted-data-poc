[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
<html>
<head>
    <title>[@ww.text name='setup.data.title' /]</title>
    <meta name="step" content="3">
</head>

<body>

[@ui.header pageKey='setup.data.title' headerElement='h2' /]

[@ww.form action="performImportData" submitLabelKey='global.buttons.continue']
    [@ww.radio labelKey='setup.data.options' name='dataOption'
        listKey='key' listValue='value' toggle='true'
        list=importOptions ]
    [/@ww.radio]
    [@ui.bambooSection dependsOn='dataOption' showOn='import']
            [@ww.textfield labelKey='setup.data.import.path' name='importPath' required='true' cssClass="long-field" /]
    [/@ui.bambooSection]
[/@ww.form ]

</body>
</html>