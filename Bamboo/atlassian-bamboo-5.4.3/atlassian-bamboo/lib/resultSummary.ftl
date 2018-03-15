[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="buildStatusHelper" type="com.atlassian.bamboo.build.BuildStatusHelper" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#-- @ftlvariable name="currentlyBuilding" type="com.atlassian.bamboo.v2.build.CurrentlyBuilding" --]
[#-- @ftlvariable name="repositoryChangeset" type="com.atlassian.bamboo.resultsummary.vcs.RepositoryChangeset" --]
[#-- @ftlvariable name="mergeResult" type="com.atlassian.bamboo.chains.branches.MergeResultSummary" --]

[#-- =========================================================================================== @ps.buildResultLink --]
[#macro buildResultLink buildKey buildNumber][#rt]
    <a href="[@ww.url value='/browse/${buildKey}-${buildNumber}'/]" class="buildLink">#${buildNumber}</a>[#t]
[/#macro][#lt]

[#-- ============================================================================================== @ps.brsStatusBox --]
[#macro brsStatusBox buildSummary filteredRepositoryChangesets agent='' prefix="buildResult"]
    [#assign isJob = (buildSummary.immutablePlan.type == "JOB") /]
    [#if buildSummary.finished]
        [#assign iconClass=buildSummary.buildState /]
    [#else]
        [#assign iconClass=buildSummary.lifeCycleState /]
    [/#if]
    [#if isJob]
        [@ww.text id="buildType" name="job.common.title" /]
    [#else]
        [@ww.text id="buildType" name="build.common.title" /]
    [/#if]
    [#assign buildResult=buildResults! /]
    [#assign testSummary= buildSummary.testResultsSummary /]
    [#assign buildResultKey=buildSummary.planResultKey /]

    [#if !isJob]<h2>Details</h2>[/#if]
    <dl class="details-list">
        [#if buildSummary.waiting]
            [#if currentlyBuilding??]
                [#if currentlyBuilding.hasExecutableAgents()]
                    <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
                    <dd>
                        [@ww.text name='queue.status.waiting.canBuildOnAgents']
                            [@ww.param]
                                [#list currentlyBuilding.executableBuildAgents as agent]
                                    [#if agent_index == 3]
                                        [#if fn.hasAdminPermission()]
                                            [@ww.url id='viewAgentsUrl' action='viewAgents' namespace='/admin/agent' planKey=immutablePlan.key /]
                                        [#else]
                                            [@ww.url id='viewAgentsUrl' action='viewAgents' namespace='/agent' planKey=immutablePlan.key /]
                                        [/#if]
                                        [#if immutablePlan.type == "JOB"]<a href="${viewAgentsUrl}">[#rt /][/#if]
                                            [@ww.text name='buildResult.agent.more']
                                                [@ww.param name="value"]${currentlyBuilding.executableBuildAgents.size() - 3}[/@ww.param]
                                            [/@ww.text]
                                        [#if immutablePlan.type == "JOB"]</a>[#lt /][/#if]
                                        [#break]
                                    [/#if]
                                    [@ui.renderAgentNameLink agent/][#rt /]
                                    [#if agent_has_next && agent_index < 2], [/#if][#lt/]
                                [/#list]
                            [/@ww.param]
                        [/@ww.text]
                    </dd>
                    [#if currentlyBuilding.executableElasticImages?has_content]
                        <dd>
                            [#if fn.hasAdminPermission() ]
                                [@ww.text name='queue.status.waiting.elastic.admin.full']
                                    [@ww.param name="value"]${manageElasticInstancesUrl}[/@ww.param]
                                [/@ww.text]
                            [#else]
                                [@ww.text name='queue.status.waiting.elastic' /]
                            [/#if]
                        </dd>
                    [/#if]
                [#elseif currentlyBuilding.executableElasticImages?has_content]
                    <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
                    <dd>
                        [@ww.text name='queue.status.cantBuild.elastic.full']
                            [@ww.param name="value"]${manageElasticInstancesUrl}[/@ww.param]
                        [/@ww.text]
                    </dd>
                [#elseif currentlyBuilding.executableAgentInfoInitialized]
                    <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
                    <dd>[@ww.text name='queue.status.cantBuild' /]</dd>
                [/#if]
                <dt class="queued">[@ww.text name="buildResult.queued"/]</dt>
                <dd>[@ui.time datetime=currentlyBuilding.queueTime]${currentlyBuilding.queueTime?datetime?string} &ndash; <span>${buildSummary.relativeQueueDate!}</span>[/@ui.time]</dd>
            [#elseif isJob]
                <dt class="status">Status</dt>
                <dd>[@ww.text name='queue.status.waiting.notCurrentStage' /]</dd>
            [/#if]
        [#elseif buildSummary.inProgress]
            [#if buildSummary.buildDate?has_content]
                <dt class="started">[@ww.text name="buildResult.started"/]</dt>
                <dd>
                    [@ui.time datetime=buildSummary.buildDate]${buildSummary.buildDate?datetime?string} &ndash; <span>${buildSummary.relativeBuildStartedDate}</span>[/@ui.time]
                </dd>
            [/#if]
        [#elseif buildSummary.finished]
            [#if buildSummary.buildCompletedDate?has_content]
                <dt class="completed">[@ww.text name="buildResult.completed"/]</dt>
                <dd>
                    [@ui.time datetime=buildSummary.buildCompletedDate]${buildSummary.buildCompletedDate?datetime?string} &ndash; <span>${buildSummary.relativeBuildDate}</span>[/@ui.time]
                </dd>
            [/#if]
            [#if buildSummary.processingDuration > 0]
                <dt class="duration">[@ww.text name="buildResult.duration"/]</dt>
                <dd>[#rt]
                    [#if buildSummary.queueTime?? && buildSummary.vcsUpdateTime?? && buildSummary.buildDate??]
                        <span id="build-duration-description">${buildSummary.processingDurationDescription}</span>
                        [@dj.tooltip target='build-duration-description' addMarker=true]
                            <span id="queueTime">[@ww.text name="buildResult.queued.sentence"][@ww.param]${durationUtils.getRelativeDate(buildSummary.queueTime,buildSummary.vcsUpdateTime)}[/@ww.param][/@ww.text]</span><br />
                            <span id="vcsUpdateTime">[@ww.text name="buildResult.vcsupdate.sentence"][@ww.param]${durationUtils.getRelativeDate(buildSummary.vcsUpdateTime,buildSummary.buildDate)}[/@ww.param][/@ww.text]</span>
                        [/@dj.tooltip]
                    [#else]
                        ${buildSummary.processingDurationDescription}[#t]
                    [/#if]
                </dd>[#lt]
            [/#if]
        [#elseif buildSummary.notBuilt || !buildResult?has_content]
            [#if !buildSummary.queueTime??]
                <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                [#if buildSummary.notRunYet]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.notRunYet"/]</dd>
                [#else]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.triggeredButNotQueued"/]</dd>
                [/#if]
            [#else]
                <dt class="queued">[@ww.text name="buildResult.queued"/]</dt>
                <dd>[@ui.time datetime=buildSummary.queueTime]${buildSummary.queueTime?datetime?string}[/@ui.time]</dd>
                [#if isJob && !buildSummary.buildAgentId??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.notPickedUpByAgent"/]</dd>
                [#elseif isJob && !buildSummary.vcsUpdateTime??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.workspaceNotUpdated"/]</dd>
                [#elseif isJob && !buildSummary.buildDate??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>
                        [@ww.text name="buildResult.summary.status.notBuilt.workspaceUpdatedNotExecuted"]
                            [@ww.param][@ui.time datetime=buildSummary.vcsUpdateTime]${buildSummary.vcsUpdateTime?datetime?string}[/@ui.time][/@ww.param]
                        [/@ww.text]
                    </dd>
                [#else]
                    [#if isJob]
                        <dt class="source-updated">[@ww.text name="buildResult.vcsupdate"/]</dt>
                        <dd>[@ui.time datetime=buildSummary.vcsUpdateTime]${buildSummary.vcsUpdateTime?datetime?string}[/@ui.time]</dd>
                    [/#if]
                    [#if buildSummary.buildDate??]
                        <dt class="started">[@ww.text name="buildResult.started"/]</dt>
                        <dd>[@ui.time datetime=buildSummary.buildDate]${buildSummary.buildDate?datetime?string}[/@ui.time]</dd>
                    [/#if]
                    [#if buildSummary.buildCompletedDate??]
                        <dt class="completed">[@ww.text name="buildResult.completed"/]</dt>
                        <dd>
                            [@ui.time datetime=buildSummary.buildCompletedDate]${buildSummary.buildCompletedDate?datetime?string} &ndash; <span>${buildSummary.relativeBuildDate}</span>[/@ui.time]
                        </dd>
                    [/#if]
                [/#if]
            [/#if]
            [#if buildSummary.buildCancelledDate??]
                <dt class="cancelled">[@ww.text name="buildResult.cancelled"/]</dt>
                <dd>[@ui.time datetime=buildSummary.buildCancelledDate]${buildSummary.buildCancelledDate?datetime?string}[/@ui.time]</dd>
            [#else]
                <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                [#if buildSummary.queueTime?? && !(isJob && !buildSummary.vcsUpdateTime??) && buildSummary.buildDate?? && !buildSummary.buildCompletedDate??]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.startedbutunknown"/]</dd>
                [#elseif isJob && action.getPreviousFailedStageResult(buildSummary)??]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.previousStageFailed"]
                            [@ww.param]${action.getPreviousFailedStageResult(buildSummary).getName()}[/@ww.param]
                        [/@ww.text]</dd>
                [#elseif !buildSummary.notRunYet]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.unknown"/]</dd>
                [/#if]
            [/#if]
        [/#if]
        [#if buildSummary.onceOff || buildSummary.rebuild || buildSummary.customBuild]
            <dt class="flags">[@ww.text name="buildResult.flags"/]</dt>
            <dd>
                [#if buildSummary.onceOff][@ui.lozenge colour="complete" textKey="buildResult.flags.customRevision"/][/#if]
                [#if buildSummary.rebuild][@ui.lozenge colour="moved" textKey="buildResult.flags.rebuild"/][/#if]
                [#if buildSummary.customBuild][@ui.lozenge colour="current" textKey="buildResult.flags.customBuild"/][/#if]
            </dd>
        [/#if]
        [#if !isJob]
            [#import "/fragments/labels/labels.ftl" as lb /]
            [@lb.showLabelEditorForBuild plan=buildSummary.immutablePlan resultsSummary=buildSummary /]
        [/#if]
    </dl>

    [#assign hideDetails = (!isJob) && (!buildSummary.notBuilt) && (!buildResult?has_content) && (!buildSummary.active)/]
    <dl class="details-list details-extras[#if hideDetails] hidden[/#if]">
        [#if agent?has_content]
            <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
            <dd>[@ui.renderAgentNameLink agent/]</dd>
        [/#if]

        [#if filteredRepositoryChangesets?has_content]
            <dt class="revision">
                [@ww.text name="buildResult.revision"]
                    [@ww.param name="value" value=buildSummary.repositoryChangesets?size/]
                [/@ww.text]
            </dt>
            <dd>
                [#if buildSummary.repositoryChangesets?size gt 1]
                    <dl>
                    [#list filteredRepositoryChangesets?sort_by("position") as repositoryChangeset]
                        <dt class="repository-name">${repositoryChangeset.repositoryData.name?html}</dt>
                        <dd>[@showCommit plan=buildSummary.immutablePlan repositoryChangeset=repositoryChangeset/]</dd>
                    [/#list]
                    </dl>
                [#else]
                    [@showCommit plan=buildSummary.immutablePlan repositoryChangeset=buildSummary.repositoryChangesets?first/]
                [/#if]
            </dd>
        [/#if]

        [#if buildSummary.finished]
            [#if testSummary.totalTestCaseCount > 0]
                <dt class="test-count">[@ww.text name="buildResult.tests.summary.total"/]</dt>
                <dd>${testSummary.totalTestCaseCount}</dd>
            [/#if]
            [#if buildSummary.successful]
                [#if buildStatusHelper.countSucceedingSince gt 1]
                    <dt class="successful-since">[@ww.text name="buildResult.successfulsince"/]</dt>
                    <dd>[@buildResultLink immutablePlan.key buildStatusHelper.succeedingSinceBuild.buildNumber/] <span>([@ui.time datetime=buildStatusHelper.succeedingSinceBuild.buildCompletedDate]${buildStatusHelper.succeedingSinceBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                [#elseif buildStatusHelper.fixesBuild??]
                    <dt class="first-to-pass-since">[@ww.text name="buildResult.firsttopasssince"/]</dt>
                    <dd>[@buildResultLink immutablePlan.key buildStatusHelper.fixesBuild.buildNumber/] <span>(${buildStatusHelper.fixesBuild.reasonSummary} &ndash; [@ui.time datetime=buildStatusHelper.fixesBuild.buildCompletedDate]${buildStatusHelper.fixesBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                [/#if]
            [#else]
                [#if testSummary??]
                    [#if buildStatusHelper.precedingConsecutiveFailuresCount gte 1]
                        <dt class="failing-since">[@ww.text name="buildResult.failingsince"/]</dt>
                        <dd>[@buildResultLink immutablePlan.key buildStatusHelper.failingSinceBuild.buildNumber/] <span>(${buildStatusHelper.failingSinceBuild.reasonSummary} &ndash; [@ui.time datetime=buildStatusHelper.failingSinceBuild.buildCompletedDate]${buildStatusHelper.failingSinceBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                    [/#if]
                [/#if]
            [/#if]
            [#if buildStatusHelper.fixedInBuild??]
                <dt class="fixed-in">[@ww.text name="buildResult.fixedin"/]</dt>
                <dd>[@buildResultLink immutablePlan.key buildStatusHelper.fixedInBuild.buildNumber/] <span>(${buildStatusHelper.fixedInBuild.reasonSummary})</span></dd>
            [/#if]
            [#if buildSummary.restartCount?? && buildSummary.restartCount > 0]
                <dt class="restarts">[@ww.text name="buildResult.restarted"/]</dt>
                <dd>${buildSummary.restartCount}</dd>
            [/#if]
        [/#if]
    </dl>
    [#if hideDetails]
        <div class="show-more-details" role="button" tabindex="0">[@ww.text name="global.buttons.showMore"/]</div>
        <div class="show-less-details hidden" role="button" tabindex="0">[@ww.text name="global.buttons.showLess"/]</div>

        <script type="text/javascript">
            (function($) {
                var hiddenClass = "hidden",
                    selectors = {
                        extraDetails: ".details-extras",
                        showLess: ".show-less-details",
                        showMore: ".show-more-details"
                    },
                    expand = function (e) {
                        var that = this;
                        $(selectors.extraDetails).slideDown(function () {
                            $(this).removeClass(hiddenClass);
                            $(that).hide().addClass(hiddenClass);
                            $(selectors.showLess).show().removeClass(hiddenClass).focus();
                        });
                    },
                    collapse = function (e) {
                        var that = this;
                        $(selectors.extraDetails).slideUp(function () {
                            $(this).addClass(hiddenClass);
                            $(that).hide().addClass(hiddenClass);
                            $(selectors.showMore).show().removeClass(hiddenClass).focus();
                        });
                    },
                    callOnClickOrEnter = function (func) {
                        return function (e) {
                            if (e.type == "click" || (e.which == jQuery.ui.keyCode.ENTER)) {
                                func.call(this, e);
                            }
                        };
                    };
                $(document)
                    .delegate(selectors.showMore, "click keydown", callOnClickOrEnter(expand))
                    .delegate(selectors.showLess, "click keydown", callOnClickOrEnter(collapse));
            }(AJS.$));
        </script>
    [/#if]

    [#-- Build Hung Information --]
    [#if buildSummary.inProgress && (currentlyBuilding.buildAgentId)?? && (currentlyBuilding.buildHangDetails)??]
        [#assign excessRunningMinutes = (currentlyBuilding.elapsedTime - currentlyBuilding.buildHangDetails.getExpectedBuildTime()) /]
        [@ww.text id="hungWarningTitle" name="buildResult.hung.title"][@ww.param]${currentlyBuilding.buildIdentifier.planResultKey}[/@ww.param][/@ww.text]
        [@ui.messageBox type="warning" title=hungWarningTitle]
            [@ui.displayBuildHungDurationInfoHtml currentlyBuilding.elapsedTime currentlyBuilding.averageDuration currentlyBuilding.buildHangDetails /]
        [/@ui.messageBox]
    [/#if]

    [#if chainExecution?? && chainExecution.stopping]
        [@ui.messageBox type="warning" titleKey="build.currentactivity.build.beingstopped"/]
    [/#if]

    [#-- No failed tests found --]
    [#if buildSummary.finished && !buildSummary.successful && testSummary?? && !testSummary.hasFailedTestResults() && !(buildSummary.mergeResult?has_content && buildSummary.mergeResult.hasFailed())]
        [@ui.messageBox type="warning" titleKey="buildResult.noFailedTestsWarning" /]
    [/#if]
[/#macro]

[#-- ============================================================================================== @ps.showRevision --]
[#macro showRevision revision repositoryData displayCopyLink=true]
    [#assign commitUrl =  (repositoryData.webRepositoryViewer.getWebRepositoryUrlForRevision(revision, repositoryData))! /]
    [#if commitUrl?has_content]
        <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]"> ${revision!} </a>
    [#else ]
        <span class="revision-id" title="[@ww.text name='webRepositoryViewer.error.cantCreateUrl' /]"> ${revision!} </span>
    [/#if]
    [#if displayCopyLink][@ui.copyToClipboard text=revision! /][/#if]
[/#macro]

[#-- ============================================================================== @ps.showBranchIntegrationDetails --]
[#macro showBranchIntegrationDetails resultsSummary]
    [#if resultSummary.mergeResult?has_content]
    [#assign mergeResult=resultsSummary.mergeResult /]
    <div id="branch-integration-details">
        <div class="details">
            <h2>[@ww.text name='buildResult.branchIntegrationDetails.title' /]</h2>
            <dl class="details-list">
                [#assign defaultRepositoryData=action.getRepositoryData(resultsSummary.repositoryChangesets?first)!/]
                [#if (mergeResult.integrationStrategy!"") == "GATE_KEEPER"]
                    [#assign checkoutRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.integrationBranchVcsKey  mergeResult.integrationRepositoryBranchName false /]
                    [/#assign]
                    [#assign mergedRevisionId=mergeResult.branchTargetVcsKey!/]
                    [#assign mergedRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.branchTargetVcsKey mergeResult.branchName false/]
                    [/#assign]
                    [#assign pushedRevisionId=mergeResult.mergeResultVcsKey! ]
                    [#assign pushedRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.mergeResultVcsKey mergeResult.integrationRepositoryBranchName false /]
                    [/#assign]
                [#elseif (mergeResult.integrationStrategy!"") == "BRANCH_UPDATER"]
                    [#assign checkoutRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.branchTargetVcsKey mergeResult.branchName false /]
                    [/#assign]
                    [#assign mergedRevisionId=mergeResult.integrationBranchVcsKey!/]
                    [#assign mergedRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.integrationBranchVcsKey mergeResult.integrationRepositoryBranchName false /]
                    [/#assign]
                    [#assign pushedRevisionId=mergeResult.mergeResultVcsKey! /]
                    [#assign pushedRevision]
                        [@showMergeRevision defaultRepositoryData mergeResult.mergeResultVcsKey mergeResult.branchName false /]
                    [/#assign]
                [/#if]

                <dt>[@ww.text name="buildResult.branchIntegrationDetails.checkout"/]</dt>
                <dd>${checkoutRevision!}</dd>
                [#if mergeResult.mergeState?? && mergeResult.mergeState != "NOT_REQUIRED" && mergeResult.mergeState != "NOT_ATTEMPTED" ]
                    <dt>[@ww.text name="buildResult.branchIntegrationDetails.merged"/]</dt>
                    <dd>${mergedRevision!}
                        [#if mergeResult.mergeState == "SUCCESS"][@ui.icon "successful"/][#else][@ui.icon "failed"/][/#if][#rt]
                        [@ui.copyToClipboard text=mergedRevisionId /][#lt]
                    </dd>
                    [#if mergeResult.mergeState == "FAILED"]
                        <dt>[@ww.text name="buildResult.branchIntegrationDetails.failureReason" /]</dt>
                        [#if mergeResult.failureReason?has_content]
                            <dd class="failure-reason">${mergeResult.failureReason!?html?trim}</dd>
                        [#else]
                            <dd class="failure-reason">[@ww.text name="buildResult.branchIntegrationDetails.failureUnknown" /]</dd>
                        [/#if]
                    [#elseif mergeResult.pushState??]
                        [#if mergeResult.pushState == "FAILED"]
                            <dt>[@ww.text name="buildResult.branchIntegrationDetails.pushed"/]</dt>
                            <dd>${pushedRevision} [@ui.icon "failed"/] [@ui.copyToClipboard text=pushedRevisionId /]</dd>
                            <dt>[@ww.text name="buildResult.branchIntegrationDetails.failureReason" /]</dt>
                            [#if mergeResult.failureReason?has_content]
                                <dd class="failure-reason">${mergeResult.failureReason!?html?trim}</dd>
                            [#else]
                                <dd class="failure-reason">[@ww.text name="buildResult.branchIntegrationDetails.failureUnknown" /]</dd>
                            [/#if]
                        [#elseif mergeResult.pushState == "NOT_REQUIRED"]
                            <dt>[@ww.text name="buildResult.branchIntegrationDetails.pushed"/]</dt>
                            <dd>[@ww.text name="buildResult.branchIntegrationDetails.pushNotRequired"/]<span id="notPushedHint">[@ui.icon type="hint"/]</span>
                                [@dj.tooltip target="notPushedHint"][@ww.text name="buildResult.branchIntegrationDetails.pushNotRequired.hint"/][/@dj.tooltip]
                            </dd>
                        [#elseif mergeResult.pushState == "SUCCESS"]
                            <dt>[@ww.text name="buildResult.branchIntegrationDetails.pushed"/]</dt>
                            <dd>${pushedRevision}[@ui.icon "successful"/][@ui.copyToClipboard text=pushedRevisionId /]</dd>
                        [#elseif mergeResult.pushState == "TO_BE_ATTEMPTED" && resultsSummary.active]
                            <dt>[@ww.text name="buildResult.branchIntegrationDetails.push"/]</dt>
                            <dd>[@ww.text name="buildResult.branchIntegrationDetails.toBeStarted"/]</dd>
                        [/#if]
                    [/#if]
                [/#if]
            </dl>
        </div>
    </div>
    [/#if]
[/#macro]

[#macro showMergeRevision repositoryData vcsKey="" branchName="" displayCopyLink=true]
    [#if vcsKey?has_content]
        [#if branchName?has_content]<span class="branch-name">${branchName?html}</span>[/#if] [#t]
        [@showRevision vcsKey repositoryData displayCopyLink /] [#t]
    [/#if]
[/#macro]

[#-- ================================================================================================ @ps.showCommit --]
[#macro showCommit plan repositoryChangeset]
    [#if repositoryChangeset.changesetId??]
        [#local chain=plan/]
        [#if !chain.repositoryDefinitionMap??]
            [#local chain=plan.parent!/]
        [/#if]

        [#local repositoryData=action.getRepositoryData(repositoryChangeset)/]

        [#if repositoryChangeset.commits?has_content ]
            [#list repositoryChangeset.commits.toArray()?sort_by("date")?reverse as commit]
                [#if commit.changeSetId! == repositoryChangeset.changesetId ]
                    [#local properCommit=commit/]
                    [#local commitUrl = (repositoryData.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, repositoryData))! /]
                    [#local guessedRevision = commit.guessChangeSetId()!""]
                    [#if commitUrl?has_content && guessedRevision?has_content]
                        <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]"> ${guessedRevision} </a>
                        [@ui.copyToClipboard text=guessedRevision /]
                    [#else]
                        <span class="revision-id" title="[@ww.text name='webRepositoryViewer.error.cantCreateUrl' /]"> ${commit.changeSetId!} </span>
                        [@ui.copyToClipboard text=commit.changeSetId! /]
                    [/#if]
                    [#break]
                [/#if]
            [/#list]
        [/#if]
        [#if !properCommit?has_content]
            [#local commitUrl = (repositoryData.webRepositoryViewer.getWebRepositoryUrlForRevision(repositoryChangeset.changesetId, repositoryData))! /]
            [#if commitUrl?has_content]
                <a href="${commitUrl}" class="revision-id" title="[@ww.text name="webRepositoryViewer.viewChangeset" /]"> ${repositoryChangeset.changesetId!} </a>
            [#else ]
                <span class="revision-id" title="[@ww.text name='webRepositoryViewer.error.cantCreateUrl' /]"> ${repositoryChangeset.changesetId!} </span>
            [/#if]
            [@ui.copyToClipboard text=repositoryChangeset.changesetId! /]
        [/#if]
    [/#if]
[/#macro]

[#-- =============================================================================================== @ps.showChanges --]
[#macro showChanges buildResultsSummary]
    [#if buildResultsSummary.commits?has_content ]
        <div id="changesSummary" class="changesSummary">
            <h2>[@ww.text name='buildResult.changes.title' /]</h2>
            [#assign maxChangesToDisplay = 5/]
            [#assign maxChanges = maxChangesToDisplay/]
            [#assign commitCount = 0/]
            [#list buildResultsSummary.repositoryChangesets?sort_by("position") as repositoryChangeset]
                [#if maxChanges gt 0]
                    [#assign repositoryData=action.getRepositoryData(repositoryChangeset)/]
                    [#if repositoryData.webRepositoryViewer?has_content]
                        ${repositoryData.webRepositoryViewer.getHtmlForCommitsSummary(buildResultsSummary, repositoryChangeset, repositoryData, maxChanges)}
                    [#else]
                        [#include "/templates/plugins/webRepository/commonCommitSummaryView.ftl" /]
                    [/#if]
                [/#if]
                [#assign maxChanges = maxChanges - repositoryChangeset.commits?size/]
                [#assign commitCount = commitCount + repositoryChangeset.commits?size/]
            [/#list]
            [#if maxChanges lt 0]
                <p class="moreLink">
                    <a href='[@ww.url value='/browse/${buildResultsSummary.planResultKey}/commit'/]'>
                        [@ww.text name='buildResult.changes.files.more' ]
                            [@ww.param name="value" value="${commitCount + action.getSkippedCommitsCount(buildResultsSummary) - maxChangesToDisplay}"/]
                        [/@ww.text]
                    </a>
                </p>
            [/#if]
        </div>
    [/#if]

    [#if buildResultsSummary.failed && auditLoggingEnabled && configChanged]
        <div class="changesSummary">
            <h2>[@ww.text name='buildResult.configuration.changes.title' /]</h2>
            <p id="configChanges">
                [@ww.url value="/chain/admin/config/viewChainAuditLog.action" id='auditUrl']
                    [#if buildResultsSummary.immutablePlan.type = 'JOB' ]
                        [@ww.param name='planKey']${buildResultsSummary.immutablePlan.parent.planKey}[/@ww.param]
                    [#else]
                        [@ww.param name='planKey']${buildResultsSummary.immutablePlan.planKey}[/@ww.param]
                    [/#if]

                    [#if failStartDate??]
                        [@ww.param name='filterStart']${failStartDate.getTime()}[/@ww.param]
                    [/#if]
                    [@ww.param name='filterEnd']${buildResultsSummary.getBuildCompletedDate().getTime()}[/@ww.param]
                [/@ww.url]

                [@ww.text name='buildResult.config.changes' ]
                    [@ww.param]${auditUrl}[/@ww.param]
                [/@ww.text][#t]
            </p>
        </div>
    [/#if]
[/#macro]

[#-- =========================================================================================== @ps.showBuildErrors
    type can have "chain" or "job" as values
--]
[#-- @ftlvariable name="extraBuildResultsData" type="com.atlassian.bamboo.results.ExtraBuildResultsData" --]
[#-- @ftlvariable name="buildResultSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#macro showBuildErrors buildResultSummary extraBuildResultsData='' type="job" header="" ]
    [#if buildResultSummary?? && extraBuildResultsData?has_content && extraBuildResultsData.buildErrors?has_content]
        [@ww.url id='errorUrl' value="/browse/${buildResultSummary.planResultKey}/log" /]
        <h2>[#rt]
            [#if header?has_content]
                ${header} [#t]
            [#else]
                <a href="${errorUrl}">[@ww.text name='buildResult.error.summary.job.title' /]</a>[#t]
            [/#if]
        </h2>[#lt]
        <p class="build-errors-status">
            [@ww.text name='buildResult.error.summary.${type}.description']
                [@ww.param]${errorUrl}[/@ww.param]
            [/@ww.text]
        </p>
        <div class="code">
            [#list extraBuildResultsData.buildErrors as error]
                ${htmlUtils.getAsPreformattedText(error)}<br/>
            [/#list]
        </div> <!-- END .code -->
    [/#if]
[/#macro]
