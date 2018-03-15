[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewRejectedRequirements" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewRejectedRequirements" --]
<html>
    <body>
        [#if rejectedRequirements?has_content]
        <p>
            [#if buildAgent??]
                [#if job??]
                    [@ww.text name="requirements.rejected.agent.job"/] [#rt]
                [#else]
                    [@ww.text name="requirements.rejected.agent.environment"/] [#rt]
                [/#if]
            [#else]
                [#if job??]
                    [@ww.text name="requirements.rejected.image.job"/] [#rt]
                [#else]
                    [@ww.text name="requirements.rejected.image.environment"/] [#rt]
                [/#if]
            [/#if]
            [@ww.text name="requirements.rejected.requirements"/][#lt]
        </p>
            <table class="aui requirements">
                [#list rejectedRequirements as requirement]
                    <tr>
                        <td>
                            ${requirement.label?html}
                        </td>
                        <td>
                            [@ww.text name='agent.capability.type.${requirement.capabilityGroup.typeKey}.title' /]
                        </td>
                        <td title="[@ww.text name='requirement.matchType.${requirement.matchType}.description' /]">
                            [@ww.text name='requirement.matchType.${requirement.matchType}' /]
                        </td>
                        <td>
                            [#if requirement.matchValue?has_content]
                                <span>${requirement.matchValue!?html}</span>
                            [/#if]
                        </td>
                    </tr>
                [/#list]
            </table>
        [#else]
            [@ww.text name="requirements.rejected.none"/]
        [/#if]
    </body>
</html>