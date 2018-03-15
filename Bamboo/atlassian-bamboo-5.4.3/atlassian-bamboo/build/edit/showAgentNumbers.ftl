[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.DescribeAgentAvailability" --]

[#import "/agent/agentAvailability.ftl" as bd]

[@ww.url id="viewAgentsUrl" action="viewAgentsMatchingRequirements" namespace="/ajax" planKey=plan.key /]
[@ww.url id="viewImagesUrl" action="viewImagesMatchingRequirements" namespace="/ajax" planKey=plan.key /]
[@ww.url id="editRequirementsUrl" action="defaultBuildRequirement" namespace="/build/admin/edit" buildKey=plan.key /]

[@bd.showAgentNumbers executableAgentMatrix=executableAgentMatrix elasticBambooEnabled=elasticBambooEnabled i18nSuffix="job" viewAgentsUrl=viewAgentsUrl viewImagesUrl=viewImagesUrl editRequirementsUrl=editRequirementsUrl/]