[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.plan.DeletePlan" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.plan.DeletePlan" --]

[#if fn.isJob(immutablePlan)]
    [#assign title=action.getText('job.delete')]
[#elseif fn.isBranch(immutablePlan)]
    [#assign title=action.getText('branch.delete')]
[#else]
    [#assign title=action.getText('plan.delete.title')]
[/#if]

<title>${title}</title>
<div class="section">
    [#if immutablePlan.isActive()]
        [@ww.form title='${title}'
                      action='stopPlan' namespace='/build/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${immutablePlan.key}' ]
            [@ww.hidden name="planKey" value="${immutablePlan.key}"/]
            [@ui.messageBox type="warning"]
                [#if fn.isChain(immutablePlan)]
                    [@ww.text name='chain.delete.stop']
                        [@ww.param]'${immutablePlan.getName()}'[/@ww.param]
                        [@ww.param value='${action.getNumberOfExecutions(immutablePlan.planKey)}'/]
                    [/@ww.text]
                [#elseif fn.isJob(immutablePlan)]
                    [@ww.text name='job.delete.stop']
                        [@ww.param]${immutablePlan.getName()}[/@ww.param]
                        [@ww.param]${immutablePlan.parent.getName()}[/@ww.param]
                        [@ww.param value='${action.getNumberOfExecutions(immutablePlan.getParent().getPlanKey())}'/]
                    [/@ww.text]
                [/#if]
            [/@ui.messageBox]
        [/@ww.form]
    [#else]
        [@ww.form title='${title}'
                      action='deleteChain!doDelete' namespace='/chain/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${immutablePlan.key}' ]
            [@ww.hidden name="buildKey"/]
            [@ww.hidden name="returnUrl" /]
            [@ui.messageBox type="warning"]
                [#if fn.isChain(immutablePlan) && !fn.isBranch(immutablePlan)]
                    [@ww.text name='chain.delete.description']
                        [@ww.param]${immutablePlan.getName()}[/@ww.param]
                        [@ww.param value='${action.numberOfChainBranches}'/]
                        [@ww.param value='${immutablePlan.stages.size()}'/]
                        [@ww.param value='${immutablePlan.getJobCount()}'/]
                    [/@ww.text]
                [#elseif fn.isBranch(immutablePlan)]
                    [@ww.text name='branch.delete.description']
                        [@ww.param]${immutablePlan.getName()}[/@ww.param]
                    [/@ww.text]
                [#elseif fn.isJob(immutablePlan)]
                    [@ww.text name='job.delete.description']
                        [@ww.param]${immutablePlan.getName()}[/@ww.param]
                    [/@ww.text]
                [/#if]
            [/@ui.messageBox]

            [#assign linkedDeploymentProjects=linkedDeploymentProjects]
            [#if linkedDeploymentProjects?has_content]
                <div id="linkedDeployments">
                    <h3>[@ww.text name='chain.delete.linkedDeployments.header'/]</h3>
                    <p>[@ww.text name='chain.delete.linkedDeployments.description'/]</p>
                    <ul>
                        [#list linkedDeploymentProjects as deploymentProject]
                            <li>${deploymentProject.name?html}</li>
                        [/#list]
                    </ul>
                </div>
            [/#if]

            [#assign jobsContainingInvalidSubscriptions=jobsContainingInvalidSubscriptions]
            [#if jobsContainingInvalidSubscriptions?has_content ]
                [#import "/fragments/artifact/artifacts.ftl" as artifacts/]
                [@ww.text name='job.remove.confirm.subscriptions' id='confirmationMsg'/]
                [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg headerWeight='h3'/]
            [/#if]
        [/@ww.form]
    [/#if]
</div>