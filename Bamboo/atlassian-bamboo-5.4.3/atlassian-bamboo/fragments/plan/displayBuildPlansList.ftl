[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.TopLevelPlan>" --]

[#import "/lib/chains.ftl" as cn]

[#-- ========================================================================-===================== @cp.displayBuildPlansList--]
[#macro displayBuildPlansList id builds showProject=true returnUrl='']

<div id="${id}section" class="narrowPlanList">
<table class="aui" id="dashboard">
    <col width="25%" style="min-width: 200px;"/>
    <col width="15%"/>
    <col width=""/>
    <col width="76px"/>
    <thead class="assistive">
    <tr>
        <th>[@ww.text name="dashboard.plan"/]</th>
        <th>[@ww.text name="dashboard.build"/]</th>
        <th>[@ww.text name="dashboard.completed"/]</th>
        <th>&nbsp;</th>
    </tr>
    </thead>

    [#assign currentGroupLabel = ""/]

    [#list builds as build]
        [#assign latestResultsSummary=build.latestResultsSummary! /]
        [#assign hasBuildResults=(build.latestResultsSummary??&&latestResultsSummary.id??) /]
        [#assign currentProject = build.project /]
        [#assign groupLabel = currentProject.name /]

        [#assign isNewProject = !currentGroupLabel?has_content || (currentGroupLabel?? && groupLabel?? && currentGroupLabel != groupLabel)]
        [#if isNewProject]
            [#if currentGroupLabel?has_content]
                </tbody>
            [/#if]
            [#if showProject]
                <tbody class="projectHeader" id="projectHeader${currentProject.id}">
                    [#assign currentGroupLabel = groupLabel/]
                    <tr>
                        <th colspan="4">
                             <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}" title="Project Summary">${currentProject.name}</a>
                        </th>
                    </tr>
                </tbody>
            [/#if]
            <tbody class="project${currentProject.id}">
        [/#if]

        <tr>
            <td>
                [@cn.showFullPlanName plan=build /]
            </td>

            [#if hasBuildResults]
                <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]${latestResultsSummary.buildState}[/#if]">
                [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                    <a id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">#${latestResultsSummary.buildNumber}</a>
                [@cp.commentIndicator resultsSummary=latestResultsSummary/]
                </td>
                <td>
                    [#if latestResultsSummary.successful || latestResultsSummary.failed]
                        <span id="lastBuiltSummary${latestResultsSummary.planKey}" title="${latestResultsSummary.buildCompletedDate?datetime?string('hh:mm a, EEE, d MMM')}">${latestResultsSummary.relativeBuildDate}</span>
                    [#else]
                        <span id="lastBuiltSummary${latestResultsSummary.planKey}">[@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]</span>
                    [/#if]
                </td>
            [#else]
                <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]NeverExecuted[/#if]">
                [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                    <a id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">[@ww.text name='build.neverExecuted' /]</a>
                </td>
                <td>
                    <span id="lastBuiltSummary${build.key}"></span>
                </td>
            [/#if]
            <td>
            [@displayPlanListOperations id build returnUrl/]
            </td>
        </tr>
    [/#list]
</tbody>
</table>
</div>
[/#macro]

[#macro displayPlanListOperations id build returnUrl='${currentUrl}']
<!-- operations -->
    [#if fn.hasPlanPermission('BUILD', build) ]
        [#if build.suspendedFromBuilding]
            <a id="${id}resumeBuild_${build.key}" class="mutative" href="[@ww.url action='resumeBuild' namespace='/build/admin' buildKey=build.key returnUrl=returnUrl /]">[@ui.icon type="build-enable" text="Enable Build"/]</a>
        [#else]
            [#if build.active]
                <a id="${id}stopBuild_${build.key}" class="asynchronous usePostMethod" href="${fn.getPlanStopLink(build)}">[@ui.icon type="build-stop" text="Stop Build"/]</a>
            [#else]
                <a id="${id}manualBuild_${build.key}" class="asynchronous usePostMethod" href="[@ww.url action="startPlan" namespace="/build/admin/ajax" buildKey=build.key/]">[@ui.icon type="build-run" text="Checkout &amp; Build"/]</a>
            [/#if]
        [/#if]
    [/#if]
    [#if fn.hasPlanPermission('WRITE', build) ]
    <a id="${id}editBuild:${build.key}" accesskey="E" href="${fn.getPlanEditLink(build)}">[@ui.icon type="build-configure" text="Edit Build"/]</a>
    [/#if]
[@cp.favouriteIcon plan=build operationsReturnUrl=returnUrl user=user/]
[/#macro]