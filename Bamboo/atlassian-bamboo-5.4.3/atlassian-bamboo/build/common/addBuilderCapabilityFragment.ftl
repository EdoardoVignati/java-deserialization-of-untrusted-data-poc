[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.AddSharedLocalCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.AddSharedLocalCapability" --]
[@ww.form action="addSharedBuilderCapability" namespace="/ajax"
        descriptionKey='builder.inline.addCapability.description'
        cancelUri=returnUrl]

    [#assign filteredBuilders=capabilityHelper.getFilteredBuildersFromTypeString(capabilityType, builderKey) /]
    [#if filteredBuilders?size == 0]
        [@ui.messageBox type="warning" ]
            [@ww.text name="agent.capability.type.builder.notABuilder"]
                [@ww.param]${builderKey}[/@ww.param]
            [/@ww.text]
        [/@ui.messageBox]
    [#else]
        [@ww.param name='submitLabelKey']${action.getText('global.buttons.add')}[/@ww.param]

        [#if filteredBuilders?size > 1]
            [@ww.select id="executableTypeSelect" labelKey='builders.form.typeLabel' name='builderType' list=filteredBuilders listKey='key' listValue='name'
            optionTitle='pathHelp'
            descriptionKey='builders.form.type.description' /]

            [@ww.textfield labelKey='agent.capability.type.builder.key' name='builderLabel' /]
            [@ww.textfield labelKey='agent.capability.type.builder.value' name='builderPath' cssClass="builderPath"/]

            <script type="text/javascript">
                AJS.$(function($) {
                    $("#executableTypeSelect").change( function() {
                          var $select = $(this);
                          $(".builderPath ~ .description").html($select.find("option:selected").attr("title"));
                    }).change();
                });
            </script>
        [#elseif filteredBuilders?size == 1]
            [#assign builder=filteredBuilders.iterator().next() /]
            [@ww.label labelKey='builders.form.typeLabel' value=builder.name /]
            [@ww.hidden name='builderType' value=builder.key /]

            [@ww.textfield labelKey='agent.capability.type.builder.key' name='builderLabel' /]
            [@ww.textfield labelKey='agent.capability.type.builder.value' name='builderPath' descriptionKey=(builder.pathHelp)! /]
        [/#if]
    [/#if]


    [@ww.hidden name='capabilityType' value='builder' /]
    [@ww.hidden name='builderKey' value=builderKey /]
    [@ww.hidden name='returnUrl' /]

[/@ww.form]