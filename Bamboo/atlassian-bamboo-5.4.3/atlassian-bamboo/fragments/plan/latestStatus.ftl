[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ShowLatestBuildStatus" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ShowLatestBuildStatus" --]
[#-- @ftlvariable name="currentlyRunning" type="com.atlassian.bamboo.plan.ExecutionStatus" --]
[#--
Requirements:
        * plan
        * currentlyRunningBuild
--]
[@compress single_line=true]
<div id="plan-status">
    [#if immutablePlan??]
        [#assign statusSource = immutablePlan/]
        [#if immutablePlan.type == 'JOB']
            [#assign statusSource = immutablePlan.parent/]
        [/#if]
        [#assign numberOfRunningBuilds = action.getNumberOfCurrentlyBuildingPlans(statusSource.key) /]
        [#if numberOfRunningBuilds gte 1 ]
            [#if numberOfRunningBuilds == 1]
                [#list action.getCurrentlyBuildingPlans(statusSource.planKey) as currentlyRunning]
                    [@ww.url value='/browse/${currentlyRunning.buildIdentifier.buildResultKey}'  id="currentBuildUrl" /]
                    [#if currentlyRunning.startTime?has_content]
                        <p class="current">
                            [#if currentlyRunning_index == 0]<strong>[@ww.text name='build.status.current' /]:</strong>[/#if]
                            <a class="buildLink" href="${currentBuildUrl}">#${currentlyRunning.buildIdentifier.buildNumber}</a> is building
                        </p>
                    [#else]
                        <p class="queued">
                            [#if currentlyRunning_index == 0]<strong>[@ww.text name='build.status.current' /]:</strong>[/#if] <a class="buildLink" href="${currentBuildUrl}">#${currentlyRunning.buildIdentifier.buildNumber}</a> is <a href="[@ww.url action='currentActivity' namespace=''/]">queued</a>
                        </p>
                    [/#if]
                [/#list]
            [#else]
                [@ww.url value='/browse/${statusSource.key}'  id="currentBuildUrl" /]
                [#assign running = numberOfRunningBuilds/]
                [#assign lozengeClass = "queued"]
                [#if running > 0]
                    [#assign lozengeClass = "current"]
                [/#if]
                <p class="${lozengeClass}">
                    <strong>[@ww.text name='build.status.current' /]:</strong>
                    <a class="buildLink" href="${currentBuildUrl}">
                        [@ww.text name='build.status.current.executing']
                                [@ww.param value=running/]
                        [/@ww.text]
                    </a>
                </p>
            [/#if]
            
        [#elseif statusSource.latestResultsSummary??]
            [#assign latestBuildSummary = statusSource.latestResultsSummary]
            [@ww.url id='latestBuildUrl' value='/browse/${latestBuildSummary.planResultKey}' /]
            [#if latestBuildSummary.continuable]
                <p class="continuable">
                    <strong>[@ww.text name='build.status.current' /]:</strong> <a href="${latestBuildUrl}">#${latestBuildSummary.buildNumber}</a> stopped on manual stage
                </p>
            [#elseif latestBuildSummary.successful]
                <p class="success">
                   <strong>[@ww.text name='build.status.current' /]:</strong> <a href="${latestBuildUrl}">#${latestBuildSummary.buildNumber}</a> was successful
                </p>
            [#elseif latestBuildSummary.notBuilt]
                <p class="notBuilt">
                   <strong>[@ww.text name='build.status.current' /]:</strong> <a href="${latestBuildUrl}">#${latestBuildSummary.buildNumber}</a> was not built
                </p>
            [#else]
                <p class="failed">
                   <strong>[@ww.text name='build.status.current' /]:</strong> <a href="${latestBuildUrl}">#${latestBuildSummary.buildNumber}</a> failed
                </p>
            [/#if]
        [#else]
            <p class="none">
                <strong>[@ww.text name='build.status.current' /]:</strong> [@ww.text name='build.status.current.nohistory'/]
            </p>
        [/#if]
        <script type="text/javascript">
            BAMBOO.buildLastCurrentStatus = '${statusSource.currentStatus}';
            [#if statusChanged?? && statusChanged]
                reloadThePage();
            [/#if]
        </script>
    [#else]
        <p class="none">
            [@ww.text name='build.status.current.notfound'/]
        </p>
    [/#if]
</div><!-- END #plan-status -->
[/@compress]
