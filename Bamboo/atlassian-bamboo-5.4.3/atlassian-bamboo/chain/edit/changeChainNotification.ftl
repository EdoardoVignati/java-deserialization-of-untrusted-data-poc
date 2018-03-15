[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#import "/lib/build.ftl" as bd]

    <title>Configure Notifications</title>
    [#assign updateUrl='/chain/admin/config/updateChainNotification.action?buildKey=${buildKey}' /]
    [#assign cancelUrl='/chain/admin/config/defaultChainNotification.action?buildKey=${buildKey}' /]
    [#assign titleKey="build.notification.edit.title" /]


[@ww.form action=updateUrl
          cancelUri=cancelUrl
          submitLabelKey='global.buttons.update'
          id='notificationsForm'
          showActionErrors='false'
]
    [@bd.configureBuildNotificationsForm groupEvents=true /]
    [@ww.hidden name='notificationId' /]
[/@ww.form]
