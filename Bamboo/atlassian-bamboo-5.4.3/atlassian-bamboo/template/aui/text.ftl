[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "text ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text") }
[/#if]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
