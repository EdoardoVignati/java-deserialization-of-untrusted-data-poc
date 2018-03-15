[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.agent.ViewAgentDetailsAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.agent.ViewAgentDetailsAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as eln]

[#if showStatus?? && showStatus == 'yes' ]
    [@ww.label labelKey='agent.field.status' escape='false']
        [@ww.param name='value'][@agt.displayStatusCell agent=buildAgent /][/@ww.param]
    [/@ww.label]
[/#if]

[#-- elastic stuff --]
[#if buildAgent.definition.elasticInstanceId??]
    [@ww.label labelKey='agent.field.ec2.instance.id' showDescription=true escape=false]
        [@ww.param name='value']
            <strong>
                [@eln.displayElasticInstanceId instanceId=buildAgent.definition.elasticInstanceId instance=instance /]
            </strong>
            <span class="small">
                [@ww.text name='elastic.instance.ami.small' ]
                    [@ww.param][@eln.displayElasticConfigurationName configuration=buildAgent.definition.elasticImageConfiguration /][/@ww.param]
                    [@ww.param][/@ww.param]
                [/@ww.text]
            </span>
        [/@ww.param]
    [/@ww.label] 
[/#if]
[#if buildAgent.lastUpdated?exists]
    [@ww.label labelKey='agent.field.lastUpdate' showDescription=true value='${buildAgent.lastUpdated?datetime} (${durationUtils.getRelativeDate(buildAgent.lastUpdated)} ago)' /]
[/#if]
[#-- remote stuff --]
[#if buildAgent.definition.lastStartupTime??]
    [@ww.label labelKey='agent.field.ec2.lastStartupTime' value=buildAgent.definition.lastStartupTime?datetime?string.medium /]
[/#if]
[#if buildAgent.definition.lastShutdownTime??]
    [@ww.label labelKey='agent.field.ec2.lastShutdownTime' value=buildAgent.definition.lastShutdownTime?datetime?string.medium /]
[/#if]
[#if buildAgent.definition.agentUpTime??]
    [@ww.label labelKey='agent.field.ec2.uptime' value=dateUtils.formatDurationPretty(buildAgent.definition.agentUpTime/1000) /]
[/#if]



