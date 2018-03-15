[#--
	Only show message if errors are available.
	This will be done if ActionSupport is used.
--]
<div[#if (parameters.id)?has_content] id="fieldArea_${parameters.id}"[/#if] class="field-group[#if parameters.required!false] required[/#if][#if parameters.hidden!false] hidden[/#if][#if parameters.fieldClass?has_content] ${parameters.fieldClass}[/#if]">

[#if parameters.label?? || parameters.labelKey??]
    <label[#if (parameters.id)?has_content] for="${parameters.id?html}" id="fieldLabelArea_${parameters.id}"[/#if][#if parameters.labelClass?has_content]class="${parameters.labelClass}"[/#if]>[#t/]
        [#if parameters.labelKey?has_content]
            [@ww.text name=parameters.labelKey /][#t/]
        [#elseif parameters.label?has_content]
            ${parameters.label}[#t/]
        [/#if]
        [#if parameters.required!false]
            <span class="aui-icon icon-required"></span><span class="content"> (required)</span>[#t/]
        [/#if]
    </label>[#t/]
[/#if]
