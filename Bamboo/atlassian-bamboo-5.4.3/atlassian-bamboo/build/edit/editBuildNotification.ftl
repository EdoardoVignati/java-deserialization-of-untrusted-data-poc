[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=immutablePlan selectedTab='notifications' titleKey='notification.title']
        [@ww.form action='configureBuildNotification'
              namespace='/build/admin/edit'
              showActionErrors='false'
              id='notification' submitLabelKey='global.buttons.add' cancelUri=currentUrl]
            [@ww.hidden name='buildKey' value=immutablePlan.key /]
            [@bd.notificationWarnings /]
            [@bd.existingNotificationsTable
            editUrl='${req.contextPath}/build/admin/edit/editBuildNotification.action?buildKey=${immutablePlan.key}'
            deleteUrl='${req.contextPath}/build/admin/edit/deleteBuildNotification.action?buildKey=${immutablePlan.key}'
                /]
            [@bd.configureBuildNotificationsForm /]
        [/@ww.form]
[/@ebcc.editConfigurationPage]