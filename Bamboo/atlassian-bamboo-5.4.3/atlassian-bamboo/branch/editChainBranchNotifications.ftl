[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchNotifications" --]

<html>
<head>
[@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.notifications"/>
</head>
<body>

[@ui.header pageKey="branch.notifications" descriptionKey="branch.notifications.description" /]

[@ww.form action="saveChainBranchNotifications" namespace="/branch/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
    [@ww.hidden name="returnUrl" /]
    [@ww.hidden name="planKey" /]
    [@ww.hidden name="buildKey" /]


        [@ww.radio name="branchConfiguration.notificationStrategy"
            listKey="key"
            listValue="key"
            i18nPrefixForValue="branch.notifications"
            showDescription=true
            list=notificationStrategies /]
[/@ww.form]
</body>
</html>
