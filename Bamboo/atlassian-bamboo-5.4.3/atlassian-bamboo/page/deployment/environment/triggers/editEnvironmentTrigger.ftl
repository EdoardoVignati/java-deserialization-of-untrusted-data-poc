[#include "/build/common/configureBuildStrategy.ftl"]
[@ww.form action=submitAction
method='POST'
enctype='multipart/form-data'
namespace="/deploy/config"
submitLabelKey="chain.trigger.update.button"
cancelUri="/deploy/config/configureEnvironmentTriggers.action?environmentId=${environmentId}"
titleKey="chain.trigger.title"
cssClass="top-label"]

    [@ww.hidden name="environmentId" value=planKey /]
    [@ww.hidden name="triggerId" value=triggerId /]

    [@ww.textfield labelKey="chain.trigger.description" name="triggerDescription" id="triggerDescription" cssClass="long-field"/]
    [@configureBuildStrategy create=(submitAction=="createEnvironmentTrigger") deployment=true/]
[/@ww.form]
<script type="text/javascript">
    AJS.$("#${submitAction} span.branch-lozenge").tooltip({gravity: 'n'});
</script>
