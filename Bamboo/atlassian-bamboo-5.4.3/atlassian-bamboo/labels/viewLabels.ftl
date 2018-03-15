[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.ViewLabels" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.ViewLabels" --]
<html>
<head>
	[@ui.header pageKey='Labels' object='' title=true /]
</head>

<body>
[#if immutablePlan?? && immutablePlan.type.equals("JOB")]
    [#assign chain = immutablePlan.parent]
    [#assign job = immutablePlan]
[#elseif immutablePlan??]
    [#assign chain = immutablePlan]
[/#if]

<header class="aui-page-header">
    <div class="aui-page-header-inner">
        <div class="aui-page-header-main">
            [#if project??]
                [#assign parentCrumbs = [{
                    "text": "All Labels",
                    "link": "${req.contextPath}/browse/label"
                }] /]
                [#assign labelsFor = project.name /]
                [#if chain??]
                    [#assign parentCrumbs = parentCrumbs + [{
                        "text": "Project: ${project.name}",
                        "link": "${req.contextPath}/browse/${project.key}/label"
                    }] /]
                    [#assign labelsFor = chain.buildName /]
                [/#if]
                [#if job??]
                    [#assign parentCrumbs = parentCrumbs + [{
                        "text": "Plan: ${chain.buildName}",
                        "link": "${req.contextPath}/browse/${chain.key}/label"
                    }] /]
                    [#assign labelsFor = job.buildName /]
                [/#if]
                ${soy.render("bamboo.widget.nav.breadcrumb.crumbContainer", {
                    "parentCrumbs": parentCrumbs
                })}
            [/#if]
            [@ui.header page='Labels' object=labelsFor! /]
        </div><!-- .aui-page-header-main -->
    </div><!-- .aui-page-header-inner -->
</header>

<p>
    [#if job??]
        This page lists all labels against builds in job <strong>${job.name}</strong>.
    [#elseif chain??]
        This page lists all labels against builds in plan <strong>${chain.name}</strong>.
    [#elseif project??]
        This page lists all labels against builds in project <strong>${project.name}</strong>.
    [#else]
        This page lists <strong>all</strong> labels used in Bamboo.
    [/#if]
    The <strong>bigger</strong> the text, the more build results are associated with this label. Click on a label to see the builds associated with it.
</p>

<p class="label-sort">
    [@ww.url id='orderByAlphaUrl' action='viewLabels' namespace='/build/label' orderByRank='false']
        [#if project??]
            [@ww.param name='projectKey']${project.key}[/@ww.param]
        [/#if]
        [#if build??]
            [@ww.param name='buildKey']${build.key}[/@ww.param]
        [/#if]
    [/@ww.url]
    [@ww.url id='orderByRankUrl' action='viewLabels' namespace='/build/label' orderByRank='true']
        [#if project??]
            [@ww.param name='projectKey']${project.key}[/@ww.param]
        [/#if]
        [#if build??]
            [@ww.param name='buildKey']${build.key}[/@ww.param]
        [/#if]
    [/@ww.url]

    <span>Sort labels:</span>
    <span class="aui-buttons">
        <a[#if orderByRank] href="${orderByAlphaUrl}"[/#if] class="aui-button"[#if !orderByRank] aria-pressed="true"[/#if]>alphabetically</a>
        <a[#if !orderByRank] href="${orderByRankUrl}"[/#if] class="aui-button"[#if orderByRank] aria-pressed="true"[/#if]>by popularity</a>
    </span>
</p>

<ul class="label-display">
    [#list results.entrySet() as result]
        [#-- algorithm gives increments of 0.2em: 1em where result.value = 1, 2em where result.value = 6 --]
        [#assign size = ((result.value * 12/5 + 48/5) / 12) /]
        <li style="font-size: ${size}em;">
            <a href="${req.contextPath}/browse/label/${result.key.label.name?url}">${result.key.label.name?html}</a>
        </li>
    [/#list]
</ul>

</body>
</html>