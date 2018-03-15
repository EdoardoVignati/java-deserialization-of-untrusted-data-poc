[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]

[#import "/agent/agentAvailability.ftl" as bd]
[@bd.showMatchingImages executableAgentsMatrix=executableAgentMatrix i18nSuffix="job"/]
