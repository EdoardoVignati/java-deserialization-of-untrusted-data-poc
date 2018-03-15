[#if action.hasActionMessages() ]
    <ul>
        [#list formattedActionMessages as message]
            <li>${message?html}</li>
        [/#list]
    </ul>
[/#if]