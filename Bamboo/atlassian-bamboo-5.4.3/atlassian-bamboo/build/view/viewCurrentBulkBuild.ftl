[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.GotoBuildResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.GotoBuildResult" --]
[#assign buildNumber = immutablePlan.lastBuildNumber /]

[#if immutablePlan.getLatestResultsSummary()??]
    [#assign currentPlanPrefix]
        <a id="buildResult_${immutablePlan.key}-${resultsSummary.buildNumber}" href="${req.contextPath}/browse/${immutablePlan.key}-${resultsSummary.buildNumber}">
            ${resultsSummary.planResultKey}
        </a>
    [/#assign]
    [#if resultsSummary.successful]
        <div class="Successful">
            [@ui.icon text="Build was successful" type="successful" /]
            [#if (resultsSummary.testResultsSummary.fixedTestCaseCount)?? && resultsSummary.testResultsSummary.fixedTestCaseCount gt 0]
                ${currentPlanPrefix} fixed ${resultsSummary.testResultsSummary.fixedTestCaseCount} tests.
            [#else]
                ${currentPlanPrefix} was successful.
            [/#if]
        </div>
    [#elseif resultsSummary.failed]
            <div class="Failed">
            [@ui.icon text="Build failed" type="failed" /]
            [#if resultsSummary.testResultsSummary.failedTestCaseCount?? && resultsSummary.testResultsSummary.failedTestCaseCount gt 0]
                ${currentPlanPrefix} failed with <strong>${resultsSummary.testResultsSummary.failedTestCaseCount}</strong> failing tests.
            [#else]
                ${currentPlanPrefix} failed.
            [/#if]
            </div>
    [/#if]

[#else]
        [@ww.text name="bulkAction.manualBuild.noHistory" /]
[/#if]
