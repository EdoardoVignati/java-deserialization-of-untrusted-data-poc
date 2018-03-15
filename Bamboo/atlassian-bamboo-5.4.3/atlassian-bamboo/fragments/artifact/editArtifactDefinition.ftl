[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="updateArtifactDefinition" namespace="/ajax"
        cssClass="bambooAuiDialogForm"]

    [@ww.textfield labelKey='artifact.name' name='name' required=true /]
    [@ww.textfield labelKey='artifact.location' name='location' /]
    [@ww.textfield labelKey='artifact.copyPattern' name='copyPattern' required=true /]
    [@ww.checkbox labelKey='artifact.shared' name='sharedArtifact' toggle='true'/]

    [#if artifactDefinition.subscriptions?has_content]
        [@ui.bambooSection dependsOn='sharedArtifact' showOn=false]
            [@ui.messageBox type="warning"]
                [@ww.text name='artifact.edit.unshare.warning' ]
                    [@ww.param value=artifactDefinition.subscriptions?size /]
                [/@ww.text]
            [/@ui.messageBox]
        [/@ui.bambooSection]
    [/#if]

    [#if artifactDefinition.sharedArtifact]
        [@ui.bambooSection dependsOn='sharedArtifact' showOn=false]
            [@ui.messageBox type="warning"]
                [@artifacts.displayRelatedDeploymentProjects
                    deploymentProjects=action.getDeploymentProjectsUsingArtifact(artifactDefinition)
                    messageKey='artifact.definition.edit.unlink.deployments'
                    showHeader=false/]
            [/@ui.messageBox]
        [/@ui.bambooSection]
    [/#if]

    [@ui.bambooSection dependsOn='sharedArtifact' showOn=true]
        [@ui.messageBox type='info']
            [@ww.text name='artifact.shared.long.description' /]
        [/@ui.messageBox]
    [/@ui.bambooSection]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='artifactId' /]
[/@ww.form]