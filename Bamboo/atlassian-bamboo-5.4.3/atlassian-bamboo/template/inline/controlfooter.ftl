[#if parameters.optionDescription?has_content || parameters.description?has_content || parameters.descriptionKey?has_content || (parameters.labelKey?has_content && action.doesLabelKeyHaveMatchingDescription(parameters.labelKey))]
    [#if parameters.singleLine?? && parameters.singleLine]
        <span>
    [#else]
        <div class="fieldDescription"
            [#if parameters.id?exists]
                id="${parameters.id?html}Desc"[#rt/]
            [/#if]
        >
    [/#if]
        <label for="${parameters.id?html}">[#t/]
            [#if parameters.descriptionKey?has_content]
                [@ww.text name="${parameters.descriptionKey}" /][#t/]
            [#elseif parameters.description?has_content ]
                ${parameters.description}[#t/]
            [#elseif parameters.labelKey?has_content && action.doesLabelKeyHaveMatchingDescription(parameters.labelKey)]
                ${action.getDescriptionFromLabelKey(parameters.labelKey)}[#t/]
            [/#if]
        </label>[#t/]
    [#if parameters.singleLine??]
        </span>
    [#else]
        </div>
    [/#if]
[/#if]

[#assign hasFieldErrors=parameters.name?exists && fieldErrors?exists && fieldErrors[parameters.name]?exists/]
[#if hasFieldErrors]
    <div [#rt/][#if parameters.id?exists]id="wwerr_${parameters.id}"[#rt/][/#if] class="wwerr">
    [#list fieldErrors[parameters.name] as error]
        <div[#rt/]
        [#if parameters.id?exists]
            errorFor="${parameters.id}"[#rt/]
        [/#if]
            class="errorMessage">
        ${error?html}
        </div>[#t/]
    [/#list]
    </div>
[/#if]
