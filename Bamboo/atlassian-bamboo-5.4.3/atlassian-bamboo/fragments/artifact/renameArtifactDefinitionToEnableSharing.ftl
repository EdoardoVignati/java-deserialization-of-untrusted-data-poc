[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]

[@ww.form action="updateArtifactDefinition" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey='artifact.definition.shareToggle.rename.form.description']

    [@ww.textfield labelKey='artifact.name' name='name' required=true /]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='artifactId' /]
    [@ww.hidden name='location' /]
    [@ww.hidden name='copyPattern' /]
    [@ww.hidden name='sharedArtifact' value=true /]
[/@ww.form]