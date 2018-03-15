[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.DeleteStageAction" --]

[#assign title]
    [@ww.text name='stage.delete.pagetitle']
        [@ww.param]${stageName}[/@ww.param]
    [/@ww.text]
[/#assign]

<title>${title}</title>
<div class="section">
    [#if immutablePlan.isActive()]
        [@ww.form title='${title}'
                      action='stopPlan' namespace='/build/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${immutablePlan.key}/config#Structure' ]
            [@ww.hidden name="planKey" value="${immutablePlan.key}"/]
            [@ui.messageBox type="warning"]
                [@ww.text name='stage.delete.running']
                    [@ww.param]${stageName}[/@ww.param]
                    [@ww.param]${immutablePlan.getName()}[/@ww.param]
                [/@ww.text]
            [/@ui.messageBox]
        [/@ww.form]
    [#else]
        [@ww.form title='${title}'
                      action='deleteStage' namespace='/chain/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${immutablePlan.key}/stages' ]
            [@ww.hidden name="buildKey"/]
            [@ww.hidden name='stageId'/]
            [@ui.messageBox type="warning"]
                [@ww.text name='stage.delete.description']
                    [@ww.param]${stageName}[/@ww.param]
                    [@ww.param value='${immutableChainStage.getJobs().size()}'/]
                [/@ww.text]
            [/@ui.messageBox]
            [#if jobsContainingInvalidSubscriptions?has_content ]
                [#import "/fragments/artifact/artifacts.ftl" as artifacts/]
                [@ww.text name='job.remove.confirm.subscriptions' id='confirmationMsg'/]
                [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg headerWeight='h3'/]
            [/#if]
        [/@ww.form]
    [/#if]
</div>