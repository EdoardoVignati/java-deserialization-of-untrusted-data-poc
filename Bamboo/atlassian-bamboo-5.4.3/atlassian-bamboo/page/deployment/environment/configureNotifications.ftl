[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentNotifications" --]
[#import "/lib/build.ftl" as bd]

[@ww.text id="title" name="environment.edit.notifications.title"]
    [@ww.param][#if environment??]${environment.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]


<html>
<head>
[@ui.header pageKey=title title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.notifications.howtheywork"][@ww.text name="deployments.notifications.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=title headerElement="h2"/]

[@ui.displayText key="environment.edit.notifications.description"/]

[@bd.notificationWarnings /]

[@ww.url id='addEnvironmentNotificationUrl' value='/chain/admin/ajax/addEnvironmentNotification.action' environmentId=environmentId returnUrl=currentUrl lastModified=lastModified conditionKey=conditionKey notificationRecipientType=notificationRecipientType previousTypeData=previousTypeData saved=true/]
[@cp.displayLinkButton buttonId='addEnvironmentNotification' buttonLabel='chain.config.notifications.add' buttonUrl=addEnvironmentNotificationUrl primary=true/]
[@dj.simpleDialogForm triggerSelector="#addEnvironmentNotification" width=540 height=420 headerKey="notification.add.title" submitCallback="redirectAfterReturningFromDialog" /]

[@bd.existingNotificationsTable
notificationSet=existingNotificationsSet
editUrl='${req.contextPath}/deploy/config/editEnvironmentNotification.action?environmentId=${environmentId}'
deleteUrl='${req.contextPath}/deploy/config/deleteEnvironmentNotification.action?environmentId=${environmentId}'
showColumnSpecificHeading=false
/]

[@dj.simpleDialogForm triggerSelector=".edit-notification" width=540 height=420 headerKey="notification.edit.title" submitCallback="redirectAfterReturningFromDialog" /]

<div class="aui-toolbar inline tasks-back-button">
    <ul class="toolbar-group">
        <li class="toolbar-item">
            <a id="backToDeploymentProject" href="${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}&environmentId=${environmentId}" class="toolbar-trigger">
            [@ww.text name="deployment.environment.task.back" /]
            </a>
        </li>
    </ul>
</div>

</body>
</html>
