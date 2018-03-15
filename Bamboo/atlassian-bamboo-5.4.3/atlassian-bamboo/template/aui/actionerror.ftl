[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]

[#if action.hasActionErrors() ]
[@ui.messageBox type='error']
    [#if actionErrors.size() == 1 ]
        <p>${formattedActionErrors.iterator().next()}</p>
    [#else ]
        <ul>
            [#list formattedActionErrors as error]
                <li>${error}</li>
            [/#list]
        </ul>
    [/#if]
[/@ui.messageBox]
[/#if]
