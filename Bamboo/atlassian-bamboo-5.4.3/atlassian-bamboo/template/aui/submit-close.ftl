[#assign classesToAdd = "aui-button" /]
[#if (parameters.primary!false)]
    [#assign classesToAdd = classesToAdd + " aui-button-primary" /]
[/#if]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", classesToAdd + " ${parameters.cssClass}")}
[#else]
    ${tag.addParameter("cssClass", classesToAdd)}
[/#if]
[#include "/${parameters.templateDir}/simple/submit-close.ftl" /]