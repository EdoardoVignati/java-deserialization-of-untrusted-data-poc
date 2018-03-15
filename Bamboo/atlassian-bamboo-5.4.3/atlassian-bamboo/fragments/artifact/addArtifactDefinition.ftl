[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]

[@ww.form action="createArtifactDefinition" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey='artifact.definition.create.form.description'
        submitLabelKey='global.buttons.create']

    [@ww.textfield labelKey='artifact.name' name='name' required=true /]
    [@ww.textfield labelKey='artifact.location' name='location' /]
    [@ww.textfield labelKey='artifact.copyPattern' name='copyPattern' required=true /]
    [@ww.checkbox labelKey='artifact.shared' name='sharedArtifact' toggle='true' /]

    [@ui.bambooSection dependsOn='sharedArtifact' showOn='true']
        [@ui.messageBox type='info']
            [@ww.text name='artifact.shared.long.description' /]
        [/@ui.messageBox]
    [/@ui.bambooSection]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='returnUrl' /]
[/@ww.form]
