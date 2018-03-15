[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.triggers.DeleteChainTrigger" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.triggers.DeleteChainTrigger" --]
<meta name="decorator" content="none"/>
[@ww.form   action="deleteChainTrigger"
            namespace="/chain/admin/config"
            submitLabelKey="global.buttons.delete"
            cancelUri="/chain/admin/config/editChainTriggers.action?planKey=${planKey}"]
    [@ui.messageBox type="warning" titleKey="chain.trigger.delete.confirm" /]

    [@ww.hidden name="triggerId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]