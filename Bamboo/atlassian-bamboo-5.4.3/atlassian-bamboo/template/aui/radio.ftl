[#--
NOTE: The 'header' stuff that follows is in this one file for radio due to the fact
that for radios we do not want the label field to show up as radios handle their own
lables
--]
[#assign itemKey = parameters.fieldValue /]
<div[#if (parameters.id)?has_content] id="fieldArea_${parameters.id}"[/#if] class="radio[#if parameters.required!false] required[/#if]">

    [#if parameters.cssClass??]
        ${tag.addParameter("cssClass", "radio ${parameters.cssClass}") }
    [#else]
        ${tag.addParameter("cssClass", "radio") }
    [/#if]
    [#include "/${parameters.templateDir}/simple/radio.ftl" /]

    [#if parameters.label?? || parameters.labelKey??]
        <label[#if (parameters.id)?has_content] for="${parameters.id?html}${itemKey?html}" id="label_${parameters.id}"[/#if]>[#t/]
            [#if parameters.labelKey??]
                [@ww.text name=parameters.labelKey /][#t/]
            [#else]
                ${parameters.label}[#t/]
            [/#if]
            [#if parameters.required!false]
                <span class="aui-icon icon-required"></span><span class="content"> (required)</span>[#t/]
            [/#if]
        </label>[#t/]
    [/#if]
    
    [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-core.ftl" /][#nt/]
</div>
