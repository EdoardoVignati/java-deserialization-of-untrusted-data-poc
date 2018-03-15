[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ViewBambooInternals" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ViewBambooInternals" --]
[#-- @ftlvariable name="jobDetail" type="org.quartz.JobDetail" --]
<html>
<head>
	<title>[@ww.text name='system.internal' /]</title>
</head>
<body>
    <h1>Caches</h1>

    <h2>Plan Cache</h2>
    [@showBambooCache planCacheStats /]
    <h2>ACL Cache</h2>
    [@showBambooCache aclCacheStats /]

    <h1>Plan Execution Stats</h1>

    [@showExeStats planExecutorStats /]


    <h1>Events</h1>

    [@showExeStats eventExecutorStats /]

    <h3>Event count</h3>
    <table class="aui">
        <thead>
        <tr>
            <th>&nbsp;</th>
            <th>Event Class</th>
            <th>Dispatch Count</th>
        </tr>
        </thead>
        <tbody>
        [#list eventStats.eventCountsMap.entrySet() as entry]
        <tr>
            <td>
            ${entry_index+1}.
            </td>
            <td>${entry.key}</td>
            <td>${entry.value}</td>
        </tr>
        [/#list]
        </tbody>
    </table>


    <h1>[@ww.text name='system.internal.scheduler' /]</h1>

    <table class="aui">
        [#list jobDetailMultimap.asMap().entrySet() as entry]
            <thead>
                <tr>
                    <th colspan="4">[@ww.text name='system.internal.scheduler.group' /] ${entry.key}</th>
                </tr>
            </thead>
            <tbody>
                [#list entry.value as jobDetail]
                    <tr>
                        <td>
                            ${jobDetail_index+1}.
                        </td>
                        <td>
                            ${jobDetail.fullName}
                            <div class="small grey">
                                ${jobDetail.jobClass.name}
                            </div>
                        </td>
                        <td>
                            [#list scheduler.getTriggersOfJob(jobDetail.name, jobDetail.group) as trigger]
                                ${trigger.nextFireTime?datetime}
                                <div class="small grey">(in ${durationUtils.getRelativeToDate(trigger.nextFireTime.time)})</div>
                                <br />
                            [/#list]
                        </td>
                        <td>
                            [#assign dataMap = jobDetail.getJobDataMap() /]
                            [#list dataMap.keys as key]
                                ${key!}: ${dataMap.get(key)!}
                                <br />
                            [/#list]
                        </td>
                    </tr>
                [/#list]
            </tbody>
        [/#list]
    </table>
</body>
</html>

[#macro showBambooCache bambooCache]
[#-- @ftlvariable name="bambooCache" type="com.atlassian.bamboo.plan.cache.BambooCacheStats" --]
    [#assign stats = bambooCache.stats /]
    <table class="aui grid">
        <colgroup>
            <col width="200px">
            <col>
        </colgroup>
        <tbody>
            <tr>
                <td>size()</td><td>${bambooCache.cacheSize}</td>
            </tr>
            <tr>
                <td>requestCount()</td><td>${stats.requestCount()}</td>
            </tr>
            <tr>
                <td>hitCount()</td><td>${stats.hitRate()?string.percent}</td>
            </tr>
            <tr>
                <td>missCount()</td><td>${stats.missRate()?string.percent}</td>
            </tr>
            <tr>
                <td>loadCount()</td><td>${stats.loadCount()} [#if stats.loadExceptionCount() > 0] (Errors: stats.loadExceptionCount()) [/#if]</td>
            </tr>
            <tr>
                <td>averageLoadPenalty()</td><td>[#assign averageTimeMillsSec = stats.averageLoadPenalty() / 1000000 /]${averageTimeMillsSec?floor}ms</td>
            </tr>
            <tr>
                <td>evictionCount()</td><td>${stats.evictionCount()}</td>
            </tr>
        </tbody>
    </table>
[/#macro]

[#macro showExeStats exeStats]

<h3>Running Workers: ${exeStats.activeCount} / ${exeStats.poolSize}</h3>
    [#if exeStats.threadToRunnableMappings?has_content]
    <table class="aui grid">
        <thead>
        <tr>
            <th>Thread</th>
            <th>Invoking</th>
            <th>Started</th>
        </tr>
        </thead>
        <tbody>
            [#list exeStats.threadToRunnableMappings.entrySet() as entry]
            <tr>
                [#assign threadName = entry.key /]
                [#assign runnable = entry.value.first /]
                [#assign startedDate = entry.value.second /]
                <td>
                ${entry_index+1}. ${threadName}
                </td>
                <td>${runnable.event!(runnable)} <br/> ${runnable.listenerInvoker!""}</td>
                <td>${startedDate?datetime} (${durationUtils.getRelativeDate(startedDate)} ago)</td>
            </tr>
            [/#list]
        </tbody>
    </table>
    [#else]
    <p>Nothing running</p>
    [/#if]



<h3>Pending events: ${exeStats.eventsQueue?size}</h3>
    [#if exeStats.eventsQueue?has_content]
    <table class="aui grid">
        <thead>
        <tr>
            <th>&nbsp;</th>
            <th>Event</th>
            <th>Event Listener</th>
        </tr>
        </thead>
        <tbody>
            [#list exeStats.eventsQueue as runnable]
            <tr>
                <td>
                ${runnable_index+1}.
                </td>
                <td>${runnable.event!(runnable)}</td>

                <td>${runnable.listenerInvoker!""}</td>
            </tr>
            [/#list]
        </tbody>
    </table>
    [#else]
    <p>No pending events</p>
    [/#if]


[/#macro]
