[#-- @ftlvariable name="variablesList" type="java.util.List<com.atlassian.bamboo.variable.VariableDefinition>" --]
[#-- @ftlvariable name="availableVariables" type="java.util.List<com.atlassian.bamboo.variable.VariableDefinition>" --]

[#macro configureVariables id variablesList createVariableUrl deleteVariableUrl updateVariableUrl overriddenVariablesMap tableId availableVariables=[] globalNotOverriddenVariables=[]]
    [#if createVariableUrl?starts_with(req.contextPath)]
        [#assign createVariableAction = createVariableUrl?replace(req.contextPath, '', 'f') /]
    [#else ]
        [#assign createVariableAction = createVariableUrl /]
    [/#if]
    <div class="variables-hint">[@ww.text name="plan.variables.passwordMask.hint"/]</div>
    [@ww.form id=id name=id action=createVariableAction]
        [@configureVariablesTable variablesList=variablesList deleteVariableUrl=deleteVariableUrl availableVariables=availableVariables overriddenVariablesMap=overriddenVariablesMap globalNotOverriddenVariables=globalNotOverriddenVariables tableId=tableId/]
    [/@ww.form]
    <script type="text/javascript">
        BAMBOO.VARIABLES.VariablesConfigurationForm({
            selectors: {
                form: "#${id?js_string}"
            },
            updateVariableUrl: "${updateVariableUrl?js_string}",
            overriddenVariablesMap: ${action.toJson(overriddenVariablesMap)},
            globalNotOverriddenVariables: ${action.toJson(globalNotOverriddenVariables)}
        });
    </script>
[/#macro]

[#macro configureVariablesTable variablesList overriddenVariablesMap tableId deleteVariableUrl='' availableVariables=[] globalNotOverriddenVariables=[] hideHeadings=false ]
<table id="${tableId}" class="aui variables-list">
    <colgroup>
        <col width="44%"/>
        <col width="44%"/>
        <col />
    </colgroup>
    <thead[#if hideHeadings] class="assistive"[/#if]>
    <tr>
        <th>[@ww.text name='global.heading.variable.name' /]</th>
        <th>[@ww.text name='global.heading.value' /]</th>
        <th class="operations"><span class="assistive">[@ww.text name='global.heading.operations' /]</span></th>
    </tr>
    </thead>
    <tbody>
    <tr class="add-variable">
        <td>
            [#if availableVariables?has_content]
                [@ww.select name="variableKey" theme="simple" cssClass="inline-edit-field select" list=availableVariables listKey='key' listValue='key' groupBy='getVariableType().toString().toLowerCase()' i18nPrefixForGroup='variables.groupby' dataAttributeName='current-value' dataAttribute='getValue()' /]
                [#assign firstAvailableVariableCurrentValue = (availableVariables?first.value)!"" /]
            [#elseif globalNotOverriddenVariables?has_content]
                [@ww.textfield name="variableKey" id="variableKey" placeholderKey="plan.variables.name.placeholder" cssClass="long-field" theme="simple" /]
                <script>
                    new BAMBOO.VariableSingleSelect({
                        el: '#variableKey',
                        bootstrap: ${action.toJson(globalNotOverriddenVariables)}
                    });
                </script>
            [#else]
                [@ww.textfield name="variableKey" id="variableKey" cssClass="inline-edit-field text long-field" autocomplete="off" theme="simple" /]
            [/#if]
            [#if (fieldErrors["variableKey"])?has_content]
                [#list fieldErrors["variableKey"] as error]
                    <div class="error">${error?html}</div>
                [/#list]
            [/#if]
        </td>
        <td>
            <div class="variable-value input-password">
                [@ww.textfield name="variableValue" cssClass="inline-edit-field text" autocomplete="off" theme="simple" value=(firstAvailableVariableCurrentValue)!"" /]
                <button name="hide" type="button" class="aui-button hidden" aria-pressed="true">[@ww.text name='global.buttons.hide' /]</button>
            </div>
            <div class="variable-value-password input-password hidden">
                [@ww.password name="variableValue_password" cssClass="inline-edit-field text" autocomplete="off" theme="simple" /]
                <button name="show" type="button" class="aui-button">[@ww.text name='global.buttons.show' /]</button>
            </div>
            [#if (fieldErrors["variableValue"])?has_content]
                [#list fieldErrors["variableValue"] as error]
                    <div class="error">${error?html}</div>
                [/#list]
            [/#if]
        </td>
        <td class="operations">[@ww.submit value=action.getText("global.buttons.add") /]</td>
    </tr>
        [#list variablesList as variable]
            [@variablesTableRow id=variable.id key=variable.key value=variable.value!"" deleteVariableUrl=deleteVariableUrl availableVariables=availableVariables overriddenVariablesMap=overriddenVariablesMap /]
        [/#list]
    </tbody>
</table>
[/#macro]

[#macro variablesTableRow id key value overriddenVariablesMap deleteVariableUrl='' availableVariables=[] readonly=false ]
<tr id="tr_variable_${id}">
    <td class="variable-key">
        [#if availableVariables?has_content]
            [@dj.inPlaceEditSelect id="key_${id}" value=key readonly=readonly availableVariables=availableVariables readonly=readonly /]
        [#else]
            [@dj.inPlaceEditTextField id="key_${id}" value=key longfield=true /]
        [/#if]
    </td>
    <td class="variable-value-container" data-variable-key="${key}">
        <span class="inline-edit-view"[#if !readonly] tabindex="0"[/#if] id="${id}">${value?html}</span>
        [#if readonly]
            [@ww.hidden name="value_${id}" theme="simple" value=value /]
        [#else]
            <div class="variable-value input-password">
                [@ww.textfield id="value_${id}" name="value_${id}" theme="simple" cssClass="inline-edit-field text long-field" autocomplete="off" value=value /]
                <button name="hide" type="button" class="aui-button hidden" aria-pressed="true">[@ww.text name='global.buttons.hide' /]</button>
            </div>
            <div class="variable-value-password input-password hidden">
                [@ww.password id="value_password_${id}" name="value_${id}" cssClass="inline-edit-field text" autocomplete="off" theme="simple" /]
                <button name="show" type="button" class="aui-button">[@ww.text name='global.buttons.show' /]</button>
            </div>
        [/#if]
        [#assign variable = overriddenVariablesMap[key]!""]
        <small><div id="override_field_${id}">
            ${soy.render ('bamboo.feature.variables.overrideText', {
            "variable": variable
            })}
        </div></small>
    </td>
    <td class="operations">
        <a id="deleteVariable_${id}" class="delete-variable mutative"[#if deleteVariableUrl?has_content] href="${deleteVariableUrl?replace('VARIABLE_ID', id)}"[/#if] title="[@ww.text name='global.buttons.delete'/]" tabindex="-1"  data-variable-key="${key?html}">[@ui.icon type="remove" textKey="global.buttons.delete" useIconFont=true /]</a>
        <button name="update" type="button" class="aui-button hidden" tabindex="-1">[@ww.text name='global.buttons.update' /]</button>
        <a class="cancel-variable hidden" tabindex="-1" >[@ww.text name='global.buttons.cancel' /]</a>
    </td>
</tr>
[/#macro]

[#macro displayDefinedVariables id variablesList]
<table class="aui" id="${id}">
    <colgroup>
        <col width="33%"/>
        <col width="67%"/>
    </colgroup>
    <thead>
    <tr>
        <th>[@ww.text name='buildResult.variables.name' /]</th>
        <th>[@ww.text name='buildResult.metadata.value' /]</th>
    </tr>
    </thead>
    <tbody>
        [#list variablesList as entry]
        <tr>
            <td>${entry.key?html}</td>
            <td>${entry.value!""?html}</td>
        </tr>
        [/#list]
    </tbody>
</table>
[/#macro]

[#macro displaySubstitutedVariables id variablesList]
<table class="aui" id="${id}">
    <colgroup>
        <col width="33%"/>
        <col width="67%"/>
    </colgroup>
    <thead>
    <tr>
        <th>[@ww.text name='buildResult.variables.name' /]</th>
        <th>[@ww.text name='buildResult.metadata.value' /]</th>
    </tr>
    </thead>
    <tbody>
        [#list variablesList as entry]
        <tr[#if entry.variableType == "MANUAL"] class="overridden"[/#if]>
            <td>${entry.key?html}</td>
            <td>[#if entry.variableType == "MANUAL"]
            <kbd>[/#if]${entry.value!""?html}[#if entry.variableType == "MANUAL"]</kbd>
                <span>[@ww.text name="build.editParameterisedManualBuild.overridden" /]</span>[/#if]</td>
        </tr>
        [/#list]
    </tbody>
</table>
[/#macro]

[#macro displayManualVariables id variablesList]
<div class="variables-container">
    <table>
        <thead class="assistive">
        <tr>
            <th scope="col" class="name">[@ww.text name='buildResult.variables.name' /]</th>
            <th scope="col" class="value">[@ww.text name='buildResult.metadata.value' /]</th>
        </tr>
        </thead>
        <tbody>
            [#list variablesList as entry]
            <tr>
                <td class="name">${entry.key?html}</td>
                <td class="value">[#rt]
                    [#if entry.key?lower_case?contains("password")]
                        ******[#t]
                    [#else]
                    ${entry.value!""?html}[#t]
                    [/#if]
                </td>
            </tr>
            [/#list]
        </tbody>
    </table>
</div>
[/#macro]
