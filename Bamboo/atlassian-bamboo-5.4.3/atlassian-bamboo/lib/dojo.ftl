[#-- This file is wrapper for using javascript widgets --]
[#-- =================================================================================================== @dj.tooltip --]
[#macro tooltip target text='' showDelay=500 width=300 addMarker=false url='']
    [#if text?has_content]
        [#local tooltipText = text]
    [#else]
        [#local tooltipText]
            [#nested /][#t]
        [/#local]
        [#local tooltipText = tooltipText?trim]
    [/#if]
    [#if tooltipText?has_content || url?has_content]
        <script>
            new BAMBOO.Tooltip('#${target}', {
                addMarker: ${addMarker?string},
                showDelay: ${showDelay},
                width: ${width}[#if tooltipText?has_content],
                content: '${tooltipText?js_string}'[/#if][#if url?has_content],
                url: '${url?js_string}'[/#if]
            });
        </script>
    [/#if]
[/#macro]


[#-- ============================================================================================== @dj.tabContainer --]
[#macro tabContainer headings=[] headingKeys=[] selectedTab='' tabViewId='tabContainer']
[#if action?? && action.cookieCutter?? && selectedTab == '']
    [#local selected=action.cookieCutter.getValueFromConglomerateCookie('AJS.conglomerate.cookie', 'tabContainer.' + tabViewId + '.selectedTab')!'' /]
[#else]
    [#local selected=selectedTab /]
[/#if]

[#if headingKeys?has_content]
    [#local resolvedHeadings=[]/]
    [#list headingKeys as headingKey]
        [#local header][@ww.text name=headingKey /][/#local]
        [#local resolvedHeadings = resolvedHeadings + [header] /]
    [/#list]
[#else]
    [#local resolvedHeadings = headings/]
[/#if]

<div id="${tabViewId}" class="aui-tabs horizontal-tabs">
    <ul class="tabs-menu">
        [#list resolvedHeadings as heading]
            <li class="menu-item [#if selected == heading] active-tab[/#if]">
                 <a href="#${heading?replace(' ', '')}" data-heading="${heading}"><strong>${heading}</strong></a>
            </li>

            [#if heading == selected]
                [#local selectedIndex = heading_index /]
            [/#if]
        [/#list]
    </ul>
    [#nested /]
</div>

[#local tabToSelectSelector][#if !selectedIndex??].menu-item:first-child[#else].active-tab[/#if][/#local]
<script type="text/javascript">
    AJS.$(function ($) {
        var $tabToSelect = $('#${tabViewId}').find('> .tabs-menu > ${tabToSelectSelector} > a'),
            tabEvents = $tabToSelect.data('events');

        // check if AUI tabs events have been attached
        if (!tabEvents || !tabEvents.click) {
            AJS.tabs.setup($);
        }

        $("#${tabViewId} > .tabs-menu > .menu-item > a").click(function() {
            AJS.Cookie.save("tabContainer.${tabViewId}.selectedTab", $(this).attr("data-heading"),365);
        });

        $tabToSelect.click();
    });
</script>
[/#macro]

[#-- ============================================================================================== @dj.contentPane --]
[#macro contentPane labelKey='' id='']
[#if id?has_content]
    [#local contentPaneId=id/]
[#elseif labelKey?has_content]
    [#local contentPaneId=(action.getText(labelKey))?replace(" ", "")/]
[/#if]

<div [#if contentPaneId?has_content]id="${contentPaneId}"[/#if] class="tabs-pane">
    [#nested /]
</div>
[/#macro]

[#-- ============================================================================================== @dj.reloadPortlet --]
[#macro reloadPortlet id url reloadEvery loadScripts=true callback='null']
    <div id="${id}">
        [#nested /]
    </div>
    [#if reloadEvery > 0]
    <script type="text/javascript">
        AJS.$(function() {
            var timeout,
                panelId = '${id?js_string}';
            if (typeof BAMBOO.panelTimeouts === "undefined") {
                BAMBOO.panelTimeouts = {};
            } else {
                timeout = BAMBOO.panelTimeouts[panelId];
                clearTimeout(timeout);
            }
            BAMBOO.panelTimeouts[panelId] = setTimeout(function () { reloadPanel(panelId, '${url}', ${reloadEvery}, ${loadScripts?string}, null, ${callback?string}); }, ${reloadEvery} * 1000);
        });
    </script>
    [/#if]
[/#macro]

[#-- ========================================================================================== @dj.simpleDialogForm --]
[#--
     @param triggerSelector  jQuery selector of elements which will be bound to show dialog during onClick event
     @param actionUrl        url which will return HTML of the form to be embedded into dialog
     @param width            width of the dialog
     @param height           height of the dialog
     @param submitLabelKey   i18n key of the label to be used for submit button
     @param submitMode       if set to "ajax" then form will be submitted using AJAX call
     @param submitCallback   callback to be called after submitting in AJAX mode (if set will enforce ajax mode)
--]
[#macro simpleDialogForm triggerSelector actionUrl="" width=800 height=400 submitLabelKey="global.buttons.create" submitMode="" submitCallback="null" cancelCallback="null" header="" headerKey="" help="" helpKey=""]

    [#if submitCallback != "null"]
        [#local submitMode = "ajax" /]
    [/#if]
    [#if header?has_content || headerKey?has_content]
        [#local resolvedHeaderText = fn.resolveName(header, headerKey) /]
    [/#if]
    [#if help?has_content || helpKey?has_content]
        [#local resolvedHelpText = fn.resolveName(help, helpKey) /]
    [/#if]

    <script type="text/javascript">
        [#if actionUrl?has_content]
            AJS.$(function() {
                simpleDialogForm(
                        '${triggerSelector}', '${req.contextPath}${actionUrl}',
                        ${width}, ${height},
                        '[@ww.text name=submitLabelKey /]', '${submitMode}', ${submitCallback?string},
                        null,
                        [#if resolvedHeaderText??]'${resolvedHeaderText?js_string}'[#else ]null[/#if]);
            });
        [#else]
            BAMBOO.simpleDialogForm({
                trigger: '${triggerSelector}',
                dialogWidth: ${width},
                dialogHeight: ${height},
                success: ${submitCallback?string},
                cancel: ${cancelCallback?string}[#if resolvedHeaderText??],
                header: "${resolvedHeaderText?js_string}"[/#if][#if resolvedHelpText??],
                help: "${resolvedHelpText?js_string}"[/#if]
            });
        [/#if]
    </script>

[/#macro]

[#-- ============================================================================================== @dj.imageReload --]
[#--
     @param target (required)               id of the image
     @param reload element class            class of the reload element
     @param titleKey                        i18n key for the title of the element
--]
[#macro imageReload target reloadElementClass="image-reload" titleKey="image.reload"]
<script type="text/javascript">
    jQuery(function(){
        jQuery("#" + "${target?js_string}").reloadImage({ text: "[@ww.text name=titleKey /]", cssClass: "${reloadElementClass?js_string}"});
    });
</script>
[/#macro]

[#-- =============================================================================================== @dj.progressBar --]
[#--
    @param id (required)    id to give the progress bar
    @param value            initial percentage complete as an integer (0-100)
    @param text             text to show in the progress bar
--]
[#macro progressBar id value=0 text="" cssClass=""]
[#if value lt 0]
    [#local progressBarValue = 0]
[#elseif value gt 100]
    [#local progressBarValue = 100]
[#else]
    [#local progressBarValue = value]
[/#if]
<div id="${id}" class="progress[#if cssClass?has_content] ${cssClass}[/#if]">
    <div class="progress-bar" style="width: ${progressBarValue}%;"></div>
    <div class="progress-text">${text}</div>
</div>
<script type="text/javascript">
    AJS.$("#${id}").progressBar();
</script>
[/#macro]

[#-- ============================================================================================== @dj.cronBuilder --]
[#-- Adds a cron builder to the target field.
    @param name (required):  Name of the webwork variable that contains the cron expression. Cron expression
                                     will be read and saved to this variable.
    @param idPrefix (optional): Must be unique on the page.
    @param helpKey (optional): Key for a help bubble.
--]
[#macro cronBuilder name idPrefix="" helpKey=""]
    [#local hiddenFieldId=idPrefix + "cronExpressionTarget" /]
    [#local displayFieldId=idPrefix + "cronExpressionDisplay" /]

    [@ww.hidden id=hiddenFieldId name=name/]
    [@ww.label id=displayFieldId labelKey='cronEditorBean.label' name=name helpKey=helpKey showDescription=true required=true/]

    <script type="text/javascript">
        AJS.$("#${displayFieldId}").cronBuilder({
             hiddenFieldSelector: "#${hiddenFieldId}",
             dialogTrigger: '<a id="${idPrefix}cronBuilder" class="cron-builder">[@ui.icon type="edit" textKey="cronEditorBean.title"/]</a>',
             eventNamespace: "${idPrefix}cronEditorDialogEvent",
             contextPath: "${req.contextPath}",
             dialogSubmitButtonText: "[@ww.text name='global.buttons.done' /]",
             dialogHeadingText: "[@ww.text name='cronEditorBean.title'/]"
        });
    </script>
[/#macro]

[#macro cronDisplay name idPrefix="" ]
    [@ww.label id="${idPrefix}cronExpression" labelKey="cronEditorBean.label" name=name showDescription=true/]
    <script>
        AJS.$("#${idPrefix}cronExpression").cronDisplay("${req.contextPath}");
    </script>
[/#macro]

[#-- defines a JavaScript variable with name and content copied from action parameter, HTML escaped --]
[#macro defineJsVariableFromActionParam parameterName]
    [#local jsVariableIndex=(jsVariableIndex!-1)+1/]

    <span id="action_param_${jsVariableIndex}" class="hidden">${parameterName?eval?html}</span>

    <script type="text/javascript">
        var ${parameterName} = AJS.$("#action_param_${jsVariableIndex}").text();
    </script>
[/#macro]

[#-- ====================================================================================== @dj.inPlaceEditTextField --]
[#-- Create in-place edit (textfield) control.
     @param id (required):            Suffix of id used for control
     @param value (required):         Initial value to display
--]
[#macro inPlaceEditTextField id value readonly=false longfield=true]
    <span class="inline-edit-view"[#if !readonly] tabindex="0"[/#if] id="${id}">${value?html}</span>
    [#if readonly]
        [@ww.hidden name=id theme="simple" value=value /]
    [#else]
        [#if longfield]
            [@ww.textfield name=id theme="simple" cssClass="inline-edit-field text long-field" autocomplete="off" value=value /]
        [#else]
            [@ww.textfield name=id theme="simple" cssClass="inline-edit-field text" autocomplete="off" value=value /]
        [/#if]
    [/#if]
[/#macro]

[#-- ========================================================================================= @dj.inPlaceEditSelect --]
[#-- Create in-place edit (select) control.
     @param id (required):                  Suffix of id used for control
     @param value (required):               Initial value to display
     @param availableVariables (required):  List of variables to choose from
--]
[#macro inPlaceEditSelect id value availableVariables readonly=false]
<span class="inline-edit-view"[#if !readonly] tabindex="0"[/#if] id="${id}">${value?html}</span>
    [#if readonly]
        [@ww.hidden name=id theme="simple" value=value /]
    [#else]
        [@ww.select name=id theme="simple" cssClass="inline-edit-field select" value="'${value}'" list=availableVariables listKey='key' listValue='key' groupBy='getVariableType().toString().toLowerCase()' i18nPrefixForGroup='variables.groupby' /]
    [/#if]
[/#macro]