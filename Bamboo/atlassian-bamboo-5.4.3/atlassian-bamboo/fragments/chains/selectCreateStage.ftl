[#-- @ftlvariable name="immutableChain" type="com.atlassian.bamboo.plan.cache.ImmutableChain" --]
[#--
    Requirements:

    existingProjects    collection of project objects
    existingProjectKey  scalar which will hold existing project's key 
    projectKey          scalar which will hold new project key
    projectName         scalar which will hold new project name
--]
[#if allowStageCreation]
    [#if immutableChain.stages?has_content]
        [@ww.select labelKey='stage' name='existingStage' toggle='true'
                    list='immutableChain.stages' listKey='name' listValue='name'
                    headerKey='<newStage>' headerValue='<New Stage>' ]
        [/@ww.select]

        [@ui.bambooSection dependsOn='existingStage' showOn='newStage']
            [@ww.textfield labelKey='stage.name' name='stageName' required='true' /]
            [@ww.textfield labelKey='stageDescription' name='stageDescription' required='false' /]
        [/@ui.bambooSection]
    [#else]
        [@ww.textfield labelKey='stage.name' name='stageName' required='true' /]
        [@ww.textfield labelKey='stageDescription' name='stageDescription' required='false' /]
    [/#if]
    [@ww.hidden name="allowStageCreation"/]
[#else]
    [#if immutableChain.stages?has_content]
        [#if existingStage?has_content]
            [@ww.hidden name='existingStage' /]
        [#else]
            [@ww.select labelKey='stage' name='existingStage' toggle='true'
                        list='immutableChain.stages' listKey='name' listValue='name']
            [/@ww.select]
        [/#if]
    [#else]
        [@ui.messageBox type="warning"]
            [@ww.text name="stage.list.empty"]
              [@ww.param][@ww.url value="/browse/${buildKey}/stages"/][/@ww.param]
            [/@ww.text]
        [/@ui.messageBox]
    [/#if]
[/#if]