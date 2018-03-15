[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]
[#import "/agent/agentAvailability.ftl" as bd]

[@ww.url id="viewAgentsUrl" value="/agent/viewAgents.action?planKey=${planKey}&returnUrl=/browse/${planKey}/config" /]
[@bd.showMatchingAgents executableAgentsMatrix=executableAgentMatrix i18nSuffix="job" viewAgentsUrl=viewAgentsUrl/]
