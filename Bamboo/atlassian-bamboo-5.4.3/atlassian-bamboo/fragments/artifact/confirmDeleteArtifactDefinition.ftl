[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="deleteArtifactDefinition" namespace="/ajax"
        cssClass="bambooAuiDialogForm"]

    <p class="artifact-delete-definition">
        [@ww.text name='artifact.definition.delete.definition' ]
            [@ww.param]<strong>${artifactDefinition.name}</strong>[/@ww.param]
        [/@ww.text]
    </p>
    [@ww.text id='deleteSubscriptionsMessage' name='artifact.definition.delete.subscriptions'/]
    [@artifacts.displaySubscribersAndProducersByStage
        subscribedJobs=action.getJobsSubscribedToArtifact(artifactDefinition)
        dependenciesDeletionMessage=deleteSubscriptionsMessage/]

    [@artifacts.displayRelatedDeploymentProjects
        deploymentProjects=action.getDeploymentProjectsUsingArtifact(artifactDefinition)
        messageKey='artifact.definition.delete.unlink.deployments'/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='artifactId' /]
[/@ww.form]