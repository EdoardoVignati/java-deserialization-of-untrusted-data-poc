[#-- @ftlvariable name="htmlUtils" type="com.atlassian.bamboo.util.HtmlUtils" --]

[#-- ==================================================================================== @nc.notificationTitleText --]
[#macro notificationTitleText title]
-------------------------------------------------------------------------------
${title}
-------------------------------------------------------------------------------
[/#macro]


[#-- ====================================================================================== @nc.notificationTitleIm --]
[#macro notificationTitleIm title]
${title}
-------------------------------------------------------------------------------
[/#macro]

[#-- ====================================================================================== @nc.buildNotificationTitleText --]
[#macro buildNotificationTitleText build buildSummary]
[#if build.parent?has_content]
${build.project.name} > [#if build.parent.master?has_content]${build.parent.master.buildName} > [/#if]${build.parent.buildName} > #${buildSummary.buildNumber} > ${build.buildName}[#t]
[#else]
${build.project.name} > [#if build.master?has_content]${build.master.buildName} > [/#if]${build.buildName} > #${buildSummary.buildNumber}[#t]
[/#if]
[/#macro]

[#-- ========================================================================================== @nc.showCommitsText --]
[#macro showCommits commits='']
[#if commits?has_content]
--------------
Code Changes
--------------
[#list commits as commit]
[#if commit_index gte 3][#break][/#if]
[#assign guessedRevision = commit.guessChangeSetId()!("")]
${commit.author.fullName}[#if guessedRevision?has_content] (${guessedRevision})[/#if]:

${htmlUtils.addPrefixToLines(">", commit.comment)}

[/#list]
[/#if]
[/#macro]

[#-- ============================================================================================== @nc.showLogText --]
[#macro showLogs lastLogs baseUrl buildKey ]
[#if lastLogs?has_content]

--------------
Last Logs
--------------
[#list lastLogs as log]
${log.formattedDate} |  ${log.unstyledLog}
[/#list]
[/#if]
[/#macro]

[#-- =========================================================================================== @nc.showLogUrlText --]
[#macro showLogUrl baseUrl buildKey ]
${baseUrl}/browse/${buildKey}/log[#lt]
[/#macro]

[#-- ====================================================================================== @nc.showAuthorSummary --]

[#macro showAuthorSummary authors]
[#if authors.size() <= 3]
Change made by [#t]
      [#assign first=true/]
      [#list authors as author]
        [#if author_index gte 3][#break][/#if]
            [#if !first]
                [#if author_has_next]
, [#t]
                [#else]
 and [#rt]
                [/#if]
            [#else]
                [#assign first=false]
            [/#if]
${author.fullName}[#t]
      [/#list]
.[#t]
   [#else]
Change made by ${authors.size()} authors.[#t]
    [/#if]
[/#macro]

[#-- ====================================================================================== @nc.showjobAndTestSummary --]
[#macro showJobAndTestSummary buildSummary executedJobs=0]
[#assign  testSummary = buildSummary.testResultsSummary /]
[#if executedJobs > 0]
    [#assign executedJobCount = executedJobs/]
[#else]
    [#assign executedJobCount = buildSummary.totalJobCount/]
[/#if]
[#assign totalJobCount = buildSummary.totalJobCount/]
[#assign failingJobCount = buildSummary.failedJobResults.size()/]
[#if buildSummary.successful]
    [#if executedJobCount > 1]
        [#if testSummary.totalTestCaseCount == 0]
            All ${executedJobCount} jobs passed[#lt]
        [#else]
            All ${executedJobCount} jobs passed with ${testSummary.successfulTestCaseCount} tests in total.[#lt]
        [/#if]
    [#else]
        [#if testSummary.totalTestCaseCount != 0]
            ${testSummary.totalTestCaseCount} tests in total.[#lt]
        [/#if]
    [/#if]
[#else]
    [#if executedJobCount > 1]
        ${failingJobCount}/${totalJobCount} jobs failed[#t]
        [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
            , no tests found.[#lt]
        [#else]
            , with ${testSummary.failedTestCaseCount} failing test[#if testSummary.failedTestCaseCount != 1]s[/#if][@newFailuresInformation testSummary/].[#lt]
        [/#if]
    [#else]
        [@displayBuildFailureMessage buildSummary/]
    [/#if]
[/#if]
[/#macro]

[#macro displayBuildFailureMessage buildSummary ]
    [#assign testSummary = buildSummary.testResultsSummary /]
    [#if testSummary.failedTestCaseCount == 0]
        [#if buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()]
            [@showMergeDetails buildSummary/][#lt]
        [#else]
            No failed tests found, a possible compilation error.[#lt]
        [/#if]
    [#else]
        ${testSummary.failedTestCaseCount}/${testSummary.totalTestCaseCount} tests failed[@newFailuresInformation testSummary/].[#lt]
    [/#if]
[/#macro]

[#macro newFailuresInformation testSummary]
    [#if testSummary.existingFailedTestCount > 0]
        [#if testSummary.newFailedTestCaseCount == 0]
            , no failures were new[#t]
        [#else]
            , ${testSummary.newFailedTestCaseCount} failure[#if testSummary.newFailedTestCaseCount != 1]s were[#else] was[/#if] new[#t]
        [/#if][#t]
    [/#if]
[/#macro]

[#macro showMergeDetails buildSummary ]

    [#assign mergeResult=buildSummary.mergeResult /]
--------------
    [#if mergeResult.mergeState == "FAILED"]
Merge Failed
    [#else]
Push Failed
    [/#if]
--------------
${mergeResult.failureReason}[#lt]
    [#if (mergeResult.integrationStrategy!"") == "GATE_KEEPER"]
        [#assign checkoutRevision][@showMergeRevision mergeResult.integrationBranchVcsKey  mergeResult.integrationRepositoryBranchName /][/#assign]
        [#assign mergedRevision][@showMergeRevision mergeResult.branchTargetVcsKey mergeResult.branchName /][/#assign]
        [#assign pushedRevision][@showMergeRevision mergeResult.mergeResultVcsKey mergeResult.integrationRepositoryBranchName /][/#assign]
    [#elseif (mergeResult.integrationStrategy!"") == "BRANCH_UPDATER"]
        [#assign checkoutRevision][@showMergeRevision mergeResult.branchTargetVcsKey mergeResult.branchName /][/#assign]
        [#assign mergedRevision][@showMergeRevision mergeResult.integrationBranchVcsKey mergeResult.integrationRepositoryBranchName /][/#assign]
        [#assign pushedRevision][@showMergeRevision mergeResult.mergeResultVcsKey mergeResult.branchName /][/#assign]
    [/#if]
Checkout: ${checkoutRevision!}
Merged From: ${mergedRevision!}
[#if pushedRevision?has_content]
Pushed: ${pushedRevision!}
[/#if]
[/#macro]

[#macro showMergeRevision vcsKey="" branchName="" ]
[#if vcsKey?has_content][#if branchName?has_content]${branchName?html} - [/#if]${vcsKey!}[/#if][#t]
[/#macro]
[#-- ====================================================================================== @nc.showTestSummary --]

[#macro showTestSummary testSummary]
[#if buildSummary.successful]
    (with ${testSummary.successfulTestCaseCount} test[#if testSummary.successfulTestCaseCount !=1]s[/#if])[#t]
[#else]
    (${testSummary.failedTestCaseCount} test[#if testSummary.failedTestCaseCount != 1]s[/#if] failed[#t]
    [#if testSummary.existingFailedTestCount > 0]
        , [#t]
        [#if testSummary.newFailedTestCaseCount == 0]
            no failures were new[#t]
        [#else]
            ${testSummary.newFailedTestCaseCount?string} failure[#if testSummary.newFailedTestCaseCount != 1]s were[#else] was[/#if] new[#t]
        [/#if]
    [/#if]
)[#t]
[/#if]
[/#macro]

[#-- ====================================================================================== @nc.displayChainsTestList --]

[#macro displayChainsTestList title count testList]
[#if numTests lt maxTests]
${title} (${count})
  [#list testList.values() as testResult]
    [#if numTests gte maxTests][#break][/#if]
    [@displayTest testResult/]
  [/#list]
[/#if]
[/#macro]

[#macro displayTest testResult]
    [#assign numTests = numTests + 1 /]
   - ${testResult.testClassResult.shortName}: ${testResult.methodName}
[/#macro]

[#-- ====================================================================================== @nc.displayJob --]

[#macro displayJob  jobResult stageResult]
  - ${jobResult.immutablePlan.buildName} (${stageResult.name}): [@getTestDescription jobResult.testResultsSummary/]
[/#macro]

[#macro getTestDescription testSummary]
[#if testSummary.totalTestCaseCount == 0]
No tests found.[#t]
[#elseif testSummary.failedTestCaseCount != 0]
${testSummary.failedTestCaseCount} of ${testSummary.totalTestCaseCount} tests failed.[#t]
[#else]
${testSummary.totalTestCaseCount} tests passed.[#t]
[/#if]
[/#macro]

[#-- ====================================================================================== @nc.showEmailFooterText --]
[#macro showEmailFooter]
--
This message is automatically generated by Atlassian Bamboo
[/#macro]

