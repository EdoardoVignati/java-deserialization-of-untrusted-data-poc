[#macro displayBranchIcon]
    <img src='${baseUrl}/images/icons/branch.png' height='16' width='16' align='absmiddle' />&nbsp;[#t]
[/#macro]

[#macro buildNotificationResultLink baseUrl build buildSummary]
    [#assign icon="icon-build-unknown.png"/]
    [#if buildSummary.successful]
        [#assign icon="icon-build-successful.png"/]
    [#elseif buildSummary.failed]
        [#assign icon="icon-build-failed.png"/]
    [/#if]
    [@buildNotificationPlanOrResultLink baseUrl build icon buildSummary.buildNumber/]
[/#macro]

[#macro buildNotificationPlanOrResultLink baseUrl build icon buildNumber]
    [#if icon?has_content]<img src='${baseUrl}/images/iconsv4/${icon}' height='16' width='16' align='absmiddle' />&nbsp;[/#if]<a href='${baseUrl}/browse/${build.planKey.key}[#if buildNumber?has_content]-${buildNumber}[/#if]'>[#t]
    [#if build.parent?has_content]
    ${build.project.name} &rsaquo; [#if build.parent.master?has_content]${build.parent.master.buildName} &rsaquo; [@displayBranchIcon /][/#if]${build.parent.buildName} [#if buildNumber?has_content]&rsaquo; #${buildNumber} [/#if]&rsaquo; ${build.buildName}[#t]
    [#else]
    ${build.project.name} &rsaquo; [#if build.master?has_content]${build.master.buildName} &rsaquo; [@displayBranchIcon /][/#if]${build.buildName} [#if buildNumber?has_content]&rsaquo; #${buildNumber}[/#if][#t]
    [/#if]
    </a>[#t]
[/#macro]

[#macro testSummary buildSummary]
    [#if buildSummary.testResultsSummary.totalTestCaseCount > 0]${buildSummary.testSummary}. [/#if][#t]
[/#macro]

[#macro getUserLink comment baseUrl gravatarUrl=""]
    [#if comment.user?has_content]
        [#if gravatarUrl?has_content]
            <img src='${gravatarUrl}' height='16' width='16' align='absmiddle' />&nbsp;[#t]
        [/#if]
        <a href='${baseUrl}/browse/user/${comment.user.name}'>${comment.user.fullName}</a>[#t]
    [#else]
        Anonymous[#t]
    [/#if]
[/#macro]

