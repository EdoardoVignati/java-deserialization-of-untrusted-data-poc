[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#assign nextFireTimeText ]
    [#if action.trigger?has_content]
        [#assign nextFireTime = (action.trigger.nextFireTime)! /]
        [#if nextFireTime?has_content]
        ${(nextFireTime?datetime)}
        <span class="small grey">(in ${durationUtils.getRelativeToDate(nextFireTime.time)})</span>
        [#else]
            [@ww.text name='elastic.schedule.noFireTime' /]
        [/#if]
    [#else]
        [@ww.text name='elastic.schedule.noFireTime' /]
    [/#if]
[/#assign]
<html>
<head>
    <title>[@ww.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
[@ui.header pageKey='buildExpiry.heading' descriptionKey='buildExpiry.description' /]

[#if buildExpiryConfig??]
    [@ui.bambooPanel titleKey='buildExpiry.form.title']
        [#if buildExpiryConfig.cronExpression?has_content]
            [@ww.label labelKey='cronEditorBean.label' value='${action.getPrettyCronExpression(buildExpiryConfig.cronExpression)!}' /]
            [@ww.label labelKey='buildExpiry.nextFireTime' value='${nextFireTimeText!}' escape="false"/]
        [/#if]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey="buildExpiry.defaultConfigSection.title"]
        [#if buildExpiryConfig.enabled]
            [#include "/admin/build/viewBuildExpiryFragment.ftl" /]
        [#else]
        <p>[@ww.text name='buildExpiry.disabled' /]</p>
        [/#if]
    [/@ui.bambooPanel]

    [@ww.form action='buildExpiry!edit.action' submitLabelKey='global.buttons.edit']
        [@ww.param name='buttons']
            [@cp.displayLinkButton buttonId="runButton" buttonLabel="global.buttons.run" buttonUrl='${req.contextPath}/admin/runBuildExpiry.action' mutative=true/]
        [/@ww.param]
    [/@ww.form]
[#else]
    [@ui.bambooPanel titleKey='buildExpiry.form.title']
        [@ww.label labelKey='buildExpiry.cronExpression' value='${action.getPrettyCronExpression(defaultCronExpression)!}' /]
        [@ww.label labelKey='buildExpiry.nextFireTime' value='${nextFireTimeText!}' escape="false"/]
    [/@ui.bambooPanel]
    [@ui.bambooPanel titleKey="buildExpiry.defaultConfigSection.title"]
    <p>[@ww.text name='buildExpiry.notEnabled' /]</p>
    [/@ui.bambooPanel]
    [@ww.form action='buildExpiry!add.action' submitLabelKey='global.buttons.enable']
        [@ww.param name='buttons']
            [@cp.displayLinkButton buttonId="runButton2" buttonLabel="global.buttons.run" buttonUrl='${req.contextPath}/admin/runBuildExpiry.action' mutative=true/]
        [/@ww.param]
    [/@ww.form]
[/#if]
</body>
</html>
