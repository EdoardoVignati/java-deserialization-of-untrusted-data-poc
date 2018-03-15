[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.MoveJobAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.MoveJobAction" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="moveJob" namespace="/chain/admin/ajax" cssClass="bambooAuiDialogForm"]
    <p class="artifact-delete-definition">[@ww.text name='job.move.confirm.warning' /]</p>

    [@ww.text name='job.move.confirm.subscriptions' id='confirmationMsg'/]
    [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg/]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='stageId' /]
    [@ww.hidden name='jobKey' /]
    [@ww.hidden name='removeBrokenSubscriptions' value='true' /]
[/@ww.form]
