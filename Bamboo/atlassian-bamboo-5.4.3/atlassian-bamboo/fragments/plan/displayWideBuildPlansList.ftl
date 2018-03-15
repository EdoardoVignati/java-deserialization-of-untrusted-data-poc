[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.cache.ImmutableTopLevelPlan>" --]

[#-- ============================================================================================== @planList.displayJiraIssues --]
[#--used for jira bamboo plugin--]
[#macro displayJiraIssues jiraIssues summary]
[#-- @ftlvariable name="summary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
[#if jiraIssues.size() > 3]
    <a href="${baseUrl}/browse/${summary.planResultKey}/issues">[#rt]
        ${jiraIssues.size()} issues[#t]
    </a>[#lt]
[#else]
    [#list jiraIssues as jiraIssue]
           ${jiraIssueUtils.getRenderedString(jiraIssue.issueKey, summary)}[#if jiraIssue_has_next], [/#if]
    [/#list]
[/#if]
[/#macro]

[#-- ============================================================================================== @planList.displayIssues --]
[#--used for jira bamboo plugin--]
[#macro displayIssues summary]
[#-- @ftlvariable name="summary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
[#assign fixingJiraIssues =  summary.fixingJiraIssues!('')/]
[#assign relatedJiraIssues =  summary.relatedJiraIssues!('')/]

[#if fixingJiraIssues?has_content || relatedJiraIssues?has_content]
    <p class="summary">
    [#if fixingJiraIssues?has_content]
        <span class="fixes_issues">
            [@ww.text name='jira.fixes' /]:
            [@displayJiraIssues jiraIssues=fixingJiraIssues summary=summary /]
        </span>
        [#if relatedJiraIssues?has_content]
            <br>
        [/#if]
    [/#if]

    [#if relatedJiraIssues?has_content]
        <span class="related_issues">
            [@ww.text name='jira.related' /]:
            [@displayJiraIssues jiraIssues=relatedJiraIssues summary=summary /]
        </span>
    [/#if]
    </p>
[/#if]
[/#macro]

[#-- ============================================================================================== @planList.showFullSummaryDetails --]
[#--used for jira bamboo plugin--]
[#macro showFullSummaryDetails summary showComment=true]
[#-- @ftlvariable name="summary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
    <div class="details">
        <!-- Reason -->
        <span class="reason" id="reasonSummary${summary.planKey}">
            ${summary.reasonSummary}
        </span> |

        [#assign willShowComment = showComment && summary.comments?has_content /]
        [#if willShowComment]
            [@cp.commentIndicatorAsText buildResultsSummary=summary /] |
        [/#if]

	    <!-- Last Build Time-->
		[@ww.text name='build.common.ran.title' /]:
        [#if summary.successful || summary.failed]
            <span class="relativeDate" title="${summary.buildCompletedDate?datetime?string('hh:mm a, EEE, d MMM')}">
                ${summary.relativeBuildDate}
            </span>
        [#else]
            <span class="relativeDate">
                [@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]
            </span>
        [/#if]

        <br>
        <!-- Duration -->
        [@ww.text name='build.common.duration' /]:
        <span class="duration">
            ${summary.durationDescription}[#t]
        </span> |

        <!-- test count summary -->
        [@ww.text name='build.tests.title' /]:
        <span class="test_results">
            ${summary.testSummary}[#t]
        </span>

        <!-- Artifacts and Labels -->
		[#assign artifactLinks = (summary.artifactLinksThatExist)! /]
		[#assign labelNames = (summary.labelNames)! /]
		[#if artifactLinks?has_content || labelNames?has_content]
			<br>

			[#if artifactLinks?has_content]
                [@ww.text name='artifact.title' /]:
		        <span class="artifacts">
		            [#list artifactLinks as artifactLink]
                        [#local artifactUrl=action.getArtifactLinkUrl(artifactLink)!/]
                        [#if artifactUrl?has_content]
                            <a href="[@ww.url value='${artifactUrl}'/]">${artifactLink.label}</a>[#if artifactLink_has_next], [/#if]
                        [/#if]
                        [#if artifactLink_index gte 4 && artifactLink_has_next]
                            <a href="[@ww.url value='/browse/${summary.planResultKey}/artifact'/]">and ${artifactLinks?size - 5} more&hellip;</a>
                            [#break]
                        [/#if]
		            [/#list]
		        </span>
			    [#if labelNames?has_content] | [/#if][#t]
            [/#if]

            [#if labelNames?has_content]
                [@ww.text name='labels.title' /]:[#lt]
                <ul class="labels">
                    [#list labelNames?chunk(7) as labelNameRow]
                        [#list labelNameRow as labelName]
                            <li><a href="[@ww.url value='/browse/label/${labelName?url}'/]" class="lozenge"><span>${labelName?html}</span></a></li>
                        [/#list]
                    [/#list]
                </ul>
            [/#if]
        [/#if]
	</div>
[/#macro]

[#-- ============================================================================================== @planList.planOperations --]
[#macro planOperations build]
    [#assign operationsReturnUrl='${currentUrl}' /]
    [#-- operations --]
    [#if fn.hasPlanPermission('BUILD',build) ]
        [@ww.text id="stopAllTitle" name="build.stop.all" ][@ww.param]'${build.name}'[/@ww.param][/@ww.text]
        [@ww.text id="stopOneTitle" name="build.stop.name" ][@ww.param]'${build.name}'[/@ww.param][/@ww.text]

        [#assign hideResume = true/]
        [#assign hideStopMultiple = true/]
        [#assign hideStopSingle = true/]
        [#assign hideStart = true/]

        [#if build.suspendedFromBuilding ]
            [#assign hideResume = false/]
        [#else]
            [#assign numberOfRunningPlans = action.getNumberOfCurrentlyBuildingPlans(build.key) /]
            [#if numberOfRunningPlans > 1 ]
                [#assign hideStopMultiple = false/]
            [#elseif build.active]
                [#assign hideStopSingle = false/]
            [#elseif build.busy]
                [#assign hideStopSingle = false/]
            [#else]
                [#assign hideStart = false/]
            [/#if]
        [/#if]
        <a class="enableBuild usePostMethod" id="resumeBuild_${build.key}" data-plan-key="${build.key}"[#if hideResume] style="display:none;"[/#if] href="[@ww.url action='resumeBuild' namespace='/build/admin' buildKey=build.key mark="CCCCCCCCC" returnUrl='${req.contextPath}/start.action' /]">[@ui.icon type="build-enable" text="Enable '${build.name}'"/]</a>
        <a class="asynchronous usePostMethod" id="manualBuild_${build.key}"[#if hideStart] style="display:none;"[/#if] href="${req.contextPath}/build/admin/ajax/startPlan.action?planKey=${build.key}">[@ui.icon type="build-run" text="Run"/]</a>
        <a class="asynchronous usePostMethod" id="stopSingleBuild_${build.key}"[#if hideStopSingle] style="display:none;"[/#if] href="${req.contextPath}/build/admin/ajax/stopPlan.action?planKey=${build.key}">[@ui.icon type="build-stop" text="${stopOneTitle}" /]</a>
        <a class="stopMultipleBuilds asynchronous" data-plan-key="${build.key}"[#if hideStopMultiple] style="display:none;"[/#if]>[@ui.icon type="build-stop" text="${stopAllTitle}" /]</a>
    [/#if]
    [#if fn.hasPlanPermission('WRITE', build)]
        <a id="editBuild:${build.key}" href="${fn.getPlanEditLink(build)}" >[@ui.icon type="build-configure" text="Edit '${build.name}'"/]</a>
    [/#if]
    [@cp.dashboardFavouriteIcon plan=build operationsReturnUrl=operationsReturnUrl user=action.getUser()/]
[/#macro]

[#-- ============================================================================================== @planList.showBuildResultSummary --]
[#--used for jira bamboo plugin--]
[#macro showBuildResultSummary summary]
[#-- @ftlvariable name="summary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
<li id="buildResult_${summary.planResultKey}" class="build_${summary.buildState}">
    <h4>
         <span class="build_result">Build ${summary.buildState}:</span>
            <a href="${baseUrl}/browse/${summary.planResultKey}" class="build-project">${(summary.immutablePlan.name)!}</a>
            <a href="${baseUrl}/browse/${summary.planResultKey}" class="build-issue-key">#${summary.buildNumber}</a>
    </h4>

    [@showFullSummaryDetails summary=summary/]

 	[@displayIssues summary=summary /]
</li>
[/#macro]

[#-- ============================================================================================== @planList.displayWideBuildPlansList --]
[#macro displayWideBuildPlansListRows builds showProject=true showActions=true showHeadings=true showBuildDetails=true setColumnWidths=true showBranchIcons=false]
[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.cache.ImmutableTopLevelPlan>" --]
    [#assign currentGroupLabel = ""/]
    [#assign projectHeaderColspan = 1/]
    [#if showBuildDetails]
        [#assign projectHeaderColspan = projectHeaderColspan + 3/]
    [/#if]
    [#if showActions]
        [#assign projectHeaderColspan = projectHeaderColspan + 1/]
    [/#if]

    [#list builds as build]
        [#assign latestResultsSummary=build.latestResultsSummary! /]
        [#assign hasBuildResults=(build.latestResultsSummary??&&latestResultsSummary.id??) /]
        [#assign currentProject = build.project /]
        [#assign groupLabel = currentProject.name /]
        [#assign expandedValue = action.getConglomerateCookieValue('bamboo.dash.display.toggles','${currentProject.id}') /]

        [#assign isNewProject = !currentGroupLabel?has_content || (currentGroupLabel?? && groupLabel?? && currentGroupLabel != groupLabel)]
        [#if isNewProject]
            [#if currentGroupLabel?has_content]
            </tbody>
            [/#if]

            [#assign currentGroupLabel = groupLabel/]
            [#if showProject]
            <tbody class="projectHeader[#if expandedValue != '0' || !showProject] hidden[/#if]" data-project-id="${currentProject.id}">
            <tr>
                <td class="twixie expand">
                    <a tabindex="0">[@ui.icon type="expand" text="Expand"/]</a>
                </td>
                <td class="project">
                    <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}">${currentGroupLabel}</a>
                </td>
                <td></td>
                <td[#if projectHeaderColspan > 1] colspan="${projectHeaderColspan}"[/#if]>
                    <div class="statusMessage">
                        [@ui.icon type="project-${projectStatusHelper.getCurrentStatus(currentProject.key)}" /]
                                        ${projectStatusHelper.getProjectSummary(currentProject.key)}
                    </div>
                </td>
            </tr>
            </tbody>
            [/#if]
        <tbody class="project[#if expandedValue == '0' && showProject] hidden[/#if]" data-project-id="${currentProject.id}">
        [/#if]

    <tr>
            [#if showProject]
                [#if isNewProject]
                    [#assign numProjectPlans = projectStatusHelper.getPlanCount(currentProject.key) /]
                    <td class="twixie collapse"[#if numProjectPlans > 1] rowspan="${numProjectPlans}"[/#if]>
                        <a tabindex="0">[@ui.icon type="collapse" text="Collapse"/]</a>
                    </td>
                    <td class="project"[#if numProjectPlans > 1] rowspan="${numProjectPlans}"[/#if]>
                        <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}">${currentProject.name}</a>
                    </td>
                [/#if]
            [/#if]
            <td class="build">
                <a id="viewBuild:${build.key}" href="${req.contextPath}/browse/${build.key}"[#if build.description?has_content] title="${build.description!?html}"[/#if]>[#if showBranchIcons && build.master??][@ui.icon type="devtools-branch" useIconFont=true /][/#if]${build.buildName}</a>
                    [#if (action.hasBranches(build))!false]<a href="${req.contextPath}/browse/${build.key}/branches" class="view-branches" data-plan-key="${build.key}">[@ui.icon type="devtools-branch" textKey="branch.view.help" useIconFont=true showTitle=true/]</a>[/#if]
                    ${soy.render("bamboo.deployments:linked-deployment-shortcut", 'feature.plan.linkedDeployment.linkedDeploymentDashboardDropdown', {
                        'immutablePlan': ((build.parent)!build),
                        'hasLinkedDeployments': action.hasLinkedDeployments(((build.parent)!build).planKey)
                    })}
            </td>

        [#if hasBuildResults]
            <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]${latestResultsSummary.buildState}[/#if]">
                [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                <a id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">#${latestResultsSummary.buildNumber}</a>
                [@cp.commentIndicator resultsSummary=latestResultsSummary/]
            </td>
            [#if showBuildDetails]
                <td>
                    [#if latestResultsSummary.successful || latestResultsSummary.failed]
                        <span id="lastBuiltSummary${latestResultsSummary.planKey}" title="${latestResultsSummary.buildCompletedDate?datetime?string('hh:mm a, EEE, d MMM')}">${latestResultsSummary.relativeBuildDate}</span>
                    [#else]
                        <span id="lastBuiltSummary${latestResultsSummary.planKey}">[@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]</span>
                    [/#if]
                </td>
                <td id="testSummary${latestResultsSummary.planKey}">
                ${latestResultsSummary.testSummary}
                </td>
                <td>
                    <span id="reasonSummary${latestResultsSummary.planKey}">${latestResultsSummary.reasonSummary}</span>
                    [#if latestResultsSummary.hasChanges()]
                        <script type="text/javascript">
                            AJS.$(initCommitsTooltip("reasonSummary${latestResultsSummary.planKey}", "${latestResultsSummary.planKey}", "${latestResultsSummary.buildNumber}"));
                        </script>
                    [/#if]
                </td>
            [/#if]
        [#else]
            <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]NeverExecuted[/#if]">
                [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                <a id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">[@ww.text name='build.neverExecuted' /]</a>
            </td>
            [#if showBuildDetails]
                <td>
                    <span id="lastBuiltSummary${build.key}"></span>
                </td>
                <td id="testSummary${build.key}"></td>
                <td>
                    <span id="reasonSummary${build.key}"></span>
                </td>
            [/#if]
        [/#if]
        [#if showActions]
            <td class="dashboard-operations">
                [@planOperations build/]
            </td>
        [/#if]
    </tr>
    [/#list]
</tbody>
[/#macro]

[#macro displayShowMoreFooter plansForDashboard]
[#-- @ftlvariable name="plansForDashboard" type="com.atlassian.bamboo.webwork.StarterAction.DashboardPage" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
    <tfoot>
        <tr>
            <td colspan="100" data-last-project-key="${plansForDashboard.lastProjectKey!}"[#if plansForDashboard.showMoreRequired] class="show-more-plans"[/#if]> [#--Apparently if the colspan is a bit big, it doesn't matter--]
                <div>
                    [@ww.url id='editFilterByProjects' value='/ajax/configureFilter.action' returnUrl=currentUrl /]

                    [#if !plansForDashboard.emptyResults]
                        [#if plansForDashboard.showMoreRequired]<button class="show-more-trigger">[@ww.text name="dashboard.filter.showMore"/]</button>[/#if]
                        <p class="show-more-text">
                            [@ww.text name='dashboard.filter.showing']
                                [@ww.param]${plansForDashboard.accumulatedSubsetCount}[/@ww.param]
                                [@ww.param]${plansForDashboard.totalSize}[/@ww.param]
                            [/@ww.text]
                        </p>
                        [#-- Show count of excluded plans--]
                        [#if action.dashboardFilterEnabled && plansForDashboard.notIncludedCount > 0]
                            <p class="show-more-text">
                                [@ww.text name='dashboard.filter.on.message']
                                    [@ww.param]${plansForDashboard.notIncludedCount}[/@ww.param]
                                    [@ww.param]${editFilterByProjects}[/@ww.param]
                                [/@ww.text]
                            </p>
                        [/#if]

                        [#-- Show Filter this hint when no filter + lots of plans --]
                        [#if !action.dashboardFilterEnabled && plansForDashboard.multiPage && user??]
                            <p class="show-more-text">
                                [@ww.text name='dashboard.filter.suggest']
                                    [@ww.param]${editFilterByProjects}[/@ww.param]
                                [/@ww.text]
                            </p>
                        [/#if]
                    [#else]
                        <p>[@ww.text name='dashboard.filter.noPlans' /]</p>
                        <p>[@ww.text name='dashboard.filter.noPlans.help']
                               [@ww.param]${editFilterByProjects}[/@ww.param]
                               [@ww.param]${req.contextPath}/ajax/toggleDashboardFilter.action?filterEnabled=${(!dashboardFilterEnabled)?string}&returnUrl=${currentUrl}[/@ww.param]
                           [/@ww.text]
                        </p>
                    [/#if]

                </div>
            </td>
        </tr>
    </tfoot>
[/#macro]

[#macro displayWideBuildPlansList builds showProject=true showActions=true showHeadings=true showBuildDetails=true setColumnWidths=true showBranchIcons=false]
    <table class="aui aui-zebra" id="dashboard">
        [#if setColumnWidths]
            <colgroup>
                [#if showProject]
                    <col width="16px"/>
                    <col width="17%"/>
                [/#if]
                <col width="20%" style="min-width: 200px;"/>
                <col width="10%"/>
                [#if showBuildDetails]
                    <col width=""/>
                    <col width=""/>
                    <col width=""/>
                [/#if]
                [#if showActions]
                    <col width="91px"/>
                [/#if]
            </colgroup>
        [/#if]
        <thead[#if !showHeadings] class="assistive"[/#if]>
            <tr>
                [#if showProject]
                    <th></th>
                    <th>[@ww.text name="dashboard.project"/]</th>
                [/#if]
                <th>[@ww.text name="dashboard.plan"/]</th>
                <th>[@ww.text name="dashboard.build"/]</th>
                [#if showBuildDetails]
                    <th>[@ww.text name="dashboard.completed"/]</th>
                    <th>[@ww.text name="dashboard.tests"/]</th>
                    <th>[@ww.text name="dashboard.reason"/]</th>
                [/#if]
                [#if showActions]
                    <th></th>
                [/#if]
            </tr>
        </thead>

        [#if plansForDashboard?has_content]
            [@displayShowMoreFooter plansForDashboard/]
        [/#if]

        [@displayWideBuildPlansListRows builds showProject showActions showHeadings showBuildDetails setColumnWidths showBranchIcons/]
    </table>

    ${soy.render("bamboo.deployments:linked-deployment-shortcut", 'feature.plan.linkedDeployment.linkedDeploymentDialogTriggerHandler', {})}

    <script type="text/javascript">
        [#if showProject]
        (function ($) {
            [#--Collapsing/Expanding functions--]
            var collapseAllProjects = function () {
		            var projects = $("tbody.project"),
		                projectHeaders = $("tbody.projectHeader");

                    projects.hide();
                    projectHeaders.show();

		            projectHeaders.each(function() {
                        var projectId = $(this).data("projectId");
		                saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, '0');
                    });
                },
                expandAllProjects = function () {
		            var projects = $("tbody.project"),
		                projectHeaders = $("tbody.projectHeader");

                    projectHeaders.hide();
                    projects.show();

		            projectHeaders.each(function() {
                        var projectId = $(this).data("projectId");
		                saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, null);
                    });
                },
                collapseProject = function ($sectionToHide) {
                    var projectId = $sectionToHide.data("projectId");
                    $sectionToHide.hide();
                    $sectionToHide.prev("tbody").show();
                    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, '0');
                },
                expandProject = function ($sectionToHide) {
                    var projectId = $sectionToHide.data("projectId");
                    $sectionToHide.hide();
                    $sectionToHide.next("tbody").show();
                    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, null);
                };

            [#-- attach event handlers to the expand collapse twixies --]
            $(document).delegate("#dashboard > tbody > tr > .twixie > a", "click", function (e) {
                var $twixie = $(this).closest("tbody");
                if ($twixie.hasClass("project")) {
                    collapseProject($twixie);
                } else {
                    expandProject($twixie);
                }
            });

            [#-- Bind collapse/expand all events --]
            $("#dashboard-controls").delegate(".collapse-all", "click", collapseAllProjects)
                                    .delegate(".expand-all", "click", expandAllProjects);
        })(AJS.$);
        [/#if]
        [#-- initiate async manager for operations (handles e.g. inline stopping/starting of builds) --]
        AJS.$(function() {
            AsynchronousRequestManager.init(".asynchronous", null, function (json) {
                if (json != undefined && json.status != undefined && json.status == "ERROR") {
                    var $message = AJS.$("<div/>").addClass("error-holder"),
                        $messageContainer = AJS.$("#ajaxErrorHolder"); // main Bamboo dashboard

                    AJS.messages["error"]($message, { closeable: true, body: json.errors.join(" ") });

                    $message.delay(5000).fadeOut(function () {
                        AJS.$(this).remove();
                    });
                    if ($messageContainer.length == 0) {
                        $messageContainer = AJS.$("#dashboard"); // project dashboard
                        $message.insertBefore($messageContainer);
                    } else {
                        $message.insertAfter($messageContainer);
                    }
                }
                updatePlans();
            });
        });

        (function () {
            var timeout,
                panelId = 'dashboardUpdatePlans';
            if (typeof BAMBOO.panelTimeouts === "undefined") {
                BAMBOO.panelTimeouts = {};
            } else {
                timeout = BAMBOO.panelTimeouts[panelId];
                clearTimeout(timeout);
            }
            BAMBOO.panelTimeouts[panelId] = setTimeout(function () { updatePlans(0); }, BAMBOO.reloadDashboardTimeout * 1000);
            BAMBOO.reloadDashboard = true;
        })();
        AJS.$(function($) {
            $(".stopMultipleBuilds").each(function() {
                var $this = $(this),
                    planKey = $this.data("planKey");

                simpleDialogForm( $this, "${req.contextPath}/ajax/viewRunningPlans.action?planKey="+planKey+"&returnUrl=${currentUrl}",
                                 800, 400,
                                 "[@ww.text name='build.stop.confirmation.button' /]", "", null,
                                 null,
                                 null);
            });
        });

        BAMBOO.PlanBranchSelector({
            trigger: '.view-branches',
            includeLatestResult: true,
            templates: {
                branchItem: 'branchItem-template',
                branchItemActiveBuild: 'branchItemActiveBuild-template'
            }
        }).init();

        [#if page?? && pageSize??]
            BAMBOO.DASHBOARD.Expander({
                toggleFilterClass: 'toggleFilter',
                triggerRootSelector: ".show-more-plans",
                triggerSelector: ".show-more-trigger",
                tableSelector: "#dashboard",
                pageSize: ${pageSize}
            }).init();
        [/#if]
    </script>

    <script type="text/x-template" title="branchItem-template">[#rt/]
        [@buildItemTemplate /][#t/]
    </script>[#lt/]
    <script type="text/x-template" title="branchItemActiveBuild-template">[#rt/]
        [@buildItemTemplate latestResultKey="latestCurrentlyActive.key" latestResultState="latestCurrentlyActive.lifeCycleState" latestResultNumber="latestCurrentlyActive.number" suspendedClass="latestCurrentlyActive.suspendedClass" /][#t/]
    </script>[#lt/]
[/#macro]

[#macro buildItemTemplate latestResultKey="latestResult.key" latestResultState="latestResult.state" latestResultNumber="latestResult.number" suspendedClass="latestResult.suspendedClass"][#rt/]
    <li>[#t/]
        <span class="latest-build {${suspendedClass}}">[#t/]
            <a href="${req.contextPath}/browse/{${latestResultKey}}" class="{${latestResultState}}">[@ui.icon type="{${latestResultState}}" /]{${latestResultNumber}}</a>
        </span>[#t/]
        <span class="branch {${suspendedClass}}">[#t/]
            <a href="${req.contextPath}/browse/{key}" title="{description}">{shortName}</a>[#t/]
        </span>[#t/]
    </li>[#t/]
[/#macro][#lt/]
