[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>
    [@ww.text name='agent.view.heading.' + agent.type.identifier /]
    [#switch agent.type.identifier]
    [#case "local"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedLocalCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "remote"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedRemoteCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "elastic"]
    [#break]
    [/#switch]
    - ${agent.name?html}
    </title>
    [@ww.url value='/admin/agent/viewAgents.action' id='agentsListUrl' /]    
    <meta name="decorator" content="adminpage">
</head>

<body>
[@agt.header /]
[@agt.agentDetails headerKey='agent.details' agentId=agent.id showOptions="all" /]

[#switch agent.type.identifier]
    [#case "local"]
    [#case "remote"]
        [#assign tabs=[action.getText('agent.capabilities'),action.getText('agent.builds.execute'),action.getText('system.info.title'), action.getText('auditlog.agent'), action.getText('system.errors.title')] /]
        [#break]
    [#case "elastic"]
        [#assign tabs=[action.getText('elastic.image.capabilities'),action.getText('agent.builds.execute'),action.getText('system.info.title'), action.getText('auditlog.agent'), action.getText('system.errors.title')] /]
        [#break]
[/#switch]
[@dj.tabContainer headings=tabs selectedTab=selectedTab!]
    [#switch agent.type.identifier]
    [#case "local"]
    [#case "remote"]
        [@dj.contentPane labelKey='agent.capabilities']
            [#-- Specific Capabilities --]
            [@ww.url action='configureAgentCapability' namespace='/admin/agent' agentId='${agentId}' id='addCapabilityUrl' /]
            [@ui.bambooPanel titleKey='agent.capability.specific.title' descriptionKey='agent.capability.specific.description'
                             tools='<a id="addCapability" href="${addCapabilityUrl}">${action.getText("agent.capability.add")}</a>']
                [#if capabilitySet?exists && capabilitySet.capabilities?has_content]
                    <p>[@ww.text name='agent.capability.specific.prefix' /]</p>
                    [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator
                                             addCapabilityUrlPrefix=addCapabilityUrl
                                             showDelete=true /]
                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    <p>[@ww.text name='agent.capability.specific.empty' /]</p>
                [/#if]
            [/@ui.bambooPanel]


            [#-- Shared Capabilities --]
            [#if (fn.hasGlobalAdminPermission())]
                [#assign editLink]
                    <a  id="addSharedCapability" href="${sharedCapabilityUrl}">${action.getText("global.buttons.edit")}</a>
                [/#assign]
            [#else]
                [#assign editLink='']
            [/#if]

            [@ui.bambooPanel titleKey='agent.capability.inherited.shared.title' descriptionKey='agent.capability.inherited.shared.description' tools=editLink]
                [#if sharedCapabilitySet?exists && sharedCapabilitySet.capabilities?has_content]
                    [@agt.displayCapabilities capabilitySetDecorator=sharedCapabilitySetDecorator addCapabilityUrlPrefix='' showDescription=showDesc/]
                [#else]
                    <p>[@ww.text name='agent.capability.inherited.shared.empty' /]</p>
                [/#if]
            [/@ui.bambooPanel]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablePlans showLastBuild=true /]
        [/@dj.contentPane]

    [#break]
    [#case "elastic"]
        [#assign image=agent.elasticImageConfiguration]
        [@dj.contentPane labelKey='elastic.image.capabilities']
            [@ui.bambooPanel titleKey='elastic.image.capabilities' descriptionKey='elastic.image.capabilities.description']
                [#if capabilitySet?exists && capabilitySet.capabilities?has_content]
                    [@ui.displayText key='elastic.image.capabilities.prefix' /]
                    [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator showEdit=false showDelete=false /]
                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    [@ui.displayText key='elastic.image.capabilities.empty' /]
                [/#if]
            [/@ui.bambooPanel]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablePlans /]
        [/@dj.contentPane]
    [#break]
    [/#switch]

    [@dj.contentPane labelKey='system.info.title']
        [#if systemInfo??]
            [@ui.bambooPanel]
                [@ww.label label='System Date' name='systemInfo.systemDate' /]
                [@ww.label label='System Time' name='systemInfo.systemTime' /]
                [@ww.label label='Up Time' name='systemInfo.uptime' /]
                [@ww.label label='Username' name='systemInfo.userName' /]
                [@ww.label label='User Timezone' name='systemInfo.userTimezone' /]
                [@ww.label label='User Locale' name='systemInfo.userLocale' /]
                [@ww.label label='System Encoding' name='systemInfo.systemEncoding' /]
                [@ww.label label='Operating System' name='systemInfo.operatingSystem' /]
                [@ww.label label='Operating System Architecture' name='systemInfo.operatingSystemArchitecture' /]
                [@ww.label label='Available Processors' name='systemInfo.availableProcessors' /]
            [/@ui.bambooPanel]
            [@ui.bambooPanel title="Network"]
                [@ww.label label='Host Name' name='systemInfo.hostName' /]
                [@ww.label label='IP Address' name='systemInfo.ipAddress' /]
            [/@ui.bambooPanel]
            [@ui.bambooPanel title="Memory Statistics" ]
                [@ww.label label='Total Memory' value='${systemInfo.totalMemory} MB' /]
                [@ww.label label='Free Memory' value='${systemInfo.freeMemory} MB' /]
                [@ww.label label='Used Memory' value='${systemInfo.usedMemory} MB' /]
            [/@ui.bambooPanel]
            [@ui.bambooPanel title='Bamboo Paths']
                [@ww.label label='Current running directory' name='systemInfo.currentDirectory' /]
                [@ww.label labelKey='config.server.buildDirectory' name='systemInfo.buildWorkingDirectory' /]
                [@ww.label label='Bamboo Home' name='systemInfo.applicationHome' /]
                [@ww.label label='Temporary directory' name='systemInfo.tempDir' /]
                [@ww.label labelKey='system.bambooPaths.userHome' name='systemInfo.userHome' /]
            [/@ui.bambooPanel]
            [@ui.bambooPanel titleKey='system.file.stats']
                [@ww.label labelKey='system.file.disk.free' name='systemInfo.freeDiskSpace' /]
            [/@ui.bambooPanel]
        [#else]
            <p>[@ww.text name='No system information found' /]</p>
        [/#if]
    [/@dj.contentPane]
    
    [@dj.contentPane labelKey='auditlog.agent']
    	[@cp.configChangeHistory pager=pager /]
    [/@dj.contentPane]
    
    [@dj.contentPane labelKey='system.errors.title']
			[#assign numErrors = systemErrorMessages.size()]
			<p>
			    [@ww.text name='system.errors.description']
			        [@ww.param value=numErrors /]
			    [/@ww.text]
			</p>
						
			[#if numErrors gt 0]
			    [#list systemErrorMessages as error]
			        [@cp.showSystemError error=error returnUrl=currentUrl /]
			    [/#list]
			[/#if]
    [/@dj.contentPane]
    
[/@dj.tabContainer]

</body>
</html>
