[#assign planList = webwork.bean("com.atlassian.bamboo.build.BuildList")]
[#if planList.plans?has_content]
    [#list planList.plans as plan]
        [#if plan.latestBuildSummary?has_content]
            [#assign buildState = plan.latestBuildSummary.buildState]
        [#else]
            [#assign buildState = "Successful"]
        [/#if]
        <div class="build link${buildState}">
            [@cp.currentBuildStatusIcon  build=plan /]

            <a id="viewBuild:${plan.key}" class="${buildState}" href="${req.contextPath}/browse/${plan.key}" title="Build Summary">${plan.name}</a>

            [#if plan.active]
                (<a id="building:${plan.key}" class="${buildState}" href="${req.contextPath}/browse/${plan.key}/latest" title="Current build">current</a>)
            [#elseif plan.latestBuildSummary?has_content]
                (<a id="latestBuild:${plan.key}" class="${buildState}" href="${req.contextPath}/browse/${plan.key}/latest" title="Latest build">latest</a>)
            [/#if]
        </div>
    [/#list]
[#else]
    <p>
    [@ww.text name='global.builds.no.builds' /] <br />
    [#if fn.hasGlobalPermission('CREATE') ]
        <a href="[@ww.url action='addPlan' namespace='/build/admin/create' /]" title="Create new Plan">Create a new plan</a>
    [/#if]

    </p>
[/#if]