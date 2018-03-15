[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.AllElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.AllElasticInstancesAction" --]
[#-- @ftlvariable name="spotInstanceRequests" type="java.util.List<com.amazonaws.services.ec2.model.SpotInstanceRequest>" --]
[#-- @ftlvariable name="elasticInstances" type="java.util.Collection<com.atlassian.aws.ec2.EC2InstanceInfo>" --]


[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
<html>
<head>
    <title>[@ww.text name='elastic.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='elastic.manage.all.instances.heading'][@ww.param]${elasticConfig.region.displayName}[/@ww.param][/@ww.text]</h1>
    <p>[@ww.text name='elastic.manage.all.instances.description'/]</p>
    
    [#if actionErrors?has_content]
        [@ww.actionerror /]
    [#else]
        [@ui.bambooPanel]
            [#if allSpotInstanceRequests?has_content]
                [@ui.bambooSection titleKey='Pending Spot Instance Requests']
                    [@showSpotInstanceRequests allSpotInstanceRequests /]
                [/@ui.bambooSection]
            [/#if]

            [#if disconnectedElasticInstances?has_content]
                [@ww.url id='shutdownAllDisconnectedElasticInstancesUrl' action='shutdownAllDisconnectedElasticInstances' namespace='/admin/elastic' returnUrl=currentUrl /]
                [@ui.bambooSection
                    titleKey='elastic.manage.all.not.connected.instances'
                    tools='<a class="mutative" href="${shutdownAllDisconnectedElasticInstancesUrl}">${action.getText("elastic.manage.shutdown.all.disconnected.instances")}</a>'
                ]
                    [@showElasticInstances disconnectedElasticInstances /]
                [/@ui.bambooSection]
            [/#if]
    
            [#if unrelatedElasticInstances?has_content]
                [@ui.bambooSection titleKey='elastic.manage.all.other.instances']
                    [@ui.messageBox type="warning"]
                        [@ww.text name="elastic.manage.all.other.instances.dont.complain.if.you.clicked.yes"/]
                    [/@ui.messageBox]
                    [@showElasticInstances unrelatedElasticInstances /]
                [/@ui.bambooSection]
            [/#if]

            [#if detachedVolumes?has_content]
                [@ww.url id='deleteAllDetachedEbsVolumesUrl' action='deleteAllDetachedEbsVolumes' namespace='/admin/elastic' returnUrl=currentUrl /]
                [@ui.bambooSection
                    titleKey='elastic.manage.detached.ebs.volumes'
                    tools='<a class="mutative" href="${deleteAllDetachedEbsVolumesUrl}">${action.getText("elastic.manage.delete.all.detached.volumes")}</a>' ]
                    <table id="elastic-agents" class="aui">
                        <thead><tr>
                            <th>[@ww.text name='elastic.manage.ebs.volume.id' /]</th>
                            <th>[@ww.text name='elastic.manage.ebs.volume.status' /]</th>
                            <th>[@ww.text name='elastic.manage.ebs.volume.operations' /]</th>
                        </tr></thead>
                        <tbody>
                            [#list detachedVolumes as volume]
                                <tr>
                                    <td> ${volume.volumeId} </td>
                                    <td> ${volume.state} </td>
                                    <td>
                                        [#if volume.state == "available"]
                                            <a class="mutative" href="${req.contextPath}/admin/elastic/deleteEbsVolume.action?volumeId=${volume.volumeId}&amp;returnUrl=${currentUrl}">[@ww.text name='elastic.manage.delete.volume' /]</a>
                                        [/#if]
                                    </td>
                                </tr>
                            [/#list]
                        </tbody>
                    </table>
                [/@ui.bambooSection]
            [/#if]
        [/@ui.bambooPanel]
    [/#if]
</body>
</html>


[#macro showSpotInstanceRequests spotInstanceRequests ]
<table id="spot-requests" class="aui">
    <thead>
        <tr>
            <th>[@ww.text name='Request Id' /]</th>
            <th>[@ww.text name='Type' /]</th>
            <th>[@ww.text name='Creation Time' /]</th>
            <th>[@ww.text name='Maximium Bid' /]</th>
            <th>[@ww.text name='elastic.image.configuration.availabilityZone' /]</th>
            <th>[@ww.text name='elastic.manage.instance.state' /]</th>
            [#-- <th>[@ww.text name='elastic.manage.instance.operations' /]</th> --]
        </tr>
    </thead>
    <tbody>
        [#list spotInstanceRequests as spotRequest]
        <tr>
            <td> ${spotRequest.spotInstanceRequestId} </td>
            <td> ${spotRequest.launchSpecification.instanceType} </td>
            <td> [@ui.time datetime=spotRequest.createTime]${spotRequest.createTime?datetime?string("hh:mm a, EEE, d MMM")}[/@ui.time] </td>
            <td> $${spotRequest.spotPrice?replace("0+$", "", "r")} </td>
            <td> ${spotRequest.availabilityZoneGroup!"n/a"} </td>
            <td> ${spotRequest.state} </td>
            [#-- <td>
                [#if spotRequest.state == "open"]
                    <a id="cancel:${spotRequest.spotInstanceRequestId}" href="${req.contextPath}/admin/elastic/shutdownDisconnectedElasticInstance.action?instanceId=${spotRequest.spotInstanceRequestId}&amp;returnUrl=${currentUrl}">[@ww.text name='Cancel' /]</a>
                [/#if]
            </td> --]
        </tr>
        [/#list]
    </tbody>
</table>
[/#macro]

[#-- =================================================================================================== @showElasticInstances --]
[#macro showElasticInstances elasticInstances ]
    [#if elasticInstances?has_content]
        <table id="elastic-agents" class="aui">
            <thead><tr>
                <th>[@ww.text name='elastic.manage.instance.id' /]</th>
                <th>[@ww.text name='elastic.manage.instance.type' /]</th>
                <th>[@ww.text name='elastic.manage.instance.launch.time' /]</th>
                <th>[@ww.text name='elastic.manage.instance.dns.name' /]</th>
                <th>[@ww.text name='elastic.manage.instance.availability.zone' /]</th>
                <th>[@ww.text name='elastic.manage.instance.state' /]</th>
                <th>[@ww.text name='elastic.manage.instance.operations' /]</th>
            </tr></thead>
            <tbody>
                [#list elasticInstances as instance]
                    <tr>
                        <td> ${instance.instanceId} </td>
                        <td> ${instance.instanceType} </td>
                        <td> [@ui.time datetime=instance.launchTime]${instance.launchTime?datetime?string("hh:mm a, EEE, d MMM")}[/@ui.time] </td>
                        <td> [@showInstanceAddress instance/] </td>
                        <td> ${instance.placement.availabilityZone} </td>
                        <td> ${instance.state.name} </td>
                        <td>
                            [#if instance.state.name == "running" || instance.state.name == "stopped" ]
                                <a id="shutdown:${instance.instanceId}" class="mutative" href="${req.contextPath}/admin/elastic/shutdownDisconnectedElasticInstance.action?instanceId=${instance.instanceId}&amp;returnUrl=${currentUrl}">[@ww.text name='elastic.manage.shutdown' /]</a>
                            [/#if]
                        </td>
                    </tr>
                [/#list]
            </tbody>
        </table>
    [/#if]

[/#macro]

[#macro showInstanceAddress instance]
    [#if instance.publicDnsName?has_content]
    ${instance.publicDnsName}
    [#elseif instance.privateDnsName?has_content]
    ${instance.privateDnsName}
    [#elseif instance.publicIpAddress?has_content]
    ${instance.publicIpAddress}
    [#else]
    ${instance.privateIpAddress!}
    [/#if]
[/#macro]