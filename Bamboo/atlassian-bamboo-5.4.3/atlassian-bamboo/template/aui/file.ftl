[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "upfile ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "upfile") }
[/#if]
[#include "/${parameters.templateDir}/simple/file.ftl" /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
