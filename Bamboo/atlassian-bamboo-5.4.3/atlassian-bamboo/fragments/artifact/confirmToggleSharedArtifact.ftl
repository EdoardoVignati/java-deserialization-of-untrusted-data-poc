[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="toggleArtifactDefinitionSharing" namespace="/ajax"
        cssClass="bambooAuiDialogForm"]

    <p class="artifact-delete-definition">
        [@ww.text name='artifact.unshare.warning' ]
            [@ww.param]<strong>${artifactDefinition.name}</strong>[/@ww.param]
        [/@ww.text]
    </p>

    [@ww.text id='deletionMessage' name='artifact.unshare.delete.subscriptions'/]
    [@artifacts.displaySubscribersAndProducersByStage
        subscribedJobs=action.getJobsSubscribedToArtifact(artifactDefinition)
        dependenciesDeletionMessage=deletionMessage/]

    [@artifacts.displayRelatedDeploymentProjects
        deploymentProjects=action.getDeploymentProjectsUsingArtifact(artifactDefinition)
        messageKey='artifact.unshare.unlink.deployments'/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='artifactId' /]
    [@ww.hidden name='confirmArtifactUnshared' value='true' /]
[/@ww.form]