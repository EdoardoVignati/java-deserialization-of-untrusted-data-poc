[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]

[#if activityLog?has_content]
   [@ui.displayLogLines activityLog  /]
[#else]
    <p>[@ww.text name='build.activity.log'/]</p>
[/#if]