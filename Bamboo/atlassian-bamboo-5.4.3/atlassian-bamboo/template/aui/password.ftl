[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "text password ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text password") }
[/#if]
[#include "/${parameters.templateDir}/simple/password.ftl" /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
