[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.tasks.DescribeAgentAvailability" --]
[#import "/agent/agentAvailability.ftl" as bd]

[@ww.url id="viewAgentsUrl" action="showMatchingAgents" namespace="/deploy/config" environmentId=environmentId /]
[@ww.url id="viewImagesUrl" action="showMatchingImages" namespace="/deploy/config" environmentId=environmentId  /]
[#--todo requirements url--]
[#--[@ww.url id="editRequirementsUrl" action="defaultBuildRequirement" namespace="/build/admin/edit/" buildKey=plan.key /]--]
[#assign i18nSuffix][#if shortened]environment.short[#else]environment[/#if][/#assign]
[@bd.showAgentNumbers executableAgentMatrix=executableAgentsMatrix elasticBambooEnabled=elasticBambooEnabled i18nSuffix=i18nSuffix viewAgentsUrl=viewAgentsUrl viewImagesUrl=viewImagesUrl editRequirementsUrl=""/]
