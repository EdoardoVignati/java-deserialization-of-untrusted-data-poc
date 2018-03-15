[@ww.select name='capabilityType' labelKey='agent.capability.type' list=capabilityTypes listKey='capabilityTypeKey' listValue='capabilityTypeLabel' toggle=true/]

[#list capabilityTypes as capabilityType]
    [#if capabilityType.capabilityTypeKey == 'custom']
        [@ui.bambooSection  dependsOn='capabilityType' showOn='custom']
            [@ww.textfield labelKey='agent.capability.key' name='capabilityKey' /]
            [@ww.textfield labelKey='agent.capability.value' name='capabilityValue' /]
        [/@ui.bambooSection]
    [#elseif  capabilityType.capabilityTypeKey == 'jdk']
        [@ui.bambooSection  dependsOn='capabilityType' showOn='jdk']
            [@ww.textfield labelKey='agent.capability.type.jdk.key' name='jdkLabel' /]
            [@ww.textfield labelKey='agent.capability.type.jdk.value' name='jdkPath' /]
        [/@ui.bambooSection]
    [#elseif capabilityType.capabilityTypeKey == 'builder']
        [#assign configurableBuilders = "" ]
        [#list capabilityType.getBuilderTypes() as builderType]
            [#assign configurableBuilders = configurableBuilders + builderType.key + " "]
        [/#list]
        [@ui.bambooSection  dependsOn='capabilityType' showOn='builder']
            [@ww.select id="executableTypeSelect" labelKey='builders.form.typeLabel' name='builderType' list=capabilityType.getBuilderTypes() listKey='key' listValue='name'
                        optionTitle='pathHelp'
                        toggle=true/]
            [@ui.bambooSection  dependsOn='builderType' showOn=configurableBuilders]
                [@ww.textfield labelKey='agent.capability.type.builder.key' name='builderLabel' /]
                [@ww.textfield labelKey='agent.capability.type.builder.value' name='builderPath' cssClass="builderPath" /]

                <script type="text/javascript">
                    AJS.$(function($) {
                         $("#executableTypeSelect").change(function() {
                                var $select = $(this);
                                $(".builderPath ~ .description").html($select.find("option:selected").attr("title"));
                         }).change();
                     });
                </script>
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [#elseif capabilityType.capabilityTypeKey == 'perforce']
        [@ui.bambooSection  dependsOn='capabilityType' showOn='perforce']
            [@ww.textfield labelKey='agent.capability.type.perforce.value' name='p4Executable' /]
        [/@ui.bambooSection]
    [#else]
        [@ui.bambooSection  dependsOn='capabilityType' showOn=capabilityType.capabilityTypeKey]
            ${capabilityType.editHtml}
        [/@ui.bambooSection]
    [/#if]

[/#list]
