[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.multiple?? && parameters.multiple!false]
    [#assign classToAdd = "multi-select" /]
[#else]
    [#assign classToAdd = "select" /]
[/#if]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "${classToAdd} ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", classToAdd) }
[/#if]
[#include "/${parameters.templateDir}/simple/select.ftl" /]
${parameters.extraUtility!}
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
