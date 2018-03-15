[#-- ================================================================================ @cp.displayBuildSummariesBrief --]
[#macro displayBuildSummariesBrief builds showProject=true]
   <table id="summaryBrief" class="grid" width="100%">

    <tr>
        <th>Status</th>
        <th>Project - Plan</th>
        <th>Latest Completed Build</th>
        <th>Reason</th>
    </tr>

    [#list builds as build]
    [#assign latestBuildSummary=build.latestBuildSummary?if_exists /]
    [#assign hasBuildResults=(latestBuildSummary.id)?exists /]

    <tr class="[#if build.suspendedFromBuilding]Suspended[#elseif latestBuildSummary?has_content]${latestBuildSummary.buildState}[#else]NeverExecuted[/#if]">
        <!-- summary icon -->
        <td>
            [@cp.currentBuildStatusIcon build=build /]
        </td>
        <!-- plan -->
        <td>
            <a id="viewProject:${build.project.key}"
               href="${req.contextPath}/browse/${build.project.key}" title="Project Summary">${build.project.name}</a>
            -
            <a id="viewBuild:${build.key}"
               href="${req.contextPath}/browse/${build.key}" [#if build.description?has_content]title="${build.description!?html}"[/#if]>${build.buildName}</a>
        </td>
        <!-- latest build -->
        <td>
            [#if hasBuildResults]
            <a id="latestBuild:${build.key}:${latestBuildSummary.buildNumber}"
               href="${req.contextPath}/browse/${build.key}/latest"  title="[@ww.text name='build.common.latestBuild'/]">${latestBuildSummary.planResultKey}</a>
                [@cp.commentIndicator resultsSummary=latestBuildSummary /]
            [#else]
                [@ww.text name='build.neverExecuted' /]
            [/#if]
        </td>
        <!-- reason -->
        <td>
            [#if hasBuildResults]
                ${latestBuildSummary.reasonSummary}
            [#else]
                &nbsp;
            [/#if]
        </td>
    </tr>
    [/#list]
    </table>
[/#macro]