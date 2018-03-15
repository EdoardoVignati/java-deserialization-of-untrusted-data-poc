[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.RenameAgentCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.RenameAgentCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='agent.capability.rename' /] - ${capability.label?html}</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ww.form
              action='updateRenamedCapability'
              namespace='/admin/agent'
              titleKey='agent.capability.rename'
              descriptionKey='agent.capability.rename.description'
              submitLabelKey='agent.capability.rename'
              cancelUri='/admin/agent/viewCapabilityKey.action?capabilityKey=${capabilityKey}' ]

        [@ww.hidden name='capabilityKey' /]
        [@ww.hidden name='newCapabilityLabel' /]
        [@ww.hidden name='returnUrl' /]

        [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
        [@ww.label labelKey='agent.capability.type' value="${typeText}" /]

        [@ww.label labelKey='agent.capability.type.${capabilityType}.key.old' name='capability.label' /]
        [@ww.label labelKey='agent.capability.type.${capabilityType}.key.new' name='newCapabilityLabel' /]

        [@ww.radio labelKey='agent.capability.rename.override'
               name='overrideValue'
               listKey='name' listValue='label'
               list=overrideOptions ]
        [/@ww.radio]

        [#if capabilityDeltaMap?has_content]

        [@ui.bambooSection titleKey='agent.capability.rename.conflict.agent']
            <table class="aui capabilities">
                <thead>
                    <tr>
                        <th class="agentCell labelPrefixCell">
                            [@ww.text name='agent.table.heading.name' /]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value.old' ]
                                [@ww.param]${capability.label?html}[/@ww.param]
                            [/@ww.text]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value.new' ]
                                [@ww.param]${newCapabilityLabel?html}[/@ww.param]
                            [/@ww.text]
                        </th>
                    </tr>
                </thead>
            [#list capabilityDeltaMap.entrySet() as entry]
                [#assign pipelineDefinition = entry.key /]
                [#assign oldCapability =  entry.value.oldCapability /]
                [#assign newCapability =  entry.value.newCapability /]

                <tr>
                    <td class="agentCell labelPrefixCell">
                        [#assign sharedCapabilitySetType = (oldCapability.capabilitySet.sharedCapabilitySetType)!("") /]
                        [#if sharedCapabilitySetType?has_content]
                            <a href="[@ww.url action='configureShared${sharedCapabilitySetType}Capabilities' namespace='/admin/agent' /]">[@ww.text name='agent.capability.agents.all.${sharedCapabilitySetType}' /]</a>
                        [#else]
                            [#if pipelineDefinition?has_content]
                                <a href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId=pipelineDefinition.id /]">${pipelineDefinition.name?html}</a>
                            [/#if]
                        [/#if]
                    </td>
                    <td class="valueCell">
                        ${oldCapability.value!?html}
                    </td>
                    <td class="valueCell">
                        ${newCapability.value!?html}
                    </td>
                </tr>
            [/#list]
            </table>
        [/@ui.bambooSection]

        [/#if]

        [#if requirementDeltaMap?has_content]
        [@ui.bambooSection titleKey='agent.capability.rename.conflict.plans']
            <table class="aui requirements">
                <thead>
                    <tr>
                        <th class="planCell labelPrefixCell">
                            [@ww.text name='plan.title' /]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value.old' ]
                                [@ww.param]${capability.label?html}[/@ww.param]
                            [/@ww.text]
                        </th>
                        <th class="valueCell">
                            [@ww.text name='agent.capability.type.${capabilityType}.value.new' ]
                                [@ww.param]${newCapabilityLabel?html}[/@ww.param]
                            [/@ww.text]
                        </th>
                    </tr>
                </thead>
            [#list requirementDeltaMap.entrySet() as entry]
                [#assign build = entry.key /]
                [#assign oldRequirement =  entry.value.oldRequirement /]
                [#assign newRequirement =  entry.value.newRequirement /]

                <tr>
                    <td class="planCell labelPrefixCell">
                        <a title="${build.key}" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${build.key}">${build.name}</a>
                    </td>
                    [@agt.shoRequirementCell requirement=oldRequirement /]
                    [@agt.shoRequirementCell requirement=newRequirement /]

                </tr>
            [/#list]
            </table>
        [/@ui.bambooSection]

        [/#if]
    [/@ww.form]
</body>
</html>