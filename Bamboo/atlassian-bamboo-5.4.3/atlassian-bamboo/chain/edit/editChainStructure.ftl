[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#import "/lib/chains.ftl" as chains]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[#if fn.hasPlanPermission("ADMINISTRATION", immutableChain)]
    [#assign createStageButton]
        [@ww.url id='addStageUrl' value='/chain/admin/ajax/addStage.action' buildKey=buildKey returnUrl=currentUrl /]
        [@cp.displayLinkButton buttonId='addStage' buttonLabel='chain.config.stages.add' buttonUrl=addStageUrl/]
        [@dj.simpleDialogForm triggerSelector="#addStage" width=540 height=330 headerKey="stage.create" submitCallback="reloadThePage"][/@dj.simpleDialogForm]
    [/#assign]
[/#if]

[@eccc.editChainConfigurationPage descriptionKey='chain.config.stages.description' plan=immutablePlan selectedTab='chain.structure' titleKey='chain.stages.title' tools=(createStageButton)!"" ]

    [#if fn.hasPlanPermission("ADMINISTRATION", immutableChain)]
        <a class="assistive" id="createJob" href="[@ww.url action='addJob' namespace='/chain/admin' buildKey=immutableChain.key /]" title="Create a new Job">Create Job</a>
    [/#if]

    [@chains.stageConfiguration id="editstages" chain=immutableChain relatedDeploymentProjects=relatedDeploymentProjects /]

[/@eccc.editChainConfigurationPage]
