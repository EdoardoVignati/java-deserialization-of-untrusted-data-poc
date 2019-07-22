[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.UpdateLicenseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.UpdateLicenseAction" --]
<html>
<head>
    <title>[@ww.text name='license.details.title' /]</title>
</head>

<body>

    <h1>[@ww.text name='license.details.heading' /]</h1>
    [#assign licensePageInfo]

    [#if !license??]
        [@ui.messageBox type="error" titleKey="license.error.missing" /]
    [#else]
        [#if oldLicenseWithNewInstall]
            [@ui.messageBox type='warning']
                [@ww.text name='license.tooOldForBuild']
                    [@ww.param][@ww.date name='supportPeriodEnd' format='dd MMMM yyyy'/][/@ww.param]
                    [@ww.param]${versionInfo}[/@ww.param]
                    [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
                [/@ww.text]
            [/@ui.messageBox]
            [#else]
            [#if evaluationLicense]
                [#if license.expired]
                [@ui.messageBox type='warning']
                    [@ww.text name='license.expiry.expired.message']
                        [@ww.param][@ww.date name='license.expiryDate' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.text]
                [/@ui.messageBox]
                [#else]
                [@ui.messageBox type='info']
                    [@ww.text name='license.expiry.expiring']
                        [@ww.param][@ww.date name='license.expiryDate' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.text]

                    [@ww.text name='license.contact']
                        [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
                    [/@ww.text]
                [/@ui.messageBox]
                [/#if]
            [#else]
                [#if supportPeriodExpired]
                [@ui.messageBox type='warning']
                    [@ww.text name='license.support.ended.message']
                        [@ww.param][@ww.date name='supportPeriodEnd' format='dd MMMM yyyy'/][/@ww.param]
                        [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
                    [/@ww.text]
                [/@ui.messageBox]
                [#elseif supportPeriodAlmostExpired]
                [@ui.messageBox type='info']
                    [@ww.text name='license.support.ending']
                        [@ww.param][@ww.date name='supportPeriodEnd' format='dd MMMM yyyy'/][/@ww.param]
                        [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
                    [/@ww.text]
                [/@ui.messageBox]
                [/#if]
            [/#if]
        [/#if]
    [/#if]
    [/#assign]

    [@ww.actionerror /]

    [@ui.bambooPanel titleKey="license.existing.title" descriptionKey='license.details.description']
        [#if license??]
            [@ww.label labelKey='license.organisation' name='license.organisation.name' /]
            [@ww.label labelKey='license.datePurchased' ]
                [@ww.param name='value'][@ww.date name='license.purchaseDate' format='dd MMMM yyyy'/][/@ww.param]
            [/@ww.label]
            [@ww.label labelKey='license.type' name='license.description' /]
            [#if allowedNumberOfLocalAgents < 0]
                [@ww.label labelKey='license.allowed.local.agents' name='allowedNumberOfLocalAgents' value='Unlimited' /]
            [#else]
                [@ww.label labelKey='license.allowed.local.agents' name='allowedNumberOfLocalAgents' /]
            [/#if]

            [#if allowedNumberOfRemoteAgents < 0]
                [@ww.label labelKey='license.allowed.remote.agents' name='allowedNumberOfRemoteAgents' value='Unlimited' /]
            [#else]
                [@ww.label labelKey='license.allowed.remote.agents' name='allowedNumberOfRemoteAgents' /]
            [/#if]

             [#if allowedNumberOfPlans gte 0]
                 [@ww.label labelKey='license.allowed.plans' name='allowedNumberOfPlans' /]
             [/#if]


            [#if evaluationLicense]
                [#if license.expired]
                    [@ww.label labelKey='license.expiry.expired' ]
                        [@ww.param name='value'][@ww.date name='license.expiryDate' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.label]
                [#else]
                    [@ww.label labelKey='license.expiry' ]
                        [@ww.param name='value'][@ww.date name='license.expiryDate' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.label]
                [/#if]
            [#else]
                [#if supportPeriodExpired]
                    [@ww.label labelKey='license.support.ended' ]
                        [@ww.param name='value'][@ww.date name='supportPeriodEnd' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.label]
                [#else]
                    [@ww.label labelKey='license.support' ]
                        [@ww.param name='value'][@ww.date name='supportPeriodEnd' format='dd MMMM yyyy'/][/@ww.param]
                    [/@ww.label]
                [/#if]
            [/#if]
        [/#if]

        [@ww.label labelKey='setup.install.sid' name='sid' /]
        [@ww.label labelKey='license.sen' name='supportEntitlementNumber' /]
    [/@ui.bambooPanel]

    [#assign licenseDescription]
        [@ww.text name='license.description' ]
            [@ww.param]${version}[/@ww.param]
            [@ww.param]${sid}[/@ww.param]
        [/@ww.text]
    [/#assign]
    [@ww.form action="updateLicense" submitLabelKey='license.update.license' titleKey='license.update.title' showActionErrors='false']
        ${licensePageInfo}
        [@ui.bambooSection]
            [@ww.textarea labelKey='license' name="licenseString" rows="8" cssClass="license-field" description=licenseDescription /]
        [/@ui.bambooSection]
    [/@ww.form]

</body>
</html>