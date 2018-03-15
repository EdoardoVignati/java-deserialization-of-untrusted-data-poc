[#--
    A template for a Key field. By default, it's short and required. Requires a formField
    @param id
    @param fromField
--]
[#if !parameters.id?has_content]
    ${tag.addParameter("cssClass", "text short-field ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text short-field") }
[/#if]
[#if !parameters.id?has_content]
    ${tag.addParameter("id", "${parameters.name}") }
[/#if]
[#if !parameters.required?has_content]
    ${tag.addParameter("required", true) }
[/#if]

[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
<script>
    AJS.$(function () {
              AJS.$("#${parameters.id?html}").generateFrom(AJS.$("#${parameters.fromField?html}"), {
                  maxNameLength: 255,
                  maxKeyLength: 255
              });
          });
</script>
