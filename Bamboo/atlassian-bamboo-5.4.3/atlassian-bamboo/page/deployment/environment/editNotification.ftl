[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
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
[@ww.form
action='updateEnvironmentNotification'
namespace='/deploy/config'
        cancelUri='/deploy/config/configureEnvironmentNotifications.action?environmentId=${environmentId}'
        submitLabelKey='global.buttons.update'
        id='notificationsForm'
        showActionErrors='false']
    [@bd.configureBuildNotificationsForm i18nPrefix='deployment.notification' /]
    [@ww.hidden name='environmentId' /]
    [@ww.hidden name='notificationId' /]
    [@ww.hidden name='deploymentProjectId' /]
[/@ww.form]
</body>
</html>
