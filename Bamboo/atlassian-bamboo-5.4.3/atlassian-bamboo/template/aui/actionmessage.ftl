[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]

[#if action.hasActionMessages() ]
[@ui.messageBox type='success']
    [#if actionMessages.size() == 1 ]
        <p class="title">${formattedActionMessages.iterator().next()}</p>
    [#else ]
        <ul>
            [#list formattedActionMessages as message]
                <li>${message}</li>
            [/#list]
        </ul>
    [/#if]
[/@ui.messageBox]
[/#if]