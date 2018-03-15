[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[@ui.bambooPanel titleKey='elastic.instance.details' descriptionKey='elastic.instance.details.description']
    [@ww.label labelKey='elastic.instance.agent.status' escape=false]
        [@ww.param name="value"]
            <img src="${req.contextPath?html}${action.getStateImagePath()?html}" alt="${action.getStateDescription()?html}" />
            ${action.getStateDescription()?html}
        [/@ww.param]
    [/@ww.label]

    [#if instance.instanceStatus.hostname??]
        [#if instance.instanceStatus.hostname==instance.instanceStatus.address] [#-- no DNS name, normal for VPC --]
            [@ww.label labelKey='elastic.instance.address' escape=false value=instance.instanceStatus.address/]
        [#else]
            [@ww.label labelKey='elastic.instance.address' escape=false value=instance.instanceStatus.hostname description="${action.getText('elastic.instance.ip')}: ${instance.instanceStatus.address}" /]
        [/#if]
    [/#if]

    [#if instance.instanceStatus.launchTime??]
        [@ww.label labelKey='elastic.instance.agent.start' value="${instance.instanceStatus.launchTime?datetime?string.short} (${durationUtils.getRelativeDate(instance.instanceStatus.launchTime.time)} ${action.getText('global.dateFormat.ago')})" /]
    [/#if]

    [#if buildAgent?? && agentDefinition??]
        [@ww.url id='agentUrl' namespace='/admin/agent' action='viewAgent' agentId=agentDefinition.id /]
        [@ww.label labelKey='elastic.instance.agent' showDescription=true escape=false]
            [@ww.param name="value"]
                <a href="${agentUrl}">${buildAgent.name?html}</a> (${buildAgent.agentStatus.label})
            [/@ww.param]
        [/@ww.label]
    [#elseif agent.agentLoading]
        [@ww.label labelKey='elastic.instance.agent' escape=false]
            [@ww.param name="value"]
                [@ui.icon type="building" /]
                Pending
            [/@ww.param]
        [/@ww.label]
    [/#if]


	[#assign availabilityZoneText]
		${instance.instanceStatus.availabilityZone!}[#if instance.instanceConfiguration.subnetId?has_content], VPC ${instance.instanceConfiguration.subnetId?replace('-', ' ')} [/#if]

		[#if image?has_content && !image.availabilityZone?has_content]
			[@ww.text name='elastic.image.configuration.availabilityZone.default.suffix'/]
		[/#if]
	[/#assign]

    [@ww.label labelKey='elastic.image.configuration.availabilityZone.current' value='${availabilityZoneText}' /]

    [@ui.displayText]
        [#assign instanceVolumes = action.getVolumes(agent.instance.instanceStatus.instanceId)/]
        [#if instanceVolumes?has_content]
            <table id="attachedVolumes" class="aui">
                <thead>
                    <tr><th>[@ww.text name='elastic.instance.volumes' /]</th></tr>
                </thead>
                <tbody>
                [#list instanceVolumes as volume]
                    <tr><td>${volume.deviceName}</td><td>${volume.ebs.volumeId}</td><td>[@ui.time datetime=volume.ebs.attachTime/]${volume.ebs.attachTime?datetime?string}</td><td>${volume.ebs.status}</td></tr>
                [/#list]
                </tbody>
            </table>
        [/#if]
    [/@ui.displayText]

    [@ui.bambooSection titleKey='elastic.configuration']
        [@ela.elasticImageConfigurationViewProperties configuration=image displayConfigurationUrl=true short=true /]
    [/@ui.bambooSection]

    [#if action.allowShutdown()]
        [@ui.displayButtonContainer]
            [@ww.url id="shutdownInstanceUrl" action='shutdownElasticInstance' namespace='/admin/elastic' instanceId=instanceId returnUrl='/admin/elastic/viewElasticInstance.action?instanceId=${instanceId}' /]
            <a href="${shutdownInstanceUrl}" class="aui-button">[@ww.text name='elastic.manage.shutdown' /]</a>
        [/@ui.displayButtonContainer]
    [/#if]
[/@ui.bambooPanel]

[#if instance.instanceStatus.address??]
    [#if action.checkIfPkFileExists()]
        [#assign pkFileExists=1 /]
        [@ww.url id='pkFileUrl' namespace='/admin/elastic' action='getPkFile' /]
        [#assign downloadSite='<a href="${pkFileUrl}">here</a>' /]
        [#assign pkFile='<a href="${pkFileUrl}">${pkFileLocation}</a>' /]
    [#else]
        [#assign pkFileExists=0 /]
        [#assign downloadSite='' /]
        [#assign pkFile='elasticbamboo.pk' /]
    [/#if]

[@ui.bambooPanel cssClass='hideHeadingSection' ]

[#if rdcEnabled ]
    [@ui.bambooSection titleKey='elastic.instance.rdc']
        [#if password??]
            [@ww.text name='elastic.instance.rdc.description']
                [@ww.param]${password}[/@ww.param]
            [/@ww.text]
        [#else]
            [@ww.text name='elastic.instance.rdc.unavailable'/]
        [/#if]
    [/@ui.bambooSection]
[/#if]

[#if sshEnabled ]
    [@ui.bambooSection titleKey='elastic.instance.ssh']
            [@ww.text name='elastic.instance.ssh.description']
                [@ww.param value=pkFileExists /]
                [@ww.param]${downloadSite}[/@ww.param]
                [@ww.param]${pkFile}[/@ww.param]
                [@ww.param]${instance.instanceStatus.hostname?html}[/@ww.param]
                [@ww.param][@help.url pageKey="elastic.configure.keys"]online documentation[/@help.url][/@ww.param]
            [/@ww.text]
    [/@ui.bambooSection]
    [@ui.bambooSection titleKey='elastic.instance.logs']
            [@ww.text name='elastic.instance.logs.description']
                [@ww.param]${pkFile}[/@ww.param]
                [@ww.param]${instance.instanceStatus.hostname?html}[/@ww.param]
            [/@ww.text]
    [/@ui.bambooSection]
[/#if]

[@ui.bambooSection titleKey='elastic.instance.amazon.console']
    [@ww.text name='elastic.instance.amazon.console.description' ]
        [@ww.param]${instanceId}[/@ww.param]
    [/@ww.text]
    <iframe id="amazonLogs" src="https://console.aws.amazon.com/ec2/_consoleOutputDecoded.jsp?action.InstanceId=${instanceId}">
    </iframe>
[/@ui.bambooSection]
[/@ui.bambooPanel]
[/#if]
