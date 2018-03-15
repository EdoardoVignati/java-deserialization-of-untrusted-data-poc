[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTableByPlans" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTableByPlans" --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

[#if planSummaries?has_content]
<ul class="planSummaries" id="buildResultsList">
[#list planSummaries as planSummary]
    <li class="planSummary">
        <h3>
            <a href="${baseUrl}/browse/${planSummary.key}">${planSummary.name}</a>
            <span class="subText">
            [#if planSummary.failedBuildCount > 0]
                (${planSummary.failedBuildCount} of ${planSummary.totalBuildCount} related builds failed)
            [#else]
                (All ${planSummary.totalBuildCount} related builds successful)
            [/#if]
            </span>
        </h3>
        <ol class="build_result_list">
        [#list planSummary.builds as build]
            [@planList.showBuildResultSummary summary=build/]
        [/#list]
        </ol>
    </li>
[/#list]
</ul>
[/#if]