[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]

[@ww.form action="deleteArtifactSubscription" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey='artifact.subscription.delete.form.description']

    [@ww.label labelKey='artifact.subscription.name' name='artifactSubscription.artifactDefinition.name'/]
    [@ww.label labelKey='artifact.subscription.destination' name='destination'/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='subscriptionId' /]
[/@ww.form]