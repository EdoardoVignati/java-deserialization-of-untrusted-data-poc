[#include "/build/common/configureBuildStrategy.ftl"]
[@ww.form action=submitAction
    method='POST'
    enctype='multipart/form-data'
    namespace="/chain/admin/config"
    submitLabelKey="chain.trigger.update.button"
    cancelUri="/chain/admin/config/editChainTriggers.action?planKey=${planKey}"
    titleKey="chain.trigger.title"
    cssClass="top-label"]

    [@ww.hidden name="planKey" value=planKey /]
    [@ww.hidden name="triggerId" value=triggerId /]

    [@ww.textfield labelKey="chain.trigger.description" name="triggerDescription" id="triggerDescription"/]
    [@configureBuildStrategy long=true/]
[/@ww.form]