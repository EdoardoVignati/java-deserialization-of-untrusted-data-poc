[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]

[#import "/lib/build.ftl" as bd]

[@bd.describeAgentAvailability executableAgentMatrix=executableAgentMatrix plan=immutablePlan elasticBambooEnabled=elasticBambooEnabled/]