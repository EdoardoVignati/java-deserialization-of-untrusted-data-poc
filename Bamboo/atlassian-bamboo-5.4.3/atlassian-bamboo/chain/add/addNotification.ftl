[#import "/lib/build.ftl" as bd]
<title>[@ww.text name="notification.add.title" /]</title>

[@ww.form action="configureChainNotification" namespace="/chain/admin/config"
showActionErrors='false'
submitLabelKey="global.buttons.add"
id="notification"]
    [@ww.hidden name="returnUrl" /]
    [@bd.configureBuildNotificationsForm groupEvents=true /]
    [@ww.hidden name="buildKey" value=immutableChain.key/]
[/@ww.form]