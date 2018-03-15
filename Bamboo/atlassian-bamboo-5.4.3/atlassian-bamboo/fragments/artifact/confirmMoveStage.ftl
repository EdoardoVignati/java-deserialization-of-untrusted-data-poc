[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.MoveStageAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.MoveStageAction" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]
[@ww.form action="moveStage" namespace="/chain/admin/ajax" cssClass="bambooAuiDialogForm"]
    <p class="artifact-delete-definition">[@ww.text name='stage.move.confirm.warning' /]</p>

    [@ww.text name='stage.move.confirm.subscriptions' id='confirmationMsg'/]
    [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='stageId' /]
    [@ww.hidden name='index' /]
    [@ww.hidden name='removeBrokenSubscriptions' value='true' /]
[/@ww.form]