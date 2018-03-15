[#if fn.hasAdminPermission()]
    <script type="text/javascript">
        function addSharedBuilderCapabilitySubmitCallback(result) {
            // add in the select list element
            var $selectBuilderElement = AJS.$("#selectedBuilderKey");
            $selectBuilderElement.append(AJS.$("<option />", { text: result.capability.label, selected: "selected", val: result.capability.label }).addClass("uiSwitch" + result.builderType))
                                 .val(result.capability.label);

            // trigger the show/hide stuff
            $selectBuilderElement.change();
        }
    </script>

    [@dj.simpleDialogForm
        triggerSelector=".addSharedBuilderCapability"
        width=540 height=310
        submitCallback="addSharedBuilderCapabilitySubmitCallback"
    /]
[/#if]

[#assign addBuilderLink]
[#if fn.hasGlobalAdminPermission()]
    <a class="addSharedBuilderCapability" title="${action.getText('builders.form.inline.heading')}" href="[@ww.url value='/ajax/configureSharedBuilderCapability.action' returnUrl=currentUrl /]">[@ww.text name='builders.form.inline.heading' /]</a>
[/#if]
[/#assign]

[@ww.select labelKey='builder.type' name='selectedBuilderKey' id="selectedBuilderKey" toggle='true'
            listKey='key' listValue='key'
            uiSwitch='value'
            list=uiConfigBean.legacyBuilderLabelTypeMap
            extraUtility=addBuilderLink]
[/@ww.select]
[#list uiConfigBean.builderTypes as builderType]
    [@ui.bambooSection dependsOn='selectedBuilderKey' showOn='${builderType.key}']
        ${action.getEditHtml(builderType)}
    [/@ui.bambooSection]
[/#list]