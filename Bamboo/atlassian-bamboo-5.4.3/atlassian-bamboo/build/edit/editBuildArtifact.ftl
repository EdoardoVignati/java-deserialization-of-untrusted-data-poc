[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/lib/build.ftl" as bd]
[#import "editBuildConfigurationCommon.ftl" as ebcc/]

<script type="text/javascript">
    function createArtifactDefinitionCallback(result) {
        window.location.reload(true);
    }

    function createArtifactSubscriptionCallback(result) {
        window.location.reload(true);
    }
</script>

[#assign artifactDefinitionTools]
    [@ww.text id='createArtifactDefinitionTitle' name='artifact.definition.create' /]
    [@ww.url  id='createArtifactDefinitionUrl' value='/ajax/addArtifactDefinition.action' planKey=planKey returnUrl=currentUrl/]
    [@cp.displayLinkButton buttonId='createArtifactDefinitionButton' buttonLabel=createArtifactDefinitionTitle buttonUrl=createArtifactDefinitionUrl /]
[/#assign]

[@ebcc.editConfigurationPage descriptionKey='artifact.definition.description' plan=immutablePlan selectedTab='artifacts' titleKey='artifact.definition.title' tools=artifactDefinitionTools]

    [@dj.simpleDialogForm
        triggerSelector="#createArtifactDefinitionButton"
        width=700 height=460
        submitCallback="createArtifactDefinitionCallback"
    /]

    [@ui.bambooPanel titleKey='' auiToolbar=artifactDefinitionTools content=true ]
        [@bd.displayArtifactDefinitions artifactDefinitions=artifactDefinitions showOperations=true planIsUsedInDeployments=planUsedInDeployments/]
    [/@ui.bambooPanel]

    [@ui.renderWebPanels 'job.configuration.artifact.definitions'/]

    [#if artifactSubscriptionPossible]
        [#assign artifactSubscriptionTools]
            [@ww.text id='createArtifactSubscriptionTitle' name='artifact.subscription.create' /]
            [@ww.url  id='createArtifactSubscriptionUrl' value='/ajax/addArtifactSubscription.action' planKey=planKey returnUrl=currentUrl/]
            [@cp.displayLinkButton buttonId='createArtifactSubscriptionButton' buttonLabel=createArtifactSubscriptionTitle buttonUrl=createArtifactSubscriptionUrl /]
        [/#assign]

        [@dj.simpleDialogForm
            triggerSelector="#createArtifactSubscriptionButton"
            width=700 height=300
            submitCallback="createArtifactSubscriptionCallback"
        /]

        [@ui.bambooPanel titleKey='artifact.consumed.title' descriptionKey='artifact.consumed.description' auiToolbar=artifactSubscriptionTools content=true ]
            [@bd.displayArtifactSubscriptions artifactSubscriptions=artifactSubscriptions showOperations=true/]
        [/@ui.bambooPanel]
    [/#if]

    [#if featureManager.getBuildArtifactSizeLimit().isDefined()]
        [@ui.bambooPanel titleKey='artifact.size.quota.title']
            [@ui.messageBox type='warning']
                [@ww.text name='artifact.size.quota.exceeded.info']
                    [@ww.param ]${action.getNiceSizeMessage(featureManager.getBuildArtifactSizeLimit().get())}[/@ww.param]
                [/@ww.text]
            [/@ui.messageBox]
        [/@ui.bambooPanel]
    [/#if]

    [@ui.renderWebPanels 'job.configuration.artifact.subscriptions'/]
[/@ebcc.editConfigurationPage]