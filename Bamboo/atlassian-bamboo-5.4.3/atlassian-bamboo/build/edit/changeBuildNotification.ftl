[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#import "/lib/build.ftl" as bd]

[#if mode?has_content && mode='planCreate']
    <title>6. Notifications</title>
    [#assign updateUrl='/build/admin/create/updateBuildNotification.action?notificationId=${notificationId}' /]
    [#assign cancelUrl='/build/admin/create/defaultBuildNotification.action' /]
    [#assign myMode='planCreate' /]
[#else]
    <title>Configure Notifications</title>
    [#assign updateUrl='/build/admin/edit/updateBuildNotification.action?buildKey=${immutablePlan.key}&notificationId=${notificationId}' /]
    [#assign cancelUrl='/build/admin/edit/editBuildNotification.action?buildKey=${immutablePlan.key}' /]
    [#assign myMode='planConfigure' /]
[/#if]

[#if edit?has_content && edit=="true"]
    [#assign titleKey="build.notification.edit.title" /]
[#else]
    [#assign titleKey="build.notification.add.title" /]
[/#if]

[@ww.form action=updateUrl
          cancelUri=cancelUrl
          submitLabelKey='global.buttons.update'
          id='notificationsForm'
          titleKey='notification.title'
          showActionErrors='false'
]
    [@bd.notificationWarnings /]
    [@bd.existingNotificationsTable /]
    [@bd.configureBuildNotificationsForm /]
[/@ww.form]