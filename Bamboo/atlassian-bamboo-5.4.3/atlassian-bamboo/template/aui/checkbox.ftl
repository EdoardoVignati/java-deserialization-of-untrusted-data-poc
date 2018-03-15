[#--
NOTE: The 'header' stuff that follows is in this one file for checkbox due to the fact
that for checkboxes we do not want the label field to show up as checkboxes handle their own
labels
--]
<div class="field-group">
    <div[#if (parameters.id)?has_content] id="fieldArea_${parameters.id}"[/#if] class="checkbox[#if parameters.required!false] required[/#if][#if parameters.fieldClass?has_content] ${parameters.fieldClass}[/#if]">

        [#if parameters.cssClass??]
            ${tag.addParameter("cssClass", "checkbox ${parameters.cssClass}") }
        [#else]
            ${tag.addParameter("cssClass", "checkbox") }
        [/#if]
        [#include "/${parameters.templateDir}/simple/checkbox.ftl" /]

        [#if parameters.label?? || parameters.labelKey??]
            <label[#if (parameters.id)?has_content] for="${parameters.id?html}" id="label_${parameters.id}"[/#if]>[#t/]
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

        [#include "/${parameters.templateDir}/${parameters.theme}/field-after.ftl" /]
        [#include "/${parameters.templateDir}/${parameters.theme}/field-group-end.ftl" /]
    </div>
</div>