[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
${tag.addParameter("cssClass", "textarea ${parameters.cssClass}") }
[#else]
${tag.addParameter("cssClass", "textarea") }
[/#if]
[#include "/${parameters.templateDir}/simple/ace-textarea.ftl" /]
[#if parameters.showDescription?? && parameters.showDescription==false]
    [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-nodescription.ftl" /]
[#else]
    [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
[/#if]
