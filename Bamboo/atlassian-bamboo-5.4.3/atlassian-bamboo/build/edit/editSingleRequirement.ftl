[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRequirement" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRequirement" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
[@ww.form action='updateBuildRequirement' namespace='/build/admin/edit'
    submitLabelKey='global.buttons.update']
    [@ww.hidden name="returnUrl" /]
    [@agt.editRequirementForm requirement=requirementId /]
[/@ww.form]
