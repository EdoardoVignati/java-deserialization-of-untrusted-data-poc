[#-- ================================================================================================ @sc.setupActionErrors--]

[#macro setupActionErrors boxClass="error"]
    [#if action.hasActionErrors() ]
    [@ui.messageBox type=boxClass]
        [#if actionErrors.size() == 1 ]
        <p class="title">${formattedActionErrors.iterator().next()}</p>
        [#else ]
            <ul>
                [#list formattedActionErrors as error]
                    <li>${error}</li>
                [/#list]
            </ul>
        [/#if]
    [/@ui.messageBox]
    [/#if]
[/#macro]

[#macro progressTracker steps isInverted=false]
    [#local itemWidth=(100 / steps?size)?string("0.####") /]
    <ol class="aui-progress-tracker[#if isInverted] aui-progress-tracker-inverted[/#if]">
        [#list steps as step]
            [@progressTrackerStep width=itemWidth text=step.text isCurrent=(step.isCurrent)!false /]
        [/#list]
    </ol>
[/#macro]

[#macro progressTrackerStep width text isCurrent=false]
    <li class="aui-progress-tracker-step[#if isCurrent] aui-progress-tracker-step-current[/#if]" style="width: ${width}%;"><span>${text?html}</span></li>
[/#macro]

[#macro time datetime cssClass='']
    <time datetime="${datetime?string("yyyy-MM-dd'T'HH:mm:ssZ")}" title="${datetime?string(action.getText('bamboo.date.format.full'))}"[#if cssClass?has_content] class="${cssClass}"[/#if]>[#nested]</time>[#t]
[/#macro]
