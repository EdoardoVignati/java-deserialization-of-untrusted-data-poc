[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.UserManagement" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.UserManagement" --]
<html>
<head>
    <title>[@ww.text name='config.userManagement.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>

    [@ui.header pageKey='config.userManagement.heading' descriptionKey='config.userManagement.description' /]

    [#if saved]
            [@ui.messageBox type="success" titleKey="config.updated" /]
    [/#if]
    [#if synchronised]
            [@ui.messageBox type="success" titleKey="config.userManagement.crowd.synchronised" /]
    [/#if]

    [@ww.form action="configureUserManagement.action"
              id="userManagementForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/userRepositories.action'
    ]

        [@ww.radio name='userManagementOption'
                   template='radio.ftl'
                   theme='aui'
                   fieldValue='Local'
                   nameValue='userManagementOption'
                   toggle='true'
                   labelKey='config.userManagement.enableLocal.label'
                   descriptionKey='config.userManagement.enableLocal.description'/]

        [@ww.radio name='userManagementOption'
                   template='radio.ftl'
                   theme='aui'
                   fieldValue='Crowd'
                   nameValue='userManagementOption'
                   toggle='true'
                   labelKey='config.userManagement.enableCrowd.label'
                   descriptionKey='config.userManagement.enableCrowd.description'/]
        [@ui.bambooSection dependsOn='userManagementOption' showOn='Crowd' id="configureCrowdOptions"]
            [#if userManagementOption == 'Local'][@ui.messageBox titleKey="config.userManagement.enableCrowd.warning" /][/#if]
            [@crowdTextField labelKey='config.userManagement.crowd.server.label' name='serverURL.value' descriptionKey='config.userManagement.crowd.server.description' crowdField=serverURL /]
            [@crowdTextField labelKey='config.userManagement.crowd.applicationName.label' name='applicationName.value' descriptionKey='config.userManagement.crowd.applicationName.description' crowdField=applicationName /]
            [#if !applicationPassword.isWritable]
                [@ww.label labelKey='config.userManagement.crowd.applicationPassword.label' value='******']
                    [@ww.param name='description']
                        [@ww.text name='config.userManagement.crowd.applicationPassword.description'/]<strong>[@ww.text name='config.userManagement.crowd.configured.externally'][@ww.param][@help.href pageKey="usermanagement.ldap"/][/@ww.param][/@ww.text]</strong>
                    [/@ww.param]
                [/@ww.label]
            [#elseif !applicationPasswordSet]
                [@ww.password labelKey='config.userManagement.crowd.applicationPassword.label' name="applicationPassword.value" descriptionKey='config.userManagement.crowd.applicationPassword.description' required=true disabled=!applicationPassword.isWritable/]
            [#else]
                [@ww.checkbox labelKey='config.userManagement.crowd.applicationPassword.change.label' name="setApplicationPassword" toggle='true'/]
                [@ui.bambooSection dependsOn='setApplicationPassword' showOn='true']
                    [@ww.password labelKey='config.userManagement.crowd.applicationPassword.label' name="applicationPassword.value" descriptionKey='config.userManagement.crowd.applicationPassword.description' required=true disabled=!applicationPassword.isWritable/]
                [/@ui.bambooSection]
            [/#if]
            [@crowdTextField labelKey='config.userManagement.crowd.cacheInterval.label' name='cacheInterval.value' descriptionKey='config.userManagement.crowd.cacheInterval.description' crowdField=cacheInterval /]

            <div class="details">
                [#if activeUserManagementIsSynchronisable]
                    <p>
                        [#if synchronisationResult??]
                            [#if synchronisationResult.success]
                                [@ww.text name='config.userManagement.crowd.synchronisation.info']
                                    [@ww.param][@ui.time datetime=synchronisationResult.details.start]${synchronisationResult.details.start?datetime?string}[/@ui.time][/@ww.param]
                                    [@ww.param value='${synchronisationResult.details.fetchDurationMinutes}' /]
                                    [@ww.param value='${synchronisationResult.details.fetchDurationSeconds}' /]
                                    [@ww.param value='${synchronisationResult.details.fetchDurationMillis}' /]
                                [/@ww.text]
                            [#else]
                                [@ww.text name='config.userManagement.crowd.synchronisation.failed' /]
                            [/#if]
                        [#else]
                            [@ww.text name='config.userManagement.crowd.synchronisation.never' /]
                        [/#if]
                        <a href="[@ww.url action='synchroniseCrowdCache' /]">[@ww.text name='config.userManagement.crowd.synchronise' /]</a>
                    </p>
                [/#if]
                <p><strong>[@ww.text name='config.userManagement.crowd.server.speed.warning'][@ww.param][@help.href pageKey="usermanagement.crowd.notes"/][/@ww.param][/@ww.text]</strong></p>
            </div>

        [/@ui.bambooSection]

        [@ww.text id="ldapDescription" name="config.userManagement.enableCustom.description"][@ww.param][@help.href pageKey="usermanagement.ldap"/][/@ww.param][/@ww.text]

        [#if customConfigurationAvailable]
            [@ww.radio name='userManagementOption'
                       template='radio.ftl'
                       theme='aui'
                       fieldValue='Custom'
                       nameValue='userManagementOption'
                       toggle='true'
                       labelKey='config.userManagement.enableCustom.label'
                       description=ldapDescription
                       escape='false'/]
        [#else]
            <div class="radio">[@ww.text name='config.userManagement.custom.not.available'][@ww.param][@help.href pageKey="usermanagement.ldap"/][/@ww.param][/@ww.text]</div>
        [/#if]

    [/@ww.form]

</body>
</html>

[#macro crowdTextField labelKey name descriptionKey crowdField]
    [#if crowdField.isWritable]
        [@ww.textfield labelKey=labelKey name=name descriptionKey=descriptionKey required=true disabled=!crowdField.isWritable/]
    [#else]
        [@ww.label labelKey=labelKey name=name]
            [@ww.param name='description']
                [@ww.text name=descriptionKey/]<strong>[@ww.text name='config.userManagement.crowd.configured.externally'/]</strong>
            [/@ww.param]
        [/@ww.label]
    [/#if]
[/#macro]
