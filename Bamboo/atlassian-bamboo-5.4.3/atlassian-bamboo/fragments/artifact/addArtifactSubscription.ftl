[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]

[@ww.form action="createArtifactSubscription" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey='artifact.subscription.create.description'
        submitLabelKey='global.buttons.create']

    [@ww.select labelKey='artifact.subscription.name' name='artifactDefinitionId' list=availableArtifacts groupBy='producerJob.stage.name' listKey='id' listValue='name' headerKey='' headerValue='Select\x2026' required=true /]
    [@ww.textfield labelKey='artifact.subscription.destination' name='destination' /]
    [@ww.hidden name='planKey' /]
    [@ww.hidden name='returnUrl' /]
[/@ww.form]