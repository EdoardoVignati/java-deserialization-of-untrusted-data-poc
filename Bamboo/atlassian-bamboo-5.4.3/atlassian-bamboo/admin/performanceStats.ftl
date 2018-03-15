[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.PerformanceStatsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.PerformanceStatsAction" --]

<html>
<head>
    <title>Performance Statistics</title>
    <meta name="decorator" content="atl.popup">
</head>
<body>
<h1>Performance Statistics</h1>

[#if requestProfilingEnabled]
    [@ww.form action="performanceStats" submitLabelKey="Disable Performance Tracking"]
    Request performance profiling is enabled.
        [@ww.hidden name="requestProfilingState" value="false"/]
    [/@ww.form]

    <h2>URL serving statistics</h2>
    <dl>
        <dt>Total URLs served:</dt>
        <dd>${servletPathStats.stats.count?string("#,###")}</dd>

        <dt>Total time:</dt>
        <dd>${servletPathStats.stats.totalTime?string("#,###")} ms</dd>
    </dl>

    <h3>Per servlet stats</h3>
    [@displayTable level=1 /]

    <h3>Per path stats</h3>
    [@displayTable level=2 /]
[#else]
    [@ww.form action="performanceStats" submitLabelKey="Enable Performance Tracking"]
        Request performance profiling is disabled.
        [@ww.hidden name="requestProfilingState" value="true"/]
    [/@ww.form]
[/#if]
</body>
</html>

[#macro displayTable level]

[#local timeLimit = 3000 /]

<table class="aui">
    <thead>
    <tr><th>Path</th><th></th><th>Average</th><th>Total</th><th>URLs</th><th>97th</th></tr>
    </thead>
[#list servletPathStats.entries.toArray()?sort_by(["value", "stats", "${sortBy}"])?reverse as entry]
    <tr>
        <td>
            <a href="${req.contextPath}${entry.key}">${entry.key?html}</a>
        </td>
    [#if level=1]
        [#local stats = entry.value.stats/]
        <td></td>
        <td>
            [#if stats.avgTime > timeLimit]
                <b>${stats.avgTime}</b>
            [#else]
                ${stats.avgTime}
            [/#if]
        </td>
        <td>${stats.totalTime}</td>
        <td>${stats.count}</td>
        <td>
            [#if stats.percentile97th?has_content && stats.percentile97th > timeLimit]
                <b>${stats.percentile97th} (!)</b>
            [#else]
                ${stats.percentile97th!}
            [/#if]
        </td>
    [/#if]
    </tr>

[#if level=2]
    [#list entry.value.urlStatsMap.entrySet().toArray()?sort_by(["value", "stats", "${sortBy}"])?reverse  as urlStatsEntry]
        [#local stats = urlStatsEntry.value.stats/]
        <tr>
            <td></td>
            <td>${urlStatsEntry.key?html}</td>
            <td>
                [#if stats.avgTime > timeLimit]
                    <b>${stats.avgTime}</b>
                [#else]
                ${stats.avgTime}
                [/#if]
            </td>
            <td>${stats.totalTime}</td>
            <td>${stats.count}</td>
            <td>
                [#if stats.percentile97th?has_content  && stats.percentile97th > timeLimit]
                    <b>${stats.percentile97th} (!)</b>
                [#else]
                    ${stats.percentile97th!}
                [/#if]
            </td>
        </tr>
        [#if urlStatsEntry_index gte 10]
            [#local entries = entry.value.urlStatsMap.size() /]
            <tr>
                <td></td>
                <td colspan="5">Hidden ${entries - 10} more entries...</td>
            </tr>
            [#break]

        [/#if]

    [/#list]
[/#if]
[/#list]
</table>
[/#macro]