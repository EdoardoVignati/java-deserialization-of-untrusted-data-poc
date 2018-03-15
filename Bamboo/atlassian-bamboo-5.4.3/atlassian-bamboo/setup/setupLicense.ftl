[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.standard.title' /]</title>
</head>

<body>

[@ui.header pageKey='setup.install.standard.heading' descriptionKey='setup.welcome' /]

[#assign licenseDescription]
    [@ww.text name='license.description' ]
        [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
    [/@ww.text]
[/#assign]
[@ww.form action="validateLicense"]
    [@ww.hidden name='sid' /]

    [@ui.bambooSection  titleKey='setup.install.license.section']
        [@ww.label labelKey='setup.install.sid' name='sid' /]
        [@ww.textarea labelKey='license' name="licenseString" required="true" rows="7" fullWidthField=true]
            [@ww.param name='description']
                [@ww.text name='license.description']
                    [@ww.param]${version}[/@ww.param]
                    [@ww.param]${sid}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.textarea]
    [/@ui.bambooSection]
    [@ui.bambooSection titleKey="setup.install.setupType.section"]
        [@installationOption titleKey='setup.install.setupType.express' descriptionKey='setup.install.setupType.express.description' submitKey='setup.install.express' submitId="expressInstall" isPrimary=true /]
        [@installationOption titleKey='setup.install.setupType.custom' descriptionKey='setup.install.setupType.custom.description' submitKey='setup.install.custom' submitId="customInstall" /]
    [/@ui.bambooSection]
[/@ww.form]

[#macro installationOption titleKey descriptionKey submitKey submitId isPrimary=false]
    [@ww.text name=submitKey id="submitText" /]
    <div class="installation-option">
        <h4>[@ww.text name=titleKey /]</h4>
        <p>[@ww.text name=descriptionKey /]</p>
        <input type="submit" value="${submitText}" name="${submitId}" id="${submitId}" class="aui-button[#if isPrimary] aui-button-primary[/#if]" />
    </div>
[/#macro]
</body>
</html>
