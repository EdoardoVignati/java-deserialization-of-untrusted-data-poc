[#import "/lib/build.ftl" as bd]
<title>[@ww.text name="system.notification.add.title"/]</title>

[@ww.form action='addSystemNotification'
namespace='/admin'
showActionErrors='false'
submitLabelKey='global.buttons.add'
id='systemNotificationForm']
    [@ww.hidden name="returnUrl" /]
    [@bd.configureSystemNotificationsForm  /]
[/@ww.form]