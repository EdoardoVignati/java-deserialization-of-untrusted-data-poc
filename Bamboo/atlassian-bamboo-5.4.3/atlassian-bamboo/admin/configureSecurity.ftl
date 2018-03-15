[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
<html>
<head>
    [@ui.header pageKey="config.security.heading" title=true/]
</head>
<body>
    [@ui.header pageKey="config.security.heading" descriptionKey="config.security.description"/]
    [@ww.form action="configureSecurity!execute.action"
              id="configurationSecurityForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/viewSecurity.action'
              titleKey='config.security.form.edit.heading'
    ]
        [@ww.checkbox id='enableExternalUserManagement_id' labelKey='config.security.enableExternalUserManagement' descriptionKey='config.security.enableExternalUserManagement.description' name='enableExternalUserManagement'/]
        [#if featureManager.signupConfigurable]
            [@ww.checkbox id='enableSignup_id' labelKey='config.security.enableSignup' toggle='true' name='enableSignup'/]
            [@ui.bambooSection dependsOn='enableSignup' showOn='true']
                [@ww.checkbox id='enableCaptchaOnSignup_id' labelKey='config.security.enableCaptchaOnSignup' name='enableCaptchaOnSignup'/]
            [/@ui.bambooSection]
        [/#if]
        [@ww.checkbox id='enableViewContactDetails_id' labelKey='config.security.enableViewContactDetails' descriptionKey='config.security.enableViewContactDetails.description' name='enableViewContactDetails'/]
        [#if featureManager.restrictedAdminConfigurable]
            [@ww.checkbox id='enableRestrictedAdmin_id' labelKey='config.security.enableRestrictedAdmin' descriptionKey='config.security.enableRestrictedAdmin.description' name='enableRestrictedAdmin'/]
        [/#if]
        [@ww.checkbox id='enableCaptcha_id' labelKey='config.security.enableCaptcha' toggle='true' name='enableCaptcha'/]
        [@ui.bambooSection dependsOn='enableCaptcha' showOn='true']
            [@ww.textfield id='loginAttempts_id' labelKey='config.security.loginAttempts' name="loginAttempts" required="true"/]
        [/@ui.bambooSection]
        [@s.checkbox labelKey='config.security.xsrfProtection' name='xsrfProtectionEnabled' toggle=true/]
        [@ui.bambooSection dependsOn='xsrfProtectionEnabled' showOn=true]
            [@s.checkbox labelKey='config.security.xsrfProtection.mutativeGetsAllowed' name='xsrfProtectionMutativeGetsAllowed'/]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>