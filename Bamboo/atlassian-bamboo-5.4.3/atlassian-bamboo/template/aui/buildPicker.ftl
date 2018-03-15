[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
${tag.addParameter("cssClass", "text plan-picker ${parameters.cssClass}") }
[#else]
${tag.addParameter("cssClass", "text plan-picker") }
[/#if]
[#assign planPickerDataAttributes = {} /]
[#--
    The conditions:
    * parameters.nameValue?split("-")?size > 1
    * parameters.nameValue?split("-")?size < 5
    prevent PlanKeys.getPlanKey from throwing an exception due to something that doesn't look like a plan key
--]
[#if parameters.nameValue?has_content && parameters.nameValue?split("-")?size > 1 && parameters.nameValue?split("-")?size < 5]
    [#assign tmpPlan = (action.getPlan(parameters.nameValue))! /]
    [#if tmpPlan?has_content]
        [#assign planPickerDataAttributes = planPickerDataAttributes + {
        "field-text": tmpPlan.name
        } /]
    [/#if]
[/#if]

${tag.addParameter("dataAttributes", planPickerDataAttributes) }
${tag.addParameter("autocomplete", "off") }

<div class="aui-select2-item">
    [#include "/${parameters.templateDir}/simple/text.ftl" /]

    <script>
        (function ($) {
            new Bamboo.Feature.BuildAutocomplete({
                el: $('#${parameters.id}')

                [#if parameters.loadAndProcess?? && parameters.loadAndProcess?is_boolean]
                    ,loadAndProcess: ${parameters.loadAndProcess?string("true", "false")}
                [/#if]

                [#if parameters.masterPlanPickerId?has_content]
                    ,masterPickerId: '${parameters.masterPlanPickerId}'
                [/#if]

                [#if parameters.allowClear?? && parameters.allowClear?is_boolean]
                    ,allowClear: ${parameters.allowClear?string("true", "false")}
                [/#if]

                [#if parameters.placeHolder?has_content]
                    ,placeholder: '[@ww.text name=parameters.placeHolder /]'
                [/#if]

                [#if parameters.initialValue?has_content]
                    ,initialValue: '${parameters.initialValue}'
                [/#if]

                ,params: {
                    [#if parameters.deploymentProjectId?has_content]
                        deploymentProjectId: "${parameters.deploymentProjectId}"
                    [/#if]

                    [#if parameters.masterPlanKey?has_content]
                        ,planKey: "${parameters.masterPlanKey}"
                    [/#if]
                }
            });
        }(AJS.$));
    </script>

    [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
</div>