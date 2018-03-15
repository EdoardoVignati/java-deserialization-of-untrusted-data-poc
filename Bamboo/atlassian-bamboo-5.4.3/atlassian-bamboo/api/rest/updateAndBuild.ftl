[#-- @ftlvariable name="action" type="com.atlassian.bamboo.v2.ww2.build.TriggerRemoteBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.v2.ww2.build.TriggerRemoteBuild" --]
<response>
    [#if immutablePlan??]
    <success>A build of ${immutablePlan.planKey} was triggered by remote http call.</success>
    [/#if]
</response>