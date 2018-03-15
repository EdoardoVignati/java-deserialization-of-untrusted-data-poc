[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.list.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

[@ui.header pageKey='elastic.image.configuration.list.heading' descriptionKey='elastic.image.configuration.list.description' /]

[@ww.actionerror /]

<table id="elasticImageConfigurations" class="aui">
    <thead>
        <tr>
            <th>[@ww.text name='elastic.image.configuration.configurationName.heading'/]</th>
            <th>[@ww.text name='elastic.image.configuration.amiId'/]</th>
            <th>[@ww.text name='elastic.image.configuration.ebsSnapshotId'/]</th>
            <th>[@ww.text name='elastic.instance.type'/]</th>
            <th>[@ww.text name='elastic.image.configuration.availabilityZone.preferred'/]</th>
            <th>[@ww.text name='elastic.image.configuration.numberOfActiveInstances.heading'/]</th>
            <th>[@ww.text name='global.heading.operations'/]</th>
        </tr>
    </thead>
    <tbody>
        [#list elasticImageConfigurations as elasticImageConfiguration]
        [#assign activeInstanceCount = elasticUIBean.getActiveInstancesCountForConfiguration(elasticImageConfiguration)/]
        <tr [#if elasticImageConfiguration.disabled] class="disabled" [/#if]>
            <td><a href="[@ww.url action='viewElasticImageConfiguration' configurationId=elasticImageConfiguration.id /]" title="${elasticImageConfiguration.configurationDescription!?html}">[#t]
                [#if elasticImageConfiguration.osName?has_content]${elasticImageConfiguration.osName}:[/#if]
                ${elasticImageConfiguration.configurationName!?html}[#t]
                 </a>[#t]
                [#if elasticImageConfiguration.shippedWithBamboo]
                    <span class="grey">[@ww.text name="elastic.image.configuration.default" /]</span>
                [/#if]
                [#if elasticImageConfiguration.disabled]
                    <span class="grey"> [@ww.text name="elastic.image.configuration.disabled" /]</span>
                [/#if]
                [#if elasticImageConfiguration.dedicated]
                &nbsp;[@ui.agentDedicatedLozenge subtle=true/]
                [/#if]
            </td>
            <td>${elasticImageConfiguration.amiId!?html}</td>
            <td>[#rt]
                [#if elasticImageConfiguration.isEbsEnabled()][#t]
                    ${elasticImageConfiguration.ebsSnapshotId?html}[#t]
                [#else][#t]
                    [@ww.text name='elastic.image.configuration.ebsDisabled'/][#t]
                [/#if][#t]
            </td>[#t]
            <td>
                <span id="${elasticImageConfiguration.id}">${elasticImageConfiguration.instanceType}</span>
                [@dj.tooltip target="${elasticImageConfiguration.id}" width="500" addMarker=true]${elasticImageConfiguration.instanceType.description?replace('\n', '<br/>')}[/@dj.tooltip]
            </td>
            <td>[#rt]
                [#if elasticImageConfiguration.availabilityZone?has_content][#t]
                    ${elasticImageConfiguration.availabilityZone}[#t][#if elasticImageConfiguration.subnetId?has_content], VPC ${elasticImageConfiguration.subnetId?replace('-', ' ')} [/#if]
                [#else][#t]
                    [@ww.text name='elastic.image.configuration.availabilityZone.default'/][#t]
                [/#if][#t]
            </td>[#t]
            <td>
                <a href="[@ww.url action='viewElasticInstancesForConfiguration' namespace='/admin/elastic/image/configuration' configurationId=elasticImageConfiguration.id /]">${activeInstanceCount}</a>
            </td>
            <td class="operations">
                [#if elasticImageConfiguration.disabled]
                     <a id="enableElasticImageConfiguration-${elasticImageConfiguration.id}" class="mutative" href="[@ww.url action='enableElasticImageConfiguration' configurationId=elasticImageConfiguration.id /]">
                        [@ww.text name='global.buttons.enable'/][#t]
                     </a>[#t]
                [#else]
                    <a id="startInstancesForConfig-${elasticImageConfiguration.id}" href="[@ww.url action='prepareElasticInstances' namespace="/admin/elastic" elasticImageConfigurationId=elasticImageConfiguration.id /]">[@ww.text name='elastic.image.configuration.start.short'/]</a>
                    &nbsp;|&nbsp;[#t]
                    <a id="disableElasticImageConfiguration-${elasticImageConfiguration.id}" href="[@ww.url action='disableElasticImageConfiguration' configurationId=elasticImageConfiguration.id /]">
                        [@ww.text name='global.buttons.disable'/][#t]
                    </a>[#t]
                [/#if]
                &nbsp;|&nbsp;[#t]
                <a id="viewElasticImageConfiguration-${elasticImageConfiguration.id}" href="[@ww.url action='viewElasticImageConfiguration' configurationId=elasticImageConfiguration.id returnUrl=currentUrl/]">
                    [@ww.text name='agent.capabilities.view'/][#t]
                </a>[#t]
                &nbsp;|&nbsp;[#t]
                <a id="editElasticImageConfiguration-${elasticImageConfiguration.id}" href="[@ww.url action='editElasticImageConfiguration' configurationId=elasticImageConfiguration.id returnUrl=currentUrl /]">
                    [@ww.text name='global.buttons.edit'/][#t]
                </a>[#t]
                [#if activeInstanceCount == 0 && !elasticImageConfiguration.isShippedWithBamboo()]
                &nbsp;|&nbsp;[#t]
                 <a id="deleteElasticImageConfiguration-${elasticImageConfiguration.id}" href="[@ww.url action='deleteElasticImageConfiguration' configurationId=elasticImageConfiguration.id returnUrl=currentUrl /]">
                     [@ww.text name='global.buttons.delete'/][#t]
                </a>[#t]
                [/#if]
            </td>
        </tr>
        [/#list]
    </tbody>
</table>

<h2>[@ww.text name='elastic.image.configuration.create.heading' /]</h2>
[@ela.editElasticInstance mode="create" /]
</body>
</html>