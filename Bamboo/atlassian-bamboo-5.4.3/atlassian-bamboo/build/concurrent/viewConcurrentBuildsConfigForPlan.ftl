[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]

[#if action.concurrentBuildsEnabled && planLevelConcurrentBuildConfig.defaultOverridden]
    [#assign labelValue]${planLevelConcurrentBuildConfig.effectiveNumberOfConcurrentBuilds}[#if !planLevelConcurrentBuildConfig.defaultOverridden] (${action.getText('global.default.used')})[/#if][/#assign]
    [@ww.label labelKey='build.concurrent.maxnumber' value='${labelValue}' /]
[/#if]
