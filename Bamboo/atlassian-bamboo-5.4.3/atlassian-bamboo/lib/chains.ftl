[#-- @ftlvariable name="stageResults" type="java.util.Collection<com.atlassian.bamboo.chains.ChainStageResult>" --]
[#-- @ftlvariable name="stages" type="java.util.List<com.atlassian.bamboo.chains.ChainStage>" --]
[#-- @ftlvariable name="navObject" type="com.atlassian.bamboo.ww2.beans.DecoratedNavObject" --]
[#-- @ftlvariable name="navigationContext" type="com.atlassian.bamboo.ww2.NavigationContext" --]

[#-- ================================================================================== @chains.liveActivity --]

[#macro liveActivity expandable=true]
[@ww.url id='getBuildsUrl' namespace='/chain/admin/ajax' action='getChains' /]
[@ww.url id='getResultUrl' namespace='/chain/admin/ajax' action='getResult' /]
[@ww.url id='getChangesUrl' value='/rest/api/latest/result/' /]

[@ww.url id='unknownJiraType' value='/images/icons/jira_type_unknown.gif' /]
[@ww.text id='queueEmptyText' name='plan.liveactivity.noactivity' /]
[@ww.text id='cancelBuildText' name='agent.build.cancel' /]
[@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]
[@ww.text id='noAdditionalInfoText' name='plan.liveactivity.build.noadditionalinfo' /]

<div id="liveActivity"[#if !expandable] class="no-expand"[/#if]>
    [#if chainExecution?has_content]
        <ul>
            [#assign buildStatus = "building" /]
            [#list chainExecution as execution]
                [#if execution.stopping]
                    [#assign buildMessage]
                        [@message]
                            [@ww.text name="build.currentactivity.build.beingstopped" /][#t]
                        [/@message]
                    [/#assign]
                    [@chainListItem chainResultKey=execution.planResultKey cssClass=buildStatus triggerReason=execution.getTriggerReason().getNameForSentence()?html planKey=immutableChain.key buildMessage=buildMessage currentStage=currentStageText/]
                [#else]
                    [#assign progressBarText]
                        [#if false]
                        [@ww.text name="build.currentactivity.build.underaverage"]
                        [@ww.param]${durationUtils.getPrettyPrint(execution.elapsedTime,false)}[/@ww.param]
                        [@ww.param]${progressBar.getPrettyTimeRemaining(false)}[/@ww.param]
                        [/@ww.text]
                            [#else]
                            [@ww.text name="build.currentactivity.build.overaverage"]
                            [@ww.param]${durationUtils.getPrettyPrint(execution.elapsedTime,false)}[/@ww.param]
                            [/@ww.text]
                        [/#if]
                    [/#assign]
                    [#if chainExecution.startTime??]
                        [#assign buildMessage]
                            [@dj.progressBar id="pb${execution.planResultKey}" value=0 text=progressBarText cssClass="message" /]
                        [/#assign]
                        [#assign currentStageText]
                            [@currentStage stageName=execution.currentStage.name stageNumber=(execution.currentStage.stageIndex + 1) totalStages=stages.size() /]
                        [/#assign]
                    [#else]
                        [@ww.text id="buildMessage" name="build.currentactivity.waiting"/]
                    [/#if]
                    [@chainListItem chainResultKey=execution.planResultKey cssClass=buildStatus triggerReason=execution.getTriggerReason().getNameForSentence()?html planKey=immutableChain.key buildMessage=buildMessage currentStage=currentStageText/]
                [/#if]
            [/#list]
        </ul>
        [#else]
            <p>${queueEmptyText}</p>
    [/#if]
</div>

<script type="text/x-template" title="buildListItem-template">
    [@chainListItem chainResultKey="{buildResultKey}" cssClass="{cssClass}" triggerReason="{triggerReason}" planKey="{planKey}" buildMessage="{buildMessage}" currentStage="{currentStage}" /]
</script>
<script type="text/x-template" title="buildMessage-template">
    [@message type="{type}"]{text}[/@message]
</script>
<script type="text/x-template" title="jiraIssue-template">
    <li>
        <a title="View this issue" href="{url}?page=com.atlassian.jira.plugin.ext.bamboo%3Abamboo-build-results-tabpanel"><img alt="{issueType}" src="{issueIconUrl}" class="issueTypeImg"/></a>

        <h3><a href="{url}">{key}</a></h3>

        <p class="jiraIssueDetails">{details}</p>
    </li>
</script>
<script type="text/x-template" title="codeChange-changesetLink-template">
    <a href="{commitUrl}" class="revision-id">{changesetId}</a>
</script>
<script type="text/x-template" title="codeChange-changesetDisplay-template">
    <span class="revision-id">{changesetId}</span>
</script>
<script type="text/x-template" title="codeChange-template">
    <li>
        {changesetInfo}
        <img alt="{author}" src="[@ww.url value='/images/icons/businessman.gif' /]" class="profileImage"/>

        <h3><a href="${req.contextPath}/browse/user/{author}">{author}</a></h3>

        <p>{comment}</p>
    </li>
</script>
<script type="text/x-template" title="currentStage-template">
[@currentStage stageName="{stageName}" stageNumber="{stageNumber}" totalStages="{totalStages}" /]
</script>


<script type="text/javascript">
    AJS.$(function ($) {
        LiveActivity.init({
            planKey: "${immutableChain.key}",
            container: $("#liveActivity"),
            getBuildsUrl: "${getBuildsUrl}",
            getResultUrl: "${getResultUrl}",
            getChangesUrl: "${getChangesUrl}",
            queueEmptyText: "${queueEmptyText?js_string}",
            cancellingBuildText: "${cancellingBuildText?js_string}",
            noAdditionalInfoText: "${noAdditionalInfoText?js_string}",
            defaultIssueIconUrl: "${unknownJiraType?js_string}",
            defaultIssueType: "Unknown Issue Type",
            templates: {
                buildListItemTemplate: "buildListItem-template",
                buildMessageTemplate: "buildMessage-template",
                jiraIssueTemplate: "jiraIssue-template",
                codeChangeTemplate: "codeChange-template",
                currentStageTemplate: "currentStage-template",
                codeChangeChangesetLinkTemplate: "codeChange-changesetLink-template",
                codeChangeChangesetDisplayTemplate: "codeChange-changesetDisplay-template"[#if !expandable],
                toggleDetailsButton: null[/#if]
            }
        });
    });
</script>

[/#macro]

[#-- ================================================================================== @chains.message --]

[#macro message type="informative"]
<div class="message ${type}">[#nested]</div>[/#macro]

[#-- ================================================================================== @chains.currentStage --]

[#macro currentStage stageName stageNumber totalStages][#rt]
- executing stage <strong>${stageName}</strong> (stage ${stageNumber} of ${totalStages})[#t]
[/#macro][#lt]

[#macro chainListItem chainResultKey planKey cssClass triggerReason buildMessage="" currentStage=""][#rt]
<li id="b${chainResultKey}" class="${cssClass}">
    <span class="build-description">[#rt]
        <strong><a href="${req.contextPath}/browse/${chainResultKey}">${chainResultKey}</a></strong> <span>${triggerReason}</span> <span class="stage-info">${currentStage}</span>[#t]
    </span>[#lt]
    <a id="stopBuild_${chainResultKey}" href="[@ww.url namespace='/build/admin/ajax' action='stopPlan' /]?planResultKey=${chainResultKey}" class="mutative build-stop">[@ui.icon type="build-stop" text=cancelBuildText /]</a>
${buildMessage}
    <div class="additional-information">
        <div class="issueSummary">
            <h2 class="jiraIssuesHeader">JIRA Issues</h2>
        </div>
        <div class="changesSummary">
            <h2 class="codeChangesHeader">[@ww.text name='buildResult.changes.title' /]</h2>
        </div>
    </div>
</li>
[/#macro]

[#-- ================================================================================== @chains.stageConfiguration --]

[#macro stageConfiguration id chain relatedDeploymentProjects]
    [#local stages = chain.stages/]
    [#local key = chain.key/]
    [#if stages?has_content]
        [@stageList id=id]
            [#list stages as stage]
                [@ww.url id="stageEditLink" value='/chain/admin/ajax/editStage.action' buildKey=key stageId=stage.id returnUrl=currentUrl /]
                [@ww.text id="menuTriggerText" name="menu.actions" /]
                [#local stageStatus]
                    [@ui.standardMenu triggerText=menuTriggerText id="actions-menu-${stage.id}" icon="configure" useIconFont=true subtle=true compact=true iconOnly=true]
                        <li>[@ui.displayLinkForAUIDialog titleKey='stage.configure' id="edit_${stage.id}" href=stageEditLink cssClass="edit-stage"/]</li>
                        [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
                            [@ww.url id='confirmDeleteStageLink' action='confirmDeleteStage' namespace='/chain/admin' buildKey=key stageId=stage.id returnUrl=currentUrl /]
                            <li>[@ui.displayLink href=confirmDeleteStageLink titleKey="stage.delete"/]</li>
                        [/#if]
                    [/@ui.standardMenu]
                [/#local]

                [@stageListItem id=stage.id name=stage.name manual=stage.manual status=stageStatus description=stage.description cssClass="not-collapsible"]
                    [@jobList]
                        [#list stage.jobs.toArray()?sort_by("name") as job]
                            [@ww.url id="editBuildConfigurationLink" action="editBuildConfiguration" namespace="/build/admin/edit" buildKey=job.key /]
                            [@ww.url id="editBuildRequirementLink" action="defaultBuildRequirement" namespace="/build/admin/edit" buildKey=job.key /]
                            [@jobListItem key=job.key name=job.buildName href=editBuildConfigurationLink editBuildRequirementLink=editBuildRequirementLink disabled=job.suspendedFromBuilding agentUnavailabilityHint=action.getAgentUnavailabilityHint(job)]
                                <span class="handle"></span>
                                [#if fn.hasPlanPermission("BUILD", chain) || fn.hasPlanPermission("ADMINISTRATION", chain)]
                                    <ul class="floating-toolbar">
                                        [#if fn.hasPlanPermission("BUILD", chain)]
                                            <li>
                                                [#if job.suspendedFromBuilding]
                                                    [@ww.url id="resumeBuildLink" namespace="/build/admin" action="resumeBuild" buildKey=job.key returnUrl=currentUrl/]
                                                    [@ui.displayLink href=resumeBuildLink titleKey="global.buttons.enable" mutative=true/]
                                                [#else]
                                                    [@ww.url id="suspendBuildLink" namespace="/build/admin" action="suspendBuild" buildKey=job.key returnUrl=currentUrl/]
                                                    [@ui.displayLink href=suspendBuildLink titleKey="global.buttons.disable" mutative=true/]
                                                [/#if]
                                            </li>
                                        [/#if]
                                        [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
                                            [@ww.url id="deleteJobLink" action="deleteChain" namespace="/chain/admin" buildKey=job.key returnUrl=currentUrl /]
                                            <li>[@ui.displayLink href=deleteJobLink titleKey="global.buttons.delete"/]</li>
                                        [/#if]
                                    </ul>
                                [/#if]
                            [/@jobListItem]
                        [/#list]
                        [@createJobListItem chain=chain stage=stage /]
                    [/@jobList]
                [/@stageListItem]
            [/#list]
        [/@stageList]

        <h3>[@ww.text name="stage.deployment.related"/]</h3>
        [#if relatedDeploymentProjects?has_content]
           <p>[@ww.text name='stage.deployment.related.description' /]</p>
            <ul>
                [#list relatedDeploymentProjects as deploymentProject]
                    <li>
                        <a href="[@ww.url action='viewDeploymentProjectEnvironments' namespace='/deploy' returnUrl=currentUrl /]&amp;id=${deploymentProject.id}"
                           title="[@ww.text name='deployment.project.view.config' /]">
                            ${deploymentProject.name}
                        </a>
                    </li>
                [/#list]
            </ul>
        [#else]
            <p>
                [@ww.text name='stage.deployment.description' /]
            </p>
            <p>
                [@ww.url action='newDeploymentProjectDetails'
                        namespace='/deploy/config'
                        planKey=planKey
                        name=action.getText("deployment.project.name.prefix", [ plan.project.name ])
                        returnUrl=currentUrl
                        id="deployUrl"/]

                [#if fn.hasGlobalPermission("CREATE")]
                    [@cp.displayLinkButton buttonId="deployLink" buttonLabel='deployment.project.button.create' buttonUrl=deployUrl/]
                [#else]
                    [@help.url pageKey="deployments.howtheywork"][@ww.text name="deployments.howtheywork.title"/][/@help.url]
                [/#if]
            </p>
        [/#if]
        <script type="text/javascript">
            AJS.$(function () {
                ChainConfiguration.init({
                    $list: AJS.$("#${id}"),
                    moveStageUrl: '[@ww.url action="moveStage" namespace="/chain/admin/ajax" /]',
                    moveJobUrl: '[@ww.url action="moveJob" namespace="/chain/admin/ajax" /]',
                    confirmStageMoveUrl: '[@ww.url action="confirmStageMove" namespace="/chain/admin/ajax" /]',
                    confirmJobMoveJobUrl: '[@ww.url action="confirmJobMove" namespace="/chain/admin/ajax" /]',
                    chainKey: "${key}",
                    canReorder: ${fn.hasPlanPermission("ADMINISTRATION", chain)?string},
                    stageMoveHeader: '[@ww.text name="stage.move.confirm.header"/]',
                    jobMoveHeader: '[@ww.text name="job.move.confirm.header"/]'
                });
            });
            var updateStage = function (data) {
                var $stageTitle = AJS.$("#stage_" + data.stage.id + " > div > dl > dt"),
                    newTitleHTML = data.stage.description ? (data.stage.name + " <span>" + data.stage.description + "</span>") : data.stage.name;
                if (data.stage.manual) {
                    newTitleHTML = newTitleHTML + ' [@ui.icon type="stage-manual" textKey="stage.manual.icon.description" /]';
                }
                $stageTitle.html(newTitleHTML);
            };

            AJS.$(document).delegate(".create-job > a", "click", function (e) {
                e.preventDefault();
                var $trigger = AJS.$(this),
                    dialog = new AJS.Dialog({
                        width: 540,
                        height: 370,
                        keypressListener: function (e) {
                            if (e.which == jQuery.ui.keyCode.ESCAPE) {
                                dialog.remove();
                            }
                        }
                    }),
                    header = $trigger.attr("title");

                dialog.addHeader(header).addCancel("Close", function () { dialog.remove(); });

                AJS.$.ajax({
                    url: $trigger.attr("href"),
                    data: { 'bamboo.successReturnMode': 'json', decorator: 'rest', confirm: true },
                    success: function (html) {
                        var $html = AJS.$(html);

                        dialog.addPanel("", $html).show();
                    },
                    cache: false
                });
            });
        </script>
        [@dj.simpleDialogForm triggerSelector=".edit-stage" width=540 height=330 headerKey="stage.configure" submitCallback="updateStage" /]
        [@dj.simpleDialogForm triggerSelector="#createNewJob" width=740 height=550 headerKey="job.create" submitCallback="reloadThePage" /]
        [@dj.simpleDialogForm triggerSelector="#cloneJob" width=740 height=550 headerKey="job.create.clone" submitCallback="reloadThePage" /]
    [#else]
        <p>[@ww.text name='chain.result.stage.nostages' /]</p>
    [/#if]
[/#macro]

[#-- =================================================================================================== @chains.logMenu --]
[#macro logMenu action plan planType linesToDisplay secondsToRefresh]
<form id="viewPlanActivityLogForm" action="${action}" method="get">
    This page shows
    <select name="linesToDisplay" class="submitOnChange">
        <option value="10"  [#if linesToDisplay == 10]  selected="selected" [/#if]>10</option>
        <option value="25"  [#if linesToDisplay == 25]  selected="selected" [/#if]>25</option>
        <option value="50"  [#if linesToDisplay == 50]  selected="selected" [/#if]>50</option>
        <option value="100" [#if linesToDisplay == 100] selected="selected" [/#if]>100</option>
    </select>
    activity log entries for the <strong>${plan.name}</strong> ${planType}. Refresh:
    <select name="secondsToRefresh" class="submitOnChange">
        <option value="0"  [#if secondsToRefresh == 0] selected="selected" [/#if]>[@ww.text name="chain.logs.never"/]</option>
        <option value="1"  [#if secondsToRefresh == 1]  selected="selected" [/#if]>[@ww.text name="chain.logs.one"/]</option>
        <option value="5" [#if secondsToRefresh == 5] selected="selected" [/#if]>[@ww.text name="chain.logs.five"/]</option>
        <option value="30" [#if secondsToRefresh == 30] selected="selected" [/#if]>[@ww.text name="chain.logs.thirty"/]</option>
    </select>
    [#nested /]
</form>
[/#macro]

[#-- ========================================================================================= @chains.planNavigator --]

[#macro planNavigator navigationContext configMode=false navLocation=""]
    [#if configMode && navigationContext.navObject.master?has_content]
        [#assign navObject=navigationContext.navObject.master/]
    [#else]
        [#assign navObject=navigationContext.navObject/]
    [/#if]
    [#assign currentKey=navigationContext.currentKey/]
    [#assign isExpanded=fn.isJob(navigationContext.currentObject)/]
    [#if !isExpanded && action?? && action.cookieCutter??]
        [#assign isExpanded=(action.cookieCutter.getValueFromConglomerateCookie('AJS.conglomerate.cookie', 'config.sidebar.planNavigator.expanded')!'false')?trim?matches("true")/]
    [/#if]
    [#assign numJobs = 0/]
    [#list navObject.navGroups as stage]
        [#assign numJobs = numJobs + stage.children?size/]
    [/#list]

    [#if navObject?has_content]
        [#if configMode]
            <h2 class="${isExpanded?string("expanded", "collapsed")}" data-sidebar-section="planNavigator" data-item-count="${numJobs}">[@ui.icon type=isExpanded?string("collapse", "expand") /][@ww.text name='navigator.title' /]</h2>
        [#else]
            <h2>[@ww.text name='navigator.title' /]</h2>
        [/#if]
        [#if navObject.navGroups?has_content]
            <ol data-plan-key="${navObject.key}">
                [#list navObject.navGroups as stage]
                    [#assign restartableStage=stage.restartable?? && stage.restartable /]
                    [#assign runnableStage=stage.manual && stage.status?? && stage.runnable]
                    [#assign hasBuildPermission=fn.hasPlanPermissionForKey("BUILD", stage.planKey)/]
                    [#assign hasClassToSet=(stage.status.displayClass)?has_content || stage.manual || restartableStage || runnableStage /]
                    <li id="stage-${stage.id}" [#if hasClassToSet]class="[#if (stage.status.displayClass)?has_content]${stage.status.displayClass} [/#if][#if stage.manual]stage-manual [/#if][#if runnableStage  && hasBuildPermission]stage-runnable[/#if]"[/#if]>
                        <h3 [#if stage.description?has_content] title="${stage.description}"[/#if]>${stage.name}</h3>
                        [#if stage.manual]
                            [#if stage.status??]
                                [#if runnableStage && hasBuildPermission]
                                    [@ww.text id='customisedButtonLabel' name='chain.continue.parameterised.build']
                                        [@ww.param]${stage.name}[/@ww.param]
                                    [/@ww.text]
                                    [@ww.url value=stage.continueUrl id='continueStageUrl' returnUrl=currentUrl /]
                                    <a href="${continueStageUrl}" class="run-custom-stage" title="${customisedButtonLabel}">[@ui.icon type="stage-runnable stageIcon" textKey="stage.manual.continue" showTitle=false /]</a>
                                [#else]
                                    [@ui.icon type="stage-"+stage.status.displayClass+" stageIcon" textKey="stage.manual.icon.description"/]
                                [/#if]
                            [#else]
                                [@ui.icon type="stage-manual stageIcon" textKey="stage.manual.icon.description"/]
                            [/#if]
                        [/#if]
                        <ul>
                            [#list stage.children as job]
                                <li id="job-${job.key}" [#if job.description?has_content] title="${job.description}"[/#if] class="[#if (job.suspendedFromBuilding)!false]disabled [/#if][#if job.key == currentKey]active [/#if][#if job.status??]${job.status.displayClass}[/#if]" data-job-key="${job.key}">
                                    [#if job.status?has_content]
                                        [#if job.status.inProgress]
                                            [#assign execStatus = job.status.executionStatus!/]
                                            [#if execStatus?has_content]
                                                [@dj.progressBar id="navPb${job.key}" value=(100 - (execStatus.progressBar.percentageCompleted * 100))?ceiling /]
                                            [/#if]
                                        [/#if]
                                        [@ui.icon job.status.displayClass + (job.key == currentKey)?string(" icon-reversed", "") /]
                                    [#elseif (job.suspendedFromBuilding)!false]
                                        [@ui.icon "job-disabled" + (job.key == currentKey)?string(" icon-reversed", "") /]
                                    [#else]
                                        [@ui.icon "job" + (job.key == currentKey)?string(" icon-reversed", "") /]
                                    [/#if]
                                    [@ww.url value=navigationContext.getJobUrl(job) id='jobUrl'/]
                                    <a id="navJob_${job.key}" href="${jobUrl}">${job.displayName}</a>
                                </li>
                            [/#list]
                        </ul>
                    </li>
                [/#list]
            </ol>
        [#else]
            <p>[@ww.text name="chain.config.structure.nostages"][@ww.param]<a href="[@ww.url value="/browse/${navObject.key}/stages" /]">[/@ww.param][@ww.param]</a>[/@ww.param][/@ww.text]</p>
        [/#if]
    [/#if]
[/#macro]

[#-- ======================================================================================= @chains.branchNavigator --]

[#macro branchNavigator navigationContext]
    [#if navigationContext.navObject.master?has_content]
        [#assign navObject=navigationContext.navObject.master/]
    [#else]
        [#assign navObject=navigationContext.navObject/]
    [/#if]
    [#assign currentKey=navigationContext.currentKey/]
    [#assign isExpanded=fn.isBranch(navigationContext.currentObject)/]
    [#if !isExpanded && action?? && action.cookieCutter??]
        [#assign isExpanded=(action.cookieCutter.getValueFromConglomerateCookie('AJS.conglomerate.cookie', 'config.sidebar.branchNavigator.expanded')!'false')?trim?matches("true")/]
    [/#if]

    <h2 class="${isExpanded?string("expanded", "collapsed")}" data-sidebar-section="branchNavigator" data-item-count="${navObject.branches?size}">[@ui.icon type=isExpanded?string("collapse", "expand") /][@ww.text name="chain.branches.title" /]</h2>
    [@ww.url value="/browse/{key}/editConfig" id='branchUrl'/]
    [#if navObject.branches?has_content]
        [@branchList branches=navObject.branches urlToReplaceKey=branchUrl activeKey=currentKey uniqueIdPrefix="navBranch_" /]
    [#else]
        <p class="branches">[@ww.text name="chain.config.branches.nobranches"][@ww.param]<a href="[@ww.url namespace="/chain/admin/config" action='configureBranches' buildKey=navObject.key/]">[/@ww.param][@ww.param]</a>[/@ww.param][/@ww.text]</p>
    [/#if]
[/#macro]

[#-- ============================================================================================ @chains.branchList --]

[#macro branchList branches urlToReplaceKey activeKey="" uniqueIdPrefix=""]
    <ul class="branches">
        [#list branches?sort_by("displayName") as branch]
            [#assign classString]
                [#if activeKey == branch.key]
                    active
                [/#if]
                [#if branch.suspendedFromBuilding]
                    disabled
                [/#if]
            [/#assign]
            <li[#if classString?has_content] class="${classString?trim}"[/#if]>
                [@ww.url value="/browse/${branch.key}/editConfig" id='branchUrl'/]
                <a[#if uniqueIdPrefix?has_content] id="${uniqueIdPrefix}${branch.key}"[/#if] href="${urlToReplaceKey?replace("{key}", branch.key, "i")}">${branch.displayName}</a>
            </li>
        [/#list]
    </ul>
[/#macro]

[#-- ========================================================================================== @chains.statusRibbon --]

[#macro statusRibbon navigationContext]
    [#local navObject=navigationContext.navObject/]
    [#local currentObject=navigationContext.currentObject/]
    [#local hasJob=currentObject.parent??/]
    [#if !hasJob]
        [#local operationTimeText = navObject.status.opTimeText!/]
    [/#if]

    [#local buildRibbonContent]
        <span class="assistive">[@ww.text name="build.common.title" /]:</span>
        <a href="${req.contextPath}/browse/${navObject.key}">#${navObject.buildNumber}</a>
        <span[#if hasJob] class="assistive"[/#if]>${navObject.status.summarySuffix} [#rt]
            [#if operationTimeText?has_content][#t]
                <span class="operation-time">${operationTimeText}</span>[#t]
            [/#if][#t]
        </span>[#lt]
        [#if !hasJob && resultsSummary??]
            <span id="triggerReasonDescription" class="trigger-reason"> ${action.getTriggerReasonLongDescriptionHtml(resultsSummary)}</span>
        [/#if]
    [/#local]
    [#local statuses = [{
        "id": "sr-build",
        "state": navObject.status.displayClass,
        "content": buildRibbonContent
    }] /]
    [#if hasJob]
        [#local operationTimeText = currentObject.status.opTimeText!/]
        [#local jobRibbonContent]
            <span>[@ww.text name="job.common.title" /]:</span> ${currentObject.displayName}
            <span>${currentObject.status.summarySuffix} [#rt]
                [#if operationTimeText?has_content][#t]
                    <span class="operation-time">${operationTimeText}</span>[#t]
                [/#if][#t]
            </span>[#lt]
        [/#local]
        [#local statuses = statuses + [{
            "id": "sr-job",
            "state": currentObject.status.displayClass,
            "content": jobRibbonContent,
            "headingTagName": "h3"
        }] /]
    [/#if]
    [#local progressbarContent]
        [#if !hasJob && navObject.status.inProgress && navObject.status.executionStatus?has_content]
            [@dj.progressBar id="sr-pb-${navObject.key}" value=(100 - (navObject.status.executionStatus.progressBar.percentageCompleted * 100))?ceiling /]
        [#elseif hasJob && currentObject.status.inProgress && !currentObject.status.updatingSource && currentObject.status.executionStatus?has_content]
            [@dj.progressBar id="sr-pb-${currentObject.key}" value=(100 - (currentObject.status.executionStatus.progressBar.percentageCompleted * 100))?ceiling /]
        [/#if]
        <script type="text/javascript">
            BAMBOO.BUILDRESULT.BuildResult.init({
                currentKey: "${currentObject.key}",
                getStatusUrl: "[@ww.url value='/rest/api/latest/result/status/' + navObject.key /]"[#if hasJob],
                jobStatus: "${currentObject.status.jobExecutionPhaseString}"[/#if],
                isActive: ${((navObject.status.active)!false)?string}
            });
        </script>
    [/#local]
    ${soy.render("widget.status.statusRibbon", {
        "id": "status-ribbon",
        "statuses": statuses,
        "progressbarContent": progressbarContent,
        "extraClasses": "build-status-ribbon" + hasJob?string(" has-job", "")
    })}
[/#macro]

[#-- Helper/Structural Macros ====================================================================================== --]

[#-- ================================================================================== @chains.stageList --]

[#macro stageList id]
<ul id="${id}" class="stageList">
    [#nested]
</ul>
[/#macro]

[#-- ================================================================================== @chains.stageListItem --]

[#macro stageListItem id name manual status description="" cssClass=""]
<li id="stage_${id}"[#if cssClass?has_content] class="${cssClass}"[/#if]>
    <div>
        <dl>
            <dt>${name}[#if description?has_content] <span>${description?html}</span>[/#if][#if manual] [@ui.icon type='stage-manual' textKey="stage.manual.icon.description"/][/#if]</dt>
            <dd>${status}</dd>
        </dl>
        [#nested]
    </div>
    <div class="arrow"></div>
</li>
[/#macro]

[#-- ================================================================================== @chains.jobList --]

[#macro jobList cssClass=""]
<ul[#if cssClass?has_content] class="${cssClass}"[/#if]>
    [#nested]
</ul>
[/#macro]

[#-- ================================================================================== @chains.jobListItem --]

[#macro jobListItem key name href editBuildRequirementLink="" cssClass="" disabled=false agentUnavailabilityHint=""]
<li id="job_${key}"[#if cssClass?has_content] class="${cssClass}"[/#if]>
    <a href="${href}" id="viewJob_${key}" class="job">${name}</a>
    [#if disabled]
        <span class="disabled">[@ww.text name="build.summary.title.long.suspended"/]</span>
    [/#if]
    [#if agentUnavailabilityHint?has_content]
        [#if editBuildRequirementLink?has_content]
            <a href="${editBuildRequirementLink}" class="noMatchingAgent">${agentUnavailabilityHint}</a>
        [#else]
            <span class="noMatchingAgent">${agentUnavailabilityHint}</span>
        [/#if]
    [/#if]
    [#nested]
</li>
[/#macro]

[#-- ================================================================================== @chains.createJobListItem --]

[#macro createJobListItem chain stage]
    [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
    <li class="create-job">
        <a id="createJob_${stage.id}" href="[@ww.url action='addJob' namespace='/chain/admin' buildKey=chain.key existingStage=stage.name /]" title="[@ww.text name='job.create.add.header.title' /]">[@ui.icon type="add" useIconFont=true /][@ww.text name='job.create.add' /]</a>
    </li>
    [/#if]
[/#macro]

[#-- ================================================================================== @chains.displayBuildResultDetails --]

[#macro displayBuildResultDetails durationDescription testSummary]
<dl>
    <dt class="duration">[@ww.text name="buildResult.summary.duration" /]</dt>
    <dd class="duration">${durationDescription}</dd>
    <dt class="tests">[@ww.text name="buildResult.testClass.tests" /]</dt>
    <dd class="tests">${testSummary}</dd>
</dl>
[/#macro]

[#-- ================================================================================== @chains.displayBuildInProgress --]

[#macro displayBuildInProgress id chainResultKey buildResultKey ]
<a id="stopBuildLink_{id}" class="build-stop" href="${req.contextPath}/build/admin/stopPlan.action?planResultKey={buildResultKey}&amp;returnUrl=/browse/{chainResultKey}">[@ui.icon type="build-stop" textKey="job.stop" /]</a>
[/#macro]

[#-- ================================================================================== @chains.displayJobNoAgentError --]

[#macro displayJobNoAgentError]
<span class="jobError">[@ww.text name='queue.status.cantBuild'/]</span>
[/#macro]

[#macro displaySharedArtifactDefinitions artifactDefinitions]
<table id="artifactDefinitions" class="aui">
    <thead>
    <tr>
        <th>[@ww.text name='job.common.title'/]</th>
        <th>[@ww.text name='artifact.name'/]</th>
        <th>[@ww.text name='artifact.location'/]</th>
        <th>[@ww.text name='artifact.copyPattern'/]</th>
    </tr>
    </thead>
    [#list artifactDefinitions.keySet() as job]
        [#assign jobArtifactDefinitions = artifactDefinitions.get(job)]
        <tbody>
            [#list jobArtifactDefinitions as artifactDefinition]
            <tr id="artifactDefinition-${artifactDefinition.id}">
                [#if artifactDefinition_index = 0]
                    <td rowspan="${jobArtifactDefinitions.size()}">
                        <a id="producerJob-${job.id}" href="${req.contextPath}/browse/${job.key}/config">${job.buildName}</a>
                    </td>
                [/#if]
                <td>
                    <a id="artifactConfig-${artifactDefinition.id}" href="[@ww.url action='defaultBuildArtifact' namespace='/build/admin/edit' buildKey=job.key /]">[@ui.icon type="artifact-shared"/] ${artifactDefinition.name}</a>
                </td>
                <td>${artifactDefinition.location!}</td>
                <td>${artifactDefinition.copyPattern}</td>
            </tr>
            [/#list]
        </tbody>
    [/#list]
</table>
[/#macro]

[#-- ================================================================================== @build.showFullPlanName --]

[#macro showFullPlanName plan url="" icon="" includeMaster=true includeProject=false buildNumber=""]
[#compress]
    [#if icon?has_content][@ui.icon icon /][/#if]
    <a [#if id?has_content]id=${id}[/#if] href=[#if url?has_content]${url}[#else]"${req.contextPath}/browse/${plan.key}"[/#if] [#if plan.description?has_content]title="${plan.description?html}"[/#if]>
        [#if includeProject]
            ${plan.project.name}
            &rsaquo;
        [/#if]
        [#if includeMaster && plan.master?has_content]
            ${plan.master.buildName}
            &rsaquo;
            [@ui.icon type="devtools-branch" useIconFont=true /]
        [/#if]
        ${plan.buildName}
        [#if buildNumber?has_content]
            &rsaquo;
            #${buildNumber}
        [/#if]
    </a>
[/#compress]
[/#macro]

[#-- ============================================================================ @build.getPlanStatusHistoryDetails --]

[#function getPlanStatusHistoryDetails]
    [@ww.action name='planStatusHistory' namespace='/ajax' id='planStatusHistory' /]
    [#local hasPreviousBuildResult = planStatusHistory.buildNumber?? && (planStatusHistory.findLastBuildResultBefore(plan.key, planStatusHistory.buildNumber))?? /]
    [#local firstBuildNumber = planStatusHistory.plan.firstBuildNumber!/]
    [#if planStatusHistory.buildNumber?? && !hasPreviousBuildResult]
        [#local firstBuildNumber = planStatusHistory.buildNumber/]
    [/#if]
    [#local lastBuildNumber = planStatusHistory.plan.lastBuildNumber!/]
    [#local keyToNavigate = (planStatusHistory.jobKey!planStatusHistory.planKey).toString()/]

    [#return {
        "id": "plan-status-history",
        "builds": planStatusHistory.navigableBuilds,
        "bootstrap": planStatusHistory.jsonObject.get(planStatusHistory.getNavigableSummariesKey()).toString(),
        "currentBuildNumber": planStatusHistory.buildNumber!,
        "firstBuildNumber": firstBuildNumber,
        "lastBuildNumber": lastBuildNumber,
        "planKey": planStatusHistory.planKey.toString()?js_string,
        "keyToNavigate": keyToNavigate?js_string,
        "returnUrl": ((navigationContext.getCurrentUrl())!currentUrl)?url
    } /]
[/#function]

