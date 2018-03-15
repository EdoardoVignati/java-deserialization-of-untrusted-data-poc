[#import "/lib/build.ftl" as bd]
<title>[@ww.text name="notification.add.title" /]</title>

[@ww.form action='addEnvironmentNotification' namespace='/deploy/config'
showActionErrors='false'
id='notification'
submitLabelKey='global.buttons.add'
cancelUri='/deploy/config/configureEnvironmentNotifications.action?environmentId=${environmentId}']
    [@ww.hidden name='environmentId' /]
    [@ww.hidden name='deploymentProjectId' /]

    [@bd.configureBuildNotificationsForm i18nPrefix='deployment.notification' groupEvents=true /]
[/@ww.form]
