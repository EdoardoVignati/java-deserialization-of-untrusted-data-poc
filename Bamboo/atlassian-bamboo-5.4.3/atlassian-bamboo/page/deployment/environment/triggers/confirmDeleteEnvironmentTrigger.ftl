[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.triggers.DeleteEnvironmentTrigger" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.triggers.DeleteEnvironmentTrigger" --]
<meta name="decorator" content="none"/>
[@ww.form   action="deleteEnvironmentTrigger"
namespace="/deploy/config"
submitLabelKey="global.buttons.delete"
cancelUri="/deploy/config/configureEnvironmentTriggers.action?environmentId=${environmentId}"]
    [@ui.messageBox type="warning" titleKey="chain.trigger.delete.confirm" /]

    [@ww.hidden name="triggerId"/]
    [@ww.hidden name="environmentId"/]
[/@ww.form]