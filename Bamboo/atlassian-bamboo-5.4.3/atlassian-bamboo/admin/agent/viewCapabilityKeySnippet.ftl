[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]

[#import "/admin/agent/viewCapabilityKeyMacro.ftl" as capabilityMacro]
[@capabilityMacro.viewCapabilityKey parentUrl="${parentUrl}" mode="tabs"/]