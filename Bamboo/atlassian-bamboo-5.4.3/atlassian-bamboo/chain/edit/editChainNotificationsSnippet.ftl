[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#import "/lib/build.ftl" as bd]

[@bd.configureBuildNotificationsForm showActionErrors=true groupEvents=true /]

