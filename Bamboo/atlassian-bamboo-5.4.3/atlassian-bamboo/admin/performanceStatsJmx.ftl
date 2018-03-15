[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.PerformanceStatsJmxAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.PerformanceStatsJmxAction" --]

<html>
<head>
    <title>Performance Statistics</title>
    <meta name="decorator" content="atl.popup">
    <style type="text/css">
        td:not(:first-child) div {
            text-overflow: ellipsis;
            width: 50px;
            overflow: hidden;
        }
    </style>
</head>

<body>
<h1>Performance Statistics</h1>

<h2>ActiveMQ statistics</h2>

[#if !jmxConnectionPresent]
    [@ui.messageBox type="error" title="JMX connection failed"]
    Bamboo was unable to open a JMX connection. Please make sure you're running your Bamboo Server with <code>-Dbamboo.broker.useJmx=true</code>
    [/@ui.messageBox]
[#else]
    [#assign allBrokerStats = brokerStats /]

    [#list allBrokerStats as statsForBroker]
    <h3>Broker ${statsForBroker.first?html}</h3>
    <table class="aui">
        [#list statsForBroker.second as stat]
            [#if stat.second?has_content]
                <tr>
                    <td>${stat.first?html}</td>
                    <td>${stat.second?html}</td>
                </tr>
            [/#if]
        [/#list]
    </table>
    [/#list]

    [@showTable "Queues" queueStats/]
    [@showTable "Topics" topicStats/]
    [@showTable "Producers" producerStats/]
    [@showTable "Subscribers" subscriberStats/]
    [@showTable "Topic Subscribers" topicSubscriberStats/]

    [#if remainingJmxObjects?has_content]
        <h3>Remaining objects</h3>
        ${remainingJmxObjects}
    [/#if]

<h3>C3P0 stats</h3>
<table class="aui">
    [#list c3p0Stats as c3p0Stat]
        <tr>
            <td>${c3p0Stat.first?html}</td>
            <td>${c3p0Stat.second?html}</td>
        </tr>
    [/#list]
</table>
[/#if]

</body>
</html>

[#macro showTable name data]
<h2>${name?html}</h2>

<div style="overflow:auto;">
    <table class="aui jmxTable" style="font-size: 10px">
        [#list data as statForObjects]
            <tr>
                [#list statForObjects as statForObject]
                    <td><div title="${statForObject?html}">${statForObject?replace("com.atlassian.bamboo.", "")?html}</div></td>
                [/#list]
            </tr>
        [/#list]
    </table>
</div>
[/#macro]