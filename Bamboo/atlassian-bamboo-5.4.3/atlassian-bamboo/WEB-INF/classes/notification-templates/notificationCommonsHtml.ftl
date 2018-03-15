[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.plan.Plan" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]

[#include "notificationCommons.ftl"]
[#-- ============================================================================================= @nc.templateOuter --]
[#macro templateOuter baseUrl showTitleStatus=true statusMessage='']
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <style type="text/css">
        a:hover, a:focus, input.postlink:hover, input.postlink:focus { text-decoration: underline !important; }
        
        @media handheld, only screen and (max-device-width: 480px) {
            div, a, p, td, th, li, dt, dd {
                -webkit-text-size-adjust: auto;
            }
            small, small a {
                -webkit-text-size-adjust: 90%;
            }
            small[class=email-metadata] {
                -webkit-text-size-adjust: 93%;
                font-size: 12px;
            }
            
            table[id=email-wrap] > tbody > tr > td {
                padding: 2px !important;
            }
            table[id=email-wrap-inner] > tbody > tr > td {
                padding: 8px !important;
            }
            table[id=email-footer] td {
                padding: 8px 12px !important;
            }
            table[id=email-actions] td {
                padding-top: 0 !important;
            }
            table[id=email-actions] td.right {
                text-align: right !important;
            }
            table[id=email-actions] .email-list-item {
                display: block;
                margin: 1em 0 !important;
                word-wrap: normal !important;
            }
            span[class=email-list-divider] {
                display: none;
            }
            .commentsummary small[class=email-metadata] {
                display: block;
            }
            td.comment-avatar {
                padding: 8px 8px 0 8px !important;
            }
            .comment > td + td {
                padding: 8px 8px 8px 0 !important;
            }
        }
    </style>
</head>
<body>
<table id="email-wrap" align="center" cellpadding="0" cellspacing="0" width="100%">
	<tbody>
    	<tr>
        	<td>
                [#if showTitleStatus]
                    [#if buildSummary??]
                        [#if !statusMessage?has_content]
                            [#assign statusText][#if buildSummary.successful]was successful[#else]failed[/#if][/#assign]
                        [#else]
                            [#assign statusText = statusMessage /]
                        [/#if]
                        [@notificationTitleStatus baseUrl=baseUrl status=getBuildStatus(buildSummary) build=buildSummary.immutablePlan buildResultKey=buildSummary.planResultKey buildNumber=buildSummary.buildNumber statusMessage=statusText /]
                    [#elseif build?? && buildKey?? && buildNumber??]
                        [@notificationTitleStatus baseUrl=baseUrl status="unknown" build=build buildResultKey=buildKey buildNumber=buildNumber statusMessage=statusMessage /]
                    [/#if]
                [/#if]
        		<table id="email-wrap-inner" cellpadding="0" cellspacing="0" width="100%">
	        		<tbody>
	        			<tr>
	        				<td>
				        		[#nested]
	        				</td>
	        			</tr>
	        		</tbody>
        		</table>
                [@showEmailFooter baseUrl=baseUrl /]
        	</td>
    	</tr>
   	</tbody>
	</table>
</body>
</html>
[/#macro]

[#function getBuildStatus buildSummary]
    [#if buildSummary.successful]
        [#return "successful"]
    [#else]
        [#return "failed"]
    [/#if]
[/#function]


[#-- ============================================================================================== @nc.showActions --]
[#macro showActions]
    <table width="100%" cellpadding="0" cellspacing="0" id="email-actions" class="email-metadata">
        <tbody>
            <tr>
                <td class="left">
                    [#nested]
                </td>
            </tr>
        </tbody>
    </table>
[/#macro]


[#-- ================================================================================================ @nc.addAction --]
[#macro addAction name url first=false]
    [#if !first]<span class="email-list-divider">|</span>[/#if]
    <span class="email-list-item"><a href="${url}">${name}</a></span>
[/#macro]

[#macro addMutativeAction name url first=false]
    [#if !first]<span class="email-list-divider">|</span>[/#if]
    <form method="post" action="${url}" class="postlink"><input type="submit" class="postlink email-list-item" value="${name}"/></form>
[/#macro]

[#-- =================================================================================== @nc.notificationTitleBlock --]
[#macro notificationTitleBlock baseUrl='' userName='' flavorHtml='']
    <table id="email-title" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
            <tr>
                <td id="email-title-avatar" rowspan="2" width="56">
                    [@displayGravatar baseUrl userName "48" /]
                </td>
                <td>
                    [#if flavorHtml?has_content]
                        <p id="email-title-flavor" class="email-metadata">${flavorHtml}</p>
                    [/#if]
                </td>
            </tr>
            <tr>
                <td>
                    [#nested]
                </td>
            </tr>
        </tbody>
    </table>
[/#macro]

[#-- =================================================================================== @nc.notificationTitleStatus --]
[#macro notificationTitleStatus baseUrl status build buildResultKey buildNumber statusMessage='']
    <div id="title-status" class="${status}">
        <table cellpadding="0" cellspacing="0" width="100%">
            <tbody>
                <tr>
                    <td id="title-status-icon">
                        [#if status == "successful"]
                            <img src="${baseUrl}/images/iconsv4/icon-build-successful-w.png" alt="Successful">
                        [#elseif status == "failed"]
                            <img src="${baseUrl}/images/iconsv4/icon-build-failed-w.png" alt="Failed">
                        [#else]
                            <img src="${baseUrl}/images/iconsv4/icon-build-unknown-w.png" alt="Unknown">
                        [/#if]
                    </td>
                    <td id="title-status-text">
                        [@displayBuildTitle baseUrl build buildResultKey buildNumber /]
                        <span class="status">${statusMessage?trim}[#if buildSummary??][@showRestartCount buildSummary/][/#if]</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
[/#macro]

[#macro displayBranchIcon]
    <img class="icon-branch" alt="Branch" src="${baseUrl}/images/icons/branch.png"/>[#t]
[/#macro]

[#-- ========================================================================================= @nc.displayBuildTitle --]
[#-- This is just the name of the plan/result not the entire red/green section.--]
[#macro displayBuildTitle baseUrl build buildResultKey buildNumber]
    <span class="build">
        [#if build.parent?has_content]
            <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
            [#if build.parent.master?has_content]
                <a href="${baseUrl}/browse/${build.parent.master.key}/">${build.parent.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
            [/#if]
            <a href="${baseUrl}/browse/${build.parent.key}/">${build.parent.buildName}</a> &rsaquo;
            <a href="${baseUrl}/browse/${build.parent.key}-${buildNumber}/">#${buildNumber}</a> &rsaquo;
            <a href="${baseUrl}/browse/${buildResultKey}/">${build.buildName}</a>
        [#else]
            <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
            [#if build.master?has_content]
                <a href="${baseUrl}/browse/${build.master.key}/">${build.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
            [/#if]
            <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a> &rsaquo;
            <a href="${baseUrl}/browse/${buildResultKey}/">#${buildNumber}</a>
        [/#if]
    </span>
[/#macro]

[#macro displayPlanTitle baseUrl build]
<span class="build">
    [#if build.parent?has_content]
        <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
        [#if build.parent.master?has_content]
            <a href="${baseUrl}/browse/${build.parent.master.key}/">${build.parent.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
        [/#if]
        <a href="${baseUrl}/browse/${build.parent.key}/">${build.parent.buildName}</a> &rsaquo;
        <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a>
    [#else]
        <a href="${baseUrl}/browse/${build.project.key}/">${build.project.name}</a> &rsaquo;
        [#if build.master?has_content]
            <a href="${baseUrl}/browse/${build.master.key}/">${build.master.buildName}</a> &rsaquo; [@displayBranchIcon /]
        [/#if]
        <a href="${baseUrl}/browse/${build.key}/">${build.buildName}</a>
    [/#if]
</span>
[/#macro]

[#-- ====================================================================================== @nc.displayTriggerReason --]

[#macro displayTriggerReason]
    [#if triggerReasonDescription?? && triggerReasonDescription?has_content]
        <p class="trigger">${triggerReasonDescription}</p>
    [/#if]
[/#macro]

[#-- ================================================================================================ @nc.sectionHeader --]

[#macro sectionHeader baseUrl url title utilText='']
    <table width="100%" cellpadding="0" cellspacing="0" class="section-header">
        <tr>
            <td>
                <h3><a href="${url}">${title}</a></h3>
            </td>
            [#if utilText?has_content]
                <td class="utility">
                    <a href="${url}">${utilText}</a>
                </td>
            [/#if]
        </tr>
   </table>
[/#macro]

[#-- ================================================================================================ @nc.displayJobRow --]

[#macro displayJobRow jobResult stageResult]
    <tr>
        <td class="status-icon">
            [#if jobResult.successful]
                <img src="${baseUrl}/images/iconsv4/icon-build-successful.png" alt="Successful">
            [#elseif jobResult.failed]
                <img src="${baseUrl}/images/iconsv4/icon-build-failed.png" alt="Failed">
            [#else]
                <img src="${baseUrl}/images/iconsv4/icon-build-unknown.png" alt="Unknown">
            [/#if]
        </td>
        <td class="[#if jobResult.successful]successful[#elseif jobResult.failed]failed[#else]cancelled[/#if]">
            <a href="${baseUrl}/browse/${jobResult.planResultKey}/">${jobResult.immutablePlan.buildName}</a>
            <span>(${stageResult.name})</span>
        </td>
        <td width="120">
            [#if jobResult.finished]
                ${jobResult.durationDescription}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td width="130">
            [#if jobResult.finished]
                ${jobResult.testSummary}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td class="actions">
            [#if jobResult.finished]
                <a href="${baseUrl}/browse/${jobResult.planResultKey}/log">Logs</a> | <a href="${baseUrl}/browse/${jobResult.planResultKey}/artifact">Artifacts</a>
            [#else]
                &nbsp;
            [/#if]
        </td>
    </tr>
[/#macro]

[#-- ========================================================================================== @nc.showCommitsHtml --]
[#macro showCommits buildSummary baseUrl='']
    [#if buildSummary.commits?has_content]
        [#assign utilText]
            [#if buildSummary.commits?size gt 3]View all ${buildSummary.commits?size} code changes[#else]View full change details[/#if][#t]
        [/#assign]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/commit/" "Code Changes" utilText/]
        <table width="100%" cellpadding="0" cellspacing="0" class="commits">
            [#if buildSummary.repositoryChangesets?has_content]
                [#list buildSummary.repositoryChangesets as repositoryChangeset]
                    [#assign repositoryData=notification.getRepositoryData(repositoryChangeset.repositoryData)/]
                    [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
                        [#if commit_index gte 3][#break][/#if]
                        <tr>
                            <td class="commit-avatar">
                                [@displayGravatar baseUrl commit.author.linkedUserName!""/]
                            </td>
                            <td width="100%">
                                <a href="[@ui.displayAuthorOrProfileLink commit.author/]">${commit.author.fullName?html}</a><br>
                                ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildSummary)}
                            </td>
                            <td class="revision">
                                [#assign guessedRevision = commit.guessChangeSetId()!("")]
                                [#if "Unknown" != commit.author.name &&
                                    guessedRevision?has_content &&
                                    repositoryData.webRepositoryViewer.getWebRepositoryUrlForCommit?? &&
                                    repositoryData.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, repositoryData)?has_content]
                                    [#assign commitUrl = (repositoryData.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, repositoryData))!('') /]
                                    [#if commitUrl?has_content]
                                        <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${guessedRevision?html}</a>
                                    [/#if]
                                [#elseif guessedRevision?has_content]
                                     <span class="revision-id">${guessedRevision?html}</span>
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                [/#list]
                [#if buildSummary.commits?size gt 3]
                    <tr>
                        <td colspan="3">
                            <a href="${baseUrl}/browse/${buildSummary.planResultKey}/commit">${buildSummary.commits?size - 3} more changes&hellip;</a>
                        </td>
                    </tr>
                [/#if]
            [#else]
                <tr>
                    <td>This build does not have any commits.</td>
                </tr>
            [/#if]
        </table>
    [/#if]
[/#macro]

[#-- ========================================================================================== @nc.displayGravatar --]
[#macro displayGravatar baseUrl userName size="24"]
<img src="${ctx.getGravatarUrl((userName)!, size)!(baseUrl + "/images/icons/useravatar.png")}" width="${size}" height="${size}">
[/#macro]


[#-- ========================================================================================== @nc.showCommitsHtmlNoBuildResult --]
[#macro showCommitsNoBuildResult commits baseUrl='' buildKey='']
    [#if commits?has_content]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildKey}/log" "Code Changes"/]
        <table width="100%" cellpadding="0" cellspacing="0" class="commits">
            [#if commits?has_content]
                [#list commits as commit]
                    [#if commit_index gte 3][#break][/#if]
                    <tr>
                        <td class="commit-avatar">
                            [@displayGravatar baseUrl commit.author.linkedUserName!""/]
                        </td>
                        <td width="100%">
                            <a href="[@ui.displayAuthorOrProfileLink commit.author/]">${commit.author.fullName?html}</a><br>
                            ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildKey, buildNumber)}
                        </td>
                        <td class="revision">
                            [#assign guessedRevision = commit.guessChangeSetId()!("")]
                            [#if (build.buildDefinition.repository.hasWebBasedRepositoryAccess())!false && "Unknown" != commit.author.name && guessedRevision?has_content]
                                [#assign commitUrl = (build.buildDefinition.repository.getWebRepositoryUrlForCommit(commit))!('') /]
                                [#if commitUrl?has_content]
                                    <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${guessedRevision?html}</a>
                                [/#if]
                            [#elseif guessedRevision?has_content]
                                 <span class="revision-id">${guessedRevision?html}</span>
                            [/#if]
                        </td>
                    </tr>
                [/#list]
                [#if commits?size gt 3]
                    <tr>
                        <td colspan="3">
                            <a href="${baseUrl}/browse/${buildKey}/commit">${commits?size - 3} more changes&hellip;</a>
                        </td>
                    </tr>
                [/#if]
            [/#if]
        </table>
    [/#if]
[/#macro]

[#-- =========================================================================================== @nc.showFailingJobs --]
[#macro showFailingJobs buildSummary baseUrl]
    [#if buildSummary.failed]
        [#assign failingJob = false/]
        [#assign failingJobs]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/" "Failing Jobs"/]
        <table width="100%" cellpadding="0" cellspacing="0" class="aui failing-jobs">
            <thead>
                <tr>
                    <th colspan="2">Job</th>
                    <th>Duration</th>
                    <th>Tests</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                [#list buildSummary.stageResults as stageResult]
                    [#list stageResult.sortedBuildResults as jobResult]
                        [#if jobResult.failed]
                            [@displayJobRow jobResult stageResult/]
                            [#assign failingJob = true /]
                        [/#if]
                    [/#list]
                [/#list]
                [#if !failingJob]
                    <tr>
                        <td colspan="5">No failed jobs found.</td>
                    </tr>
                [/#if]
            </tbody>
        </table>
        [/#assign]
        [#if failingJob || !(buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()) ]
            ${failingJobs}
        [/#if]
    [/#if]
[/#macro]

[#-- ============================================================================================== @nc.showChainsTests --]
[#macro showChainTests buildSummary baseUrl]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
    [#if buildSummary.testResults??]
        [@showTests buildSummary baseUrl buildSummary.testResults /]
    [/#if]
[/#macro]

[#macro showJobTests buildSummary baseUrl]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
    [#if buildSummary.filteredTestResults??]
        [@showTests buildSummary baseUrl buildSummary.filteredTestResults false /]
    [/#if]
[/#macro]

[#macro showTests buildSummary baseUrl testResults showJob=true]
    [#assign testSummary = buildSummary.testResultsSummary /]
    [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
    [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
    [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
    [#assign numTests=0 /]
    [#assign maxTests=25 /]
    [#if hasExistingFailedTests || hasNewlyFailingTests || hasFixedTests]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.planResultKey}/test" "Tests" "View full test details" /]
        [#if hasNewlyFailingTests]
            [@displayTestList "New Test Failures" testSummary.newFailedTestCaseCount testResults.newFailedTests "${baseUrl}/images/iconsv4/icon-build-failed.png" baseUrl numTests maxTests showJob/]
        [/#if]
        [#if hasExistingFailedTests]
            [@displayTestList "Existing Test Failures" testSummary.existingFailedTestCount testResults.existingFailedTests "${baseUrl}/images/iconsv4/icon-build-failed.png" baseUrl numTests maxTests showJob/]
        [/#if]
        [#if hasFixedTests]
            [@displayTestList "Fixed Tests" testSummary.fixedTestCaseCount testResults.fixedTests "${baseUrl}/images/iconsv4/icon-build-successful.png" baseUrl numTests maxTests showJob/]
        [/#if]
    [/#if]
[/#macro]

[#macro displayTestList title totalCount testList imageUrl baseUrl numTests maxTests showJob=true]
    [#if numTests lt maxTests]
        <h4>${totalCount} ${title}</h4>
        <table width="100%" cellpadding="0" cellspacing="0" class="aui tests">
            <thead>
                <tr>
                    <th colspan="2">Test</th>
                    [#if showJob]
                        <th>Job</th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#list testList.values() as testResult]
                    [#if numTests gte maxTests][#break][/#if]
                    [@displayTest testResult imageUrl baseUrl numTests maxTests showJob/]
                [/#list]
            </tbody>
        </table>
    [/#if]
[/#macro]

[#macro displayTest testResult img baseUrl numTests maxTests showJob=true]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
    [#assign numTests = numTests + 1 /]
    [#assign jobResult = testResult.testClassResult.buildResultsSummary /]
        <tr>
            <td class="status-icon">
                <img src="${img}">
            </td>
            <td>
                <span class="test-class">${testResult.testClassResult.shortName?html}</span>
                <a href="${baseUrl}${fn.getTestCaseResultUrl(jobResult.planKey, jobResult.buildNumber, testResult.testCase.id)}" class="test-name">${testResult.name?html}</a>
            </td>
            [#if showJob]
                <td>
                    <a href="${baseUrl}/browse/${jobResult.planResultKey}/test">${jobResult.immutablePlan.buildName}</a>
                </td>
            [/#if]
        </tr>
[/#macro]

[#macro displayBuildFailureMessage buildSummary totalJobCount=0]
    [#assign testSummary = buildSummary.testResultsSummary /]
    [#if testSummary.totalTestCaseCount == 0]
        [#if buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()]
            [@showMergeDetails buildSummary/]
        [#elseif totalJobCount?? && totalJobCount > 1]
            <strong>${failingJobCount}/${buildSummary.totalJobCount}</strong> jobs failed, no tests found.[#t]
        [#else]
            No failed tests found, a possible compilation error.
        [/#if]
    [#else]
        [#if buildSummary.mergeResult?? && buildSummary.mergeResult.hasFailed()]
            [@showMergeDetails buildSummary/]
        [#elseif totalJobCount?? && totalJobCount > 1]
            <strong>${failingJobCount}/${buildSummary.totalJobCount}</strong> jobs failed with <strong>${testSummary.failedTestCaseCount}</strong> failing test[#if testSummary.failedTestCaseCount != 1]s[/#if].[#t]
        [#else]
            <strong>${testSummary.failedTestCaseCount}/${testSummary.totalTestCaseCount}</strong> tests failed.
        [/#if]
    [/#if]
[/#macro]

[#macro showMergeDetails buildSummary ]
    [#assign repositoryData=notification.getRepositoryData(buildSummary.repositoryChangesets?first)/]
    [#assign mergeResult=buildSummary.mergeResult /]
    <table class="aui" id="mergeResults">
    <tr>
        [#if mergeResult.mergeState == "FAILED"]
            <th>Merge Failed:</th><td><pre>${mergeResult.failureReason?html?trim}</pre></td>
        [#else]
            <th>Push Failed:</th><td><pre>${mergeResult.failureReason?html?trim}</pre></td>
        [/#if]
    </tr>
    [#if (mergeResult.integrationStrategy!"") == "GATE_KEEPER"]
        [#assign checkoutRevision]
            [@showMergeRevision repositoryData mergeResult.integrationBranchVcsKey  mergeResult.integrationRepositoryBranchName /]
        [/#assign]
        [#assign mergedRevision]
            [@showMergeRevision repositoryData mergeResult.branchTargetVcsKey mergeResult.branchName /]
        [/#assign]
        [#assign pushedRevision]
            [@showMergeRevision repositoryData mergeResult.mergeResultVcsKey mergeResult.integrationRepositoryBranchName /]
        [/#assign]
    [#elseif (mergeResult.integrationStrategy!"") == "BRANCH_UPDATER"]
        [#assign checkoutRevision]
            [@showMergeRevision repositoryData mergeResult.branchTargetVcsKey mergeResult.branchName /]
        [/#assign]
        [#assign mergedRevision]
            [@showMergeRevision repositoryData mergeResult.integrationBranchVcsKey mergeResult.integrationRepositoryBranchName /]
        [/#assign]
        [#assign pushedRevision]
            [@showMergeRevision repositoryData mergeResult.mergeResultVcsKey mergeResult.branchName /]
        [/#assign]
    [/#if]
    <tr>
        <th>Checkout:</th><td>${checkoutRevision!}</td>
    </tr>
    <th>Merged From:</th><td>${mergedRevision!}</td>
    [#if pushedRevision?has_content]
        <th>Pushed:</th><td>${pushedRevision!}</td>
    [/#if]
    </table>

[/#macro]

[#macro showMergeRevision repositoryData vcsKey="" branchName="" ]
    [#if vcsKey?has_content]
        [#if branchName?has_content]<span class="branch-name">${branchName?html}:</span>[/#if] [#t]
        [@showRevision vcsKey repositoryData /] [#t]
    [/#if]
[/#macro]

[#macro showRevision revision repositoryData]
    [#if commit??]
        [#assign commitUrl = (repositoryData.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, repositoryData))!('') /]
        [#if commitUrl?has_content]
            <a href="${commitUrl}" class="revision-id" title="View change set in Web Repository Viewer">${revision!?html}</a>
        [#else]
            <span class="revision-id">${revision!}</span>
        [/#if]
    [#else ]
        <span class="revision-id">${revision!}</span>
    [/#if]
[/#macro]
[#-- ============================================================================================== @nc.showLogHtml --]
[#macro showLogs lastLogs='' baseUrl='' buildKey='']
    [#if lastLogs?has_content]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildKey}/log" "Last Logs" /]
        <table width="100%" cellpadding="0" cellspacing="0" class="log">
           [#list lastLogs as log]
                <tr>
                    <th>${log.formattedDate}</th>
                    <td>${log.log}</td>
                </tr>
            [/#list]
        </table>
    [/#if]
[/#macro]

[#-- ====================================================================================== @nc.showEmailFooterHtml --]
[#macro showEmailFooter baseUrl]
<table id="email-footer" cellpadding="0" cellspacing="0" width="100%">
    <tbody>
        <tr>
            <td>
                <p><small>This message was sent by <a href="${baseUrl}">Atlassian Bamboo</a>[#-- ${appProperties.getVersion()}-${appProperties.getBuildNumber()}--].</small></p>
                <p><small>If you wish to stop receiving these emails edit your <a href="${baseUrl}/profile/userNotifications.action">user profile</a> or <a href="${baseUrl}/viewAdministrators.action">notify your administrator</a>.</small></p>
            </td>
        </tr>
    </tbody>
</table>
[/#macro]

