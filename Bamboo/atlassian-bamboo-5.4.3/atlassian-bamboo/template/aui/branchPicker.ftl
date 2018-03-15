[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]

${tag.addParameter("dataAttributes", branchPickerDataAttributes) }
${tag.addParameter("autocomplete", "off") }

<div class="aui-select2-item">
    [#include "/${parameters.templateDir}/simple/hidden.ftl" /]

    <script>
        (function($) {
            new Bamboo.Feature.BranchAutocomplete({
                el: $('#${parameters.id}')

                [#if parameters.allowClear?? && parameters.allowClear?is_boolean]
                    ,allowClear: ${parameters.allowClear?string("true", "false")}
                [/#if]

                [#if parameters.masterPlanPickerId?has_content]
                    ,masterPickerId: '${parameters.masterPlanPickerId}'
                [/#if]

                [#if parameters.placeHolder?has_content]
                    ,placeholder: '[@ww.text name=parameters.placeHolder /]'
                [/#if]

                ,params: {
                    [#if parameters.masterPlanPickerId?has_content]
                        masterPlanKey: ${fn.jqueryObjectOrUndefined(parameters.masterPlanPickerId)}.val(),
                    [#elseif parameters.masterPlanKey?has_content]
                        masterPlanKey: "${parameters.masterPlanKey}",
                    [/#if]

                    [#if parameters.releasedInDeployment?has_content && parameters.releasedInDeployment?is_number]
                        releasedInDeployment: "${parameters.releasedInDeployment?string}",
                    [/#if]

                    [#if parameters.includeMasterBranch?has_content && parameters.includeMasterBranch?is_boolean]
                        includeMasterBranch: ${parameters.includeMasterBranch?string("true", "false")}
                    [#else]
                        includeMasterBranch: false
                    [/#if]
                }
            });
        }(AJS.$));
    </script>

    [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
</div>