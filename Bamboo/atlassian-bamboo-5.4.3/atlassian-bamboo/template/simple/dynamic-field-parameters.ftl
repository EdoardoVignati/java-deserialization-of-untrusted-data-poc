[#if parameters.cssClass?? && (parameters.toggle!false)?string == 'true']
    ${tag.addParameter("cssClass", "handleOnSelectShowHide ${parameters.cssClass}") }
[#elseif (parameters.toggle!false)?string == 'true']
    ${tag.addParameter("cssClass", "handleOnSelectShowHide") }
[/#if]