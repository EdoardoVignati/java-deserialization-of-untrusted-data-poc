[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.view.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

    <h1>
 	   <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfigurations.action" id="elasticConfigurationsLink" class="mutative" title="[@ww.text name='elastic.image.configuration.list.heading' /]">[#t]
 	       [@ww.text name='elastic.image.configuration.list.heading' /]</a>&nbsp;&rsaquo;&nbsp;${configuration.osName!""} ${configuration.configurationName?html} [#if configuration.shippedWithBamboo]<span class="grey">[@ww.text name="elastic.image.configuration.default" /]</span>[/#if][#if configuration.dedicated] [@ui.agentDedicatedLozenge/][/#if][#t]
 	</h1>

    [@ui.bambooPanel titleKey='elastic.image.configuration.view.title' ]
        [#if configuration.disabled]
           [@ui.messageBox type="info"]
                [@ww.text name='elastic.manage.instances.disabled']
                    [@ww.param]${configuration.configurationName?html}[/@ww.param]
                    [@ww.param][@ww.url action='enableElasticImageConfiguration' configurationId=configuration.id returnUrl='${currentUrl}'/][/@ww.param]
                    [@ww.param]mutative[/@ww.param]
                [/@ww.text]
           [/@ui.messageBox]
        [/#if]
        [#assign activeInstanceCount = elasticUIBean.getActiveInstancesCountForConfiguration(configuration)/]
        [@ela.elasticImageConfigurationViewProperties configuration=configuration /]

        [@ui.displayButtonContainer]
            [#if configuration.disabled]
                <a id="enableElasticImageConfiguration-${configuration.id}" href="[@ww.url action='enableElasticImageConfiguration' configurationId=configuration.id returnUrl='${currentUrl}'/]" class="aui-button mutative">
                    [@ww.text name='global.buttons.enable'/][#t]
                </a>[#lt]
            [#else]
                <a id="startInstancesForConfig-${configuration.id}" href="[@ww.url action='prepareElasticInstances' namespace="/admin/elastic" elasticImageConfigurationId=configuration.id /]" class="aui-button">[@ww.text name='elastic.image.configuration.start'/]</a>
                <a id="disableElasticImageConfiguration-${configuration.id}" href="[@ww.url action='disableElasticImageConfiguration' configurationId=configuration.id returnUrl='${currentUrl}'/]" class="aui-button">
                    [@ww.text name='global.buttons.disable'/][#t]
                </a>[#lt]
            [/#if]
            <a href="[@ww.url action='editElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId='${configurationId}' returnUrl='${currentUrl}' /]" class="aui-button">[@ww.text name='global.buttons.edit' /]</a>
            <a href="[@ww.url action='editElasticImageAssignments' namespace='/admin/elastic/image/configuration' configurationId='${configurationId}' returnUrl='${currentUrl}' /]" class="aui-button">[@ww.text name='agents.assignment.image.button' /]</a>

            [#if activeInstanceCount == 0 && !configuration.isShippedWithBamboo()]
                <a href="[@ww.url action='deleteElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId='${configurationId}' returnUrl='${currentUrl}' /]" class="aui-button">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]
        [/@ui.displayButtonContainer]
    [/@ui.bambooPanel]

    [#assign tabs=[action.getText('elastic.image.configuration.capabilities'),action.getText('agent.builds.execute')] /]
    [@dj.tabContainer headings=tabs selectedTab='${selectedTab!}']
        [@dj.contentPane labelKey='elastic.image.configuration.capabilities']
            [@ui.bambooPanel titleKey='elastic.image.configuration.capabilities' descriptionKey='elastic.image.configuration.capabilities.description'
                tools='<a href="#addCapability" onclick="">${action.getText("agent.capability.add")}</a> | <a href="${req.contextPath}/admin/elastic/reloadDefaultCapabilities.action?configurationId=${configuration.id}&amp;returnUrl=${currentUrl}" class="requireConfirmation mutative" title="${action.getText("elastic.image.configuration.capabilities.revert")}">${action.getText("elastic.image.configuration.capabilities.revert")}</a>'
            ]
                [#if configuration.capabilitySet?exists && configuration.capabilitySet.capabilities?has_content]
                        [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator elasticImageConfiguration=configuration showDelete=true showEdit=true/]

                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    [@ui.displayText key='elastic.image.configuration.capabilities.empty' /]
                [/#if]
            [/@ui.bambooPanel]

            [@ww.form id='addCapability' action='addElasticCapability' namespace='/admin/elastic' titleKey='agent.capability.add'
                      submitLabelKey='global.buttons.add' cancelUri=currentUrl]

                [@ww.hidden name="returnUrl" value=currentUrl /]
                [@ww.hidden name="configurationId" value=configuration.id /]
                [#include '/admin/agent/addCapabilityFragment.ftl' /]
            [/@ww.form]

        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablePlans showLastBuild=false /]
        [/@dj.contentPane]
    [/@dj.tabContainer]

</body>
</html>
