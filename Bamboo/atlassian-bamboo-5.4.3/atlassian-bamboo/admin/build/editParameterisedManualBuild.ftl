[#-- @ftlvariable name="action" type="com.atlassian.bamboo.v2.ww2.build.ParameterisedManualBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.v2.ww2.build.ParameterisedManualBuild" --]
[#import "/fragments/variable/variables.ftl" as variables/]
[#assign overridableVars = action.getOverridableVariablesDropdownJson().get(variablesKey).toString() /]

[@ww.form action=runAction namespace="/ajax" submitLabelKey="global.buttons.run" cssClass="custom-build"]

    [@ww.hidden name='planKey' /]
    [@ww.hidden name='buildNumber' /]

    [#if !continuable]
        [@ww.textfield labelKey='build.editParameterisedManualBuild.revision' name='customRevision' placeholderKey='build.editParameterisedManualBuild.revision.placeholder' /]
    [/#if]

    [#if showPushOverrideOption]
        [@ww.checkbox labelKey='build.editParameterisedManualBuild.branchMergePushOverride' name='branchMergePushOverride' /]
    [/#if]

    [#if action.overridableVariables?has_content]
        [@displayFieldGroup labelKey='Build Variables']
            ${soy.render("bamboo.feature.variables.variablesTable", {
                "showOverrideFooter": true,
                "hideAddHeader": true,
                "inlineEdit": false,
                "availableVariables": overridableVars,
                "firstAvailableVariable": overridableVariables.iterator().next()
            })}
            <script type="text/javascript">
                BAMBOO.VARIABLES.VariablesTable({
                    selectors: {
                        table: '#${runAction} .variables-list'
                    },
                    templates: {
                        row: 'variable-row-template'
                    },
                    availableVariables: ${overridableVars}
                });
            </script>
        [/@displayFieldGroup]
    [/#if]

    [#if action.planHasManualStages()]
        [#if stageToContinue?has_content]
            [@displayRemainingStages resultSummary stageToContinue /]
        [#else]
            [@displayStages /]
        [/#if]
    [/#if]
[/@ww.form]

<script type="text/x-template" title="variable-row-template">[#rt]
[#assign variableSnippet][@variables.variablesTableRow id='VARIABLE_ID' key='VARIABLE_KEY' value='VARIABLE_VALUE' overriddenVariablesMap=action.overriddenVariablesMap availableVariables=action.overridableVariables readonly=true /][/#assign][#t]
${variableSnippet?replace("VARIABLE_ID", "{id}")?replace("VARIABLE_KEY", "{key}")?replace("VARIABLE_VALUE", "{value}")?replace("value_{id}", "{id}")}[#t]
</script>[#lt]

[#macro displayStages]
    [@displayFieldGroup labelKey='Stages']
    <fieldset id="stageContainer" class="group">
        [#assign manualStageFound=false/]
        [#list immutablePlan.stages as stage]
            [#if stage.manual][#assign manualStageFound=true/][/#if]
            <div class="checkbox[#if stage.manual] manual[/#if][#if !manualStageFound] selected[/#if]">
               <input type="checkbox" name="selectedStages" value="${stage.name}" id="stage-${stage_index}" class="checkbox"[#if !stage.manual] disabled="disabled"[/#if] />
               <label for="stage-${stage_index}">${stage.name}</label>
            </div>
        [/#list]
        [@ww.hidden id='selectedStage' name='selectedStage'/]
    </fieldset>
    <div class="description">[@ww.text name='build.editParemeterisedManualBuild.description.stages' /]</div>
    [/@displayFieldGroup]
    <script type="text/javascript">
        BAMBOO.STAGES.manualStagesSelection.init();
    </script>
[/#macro]

[#macro displayRemainingStages resultSummary stageToContinue]
    [#assign manualStageFound=false/]
    [#list resultSummary.stageResults as stage]
        [#if !stage.finished && stage.manual && !stage.name.equals(stageToContinue)]
            [#assign manualStageFound=true/]
        [/#if]
    [/#list]
    [#if manualStageFound]
        [@displayFieldGroup labelKey='Stages']
            <fieldset id="stageContainer" class="group">
                [#assign startingStageFound=false]
                [#assign manualStageFound=false/]
                [#list resultSummary.stageResults as stage]
                    [#if !stage.finished]
                        [#assign atStartingStage=false]
                        [#if stage.name.equals(stageToContinue)]
                            [#assign atStartingStage=true]
                        [/#if]
                        [#if stage.manual && !atStartingStage][#assign manualStageFound=true/][/#if]
                        <div class="checkbox[#if stage.manual && !atStartingStage] manual[/#if][#if atStartingStage || !manualStageFound] selected[/#if]">
                            <input type="checkbox" name="selectedStages" value="${stage.name}" id="stage-${stage_index}" class="checkbox"[#if !stage.manual || atStartingStage] disabled="disabled"[/#if] />
                            <label for="stage-${stage_index}">${stage.name}</label>
                        </div>
                    [/#if]
                [/#list]
            </fieldset>
            <div class="description">[@ww.text name='build.editParemeterisedManualBuild.description.stages' /]</div>
        [/@displayFieldGroup]
    [/#if]
    [@ww.hidden id='selectedStage' name='selectedStage'/]
    <script type="text/javascript">
        BAMBOO.STAGES.manualStagesSelection.init();
    </script>
[/#macro]

[#macro displayFieldGroup labelKey='']
    <fieldset class="group">
        [#if labelKey?has_content]
            <legend><span>[@ww.text name=labelKey /]</span></legend>
        [/#if]
        <div class="field-group">
            [#nested /]
        </div>
    </fieldset>
[/#macro]