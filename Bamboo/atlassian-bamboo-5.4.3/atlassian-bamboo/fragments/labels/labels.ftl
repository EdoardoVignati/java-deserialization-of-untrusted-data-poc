[#-- @ftlvariable name="plan" type="com.atlassian.bamboo.plan.Plan" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]


[#macro showLabelEditorForPlan plan]
    [#if fn.hasPlanPermissionForKey('READ', plan.key)]
        [@showLabelsWithNone plan=plan showRemove=false id="plan-labels" /]
    [/#if]
[/#macro]

[#macro showLabelEditorForBuild plan resultsSummary='']
    <dt><a href="${req.contextPath}/browse/${plan.key}/label">[@ww.text name='labels.title' /]</a></dt>
    <dd>
        [@showLabelsWithNone plan=plan resultsSummary=resultsSummary showRemove=false /]
        [@showEditLabel plan resultsSummary /]
    </dd>
[/#macro]


[#macro showEditLabel plan resultsSummary='' showIcon=true withShortcut=true]
    [#if user?? && fn.hasPlanPermission('READ', plan)]
        [@ww.url id="editLabelUrl" action='editLabels' namespace='/build/label/ajax']
            [#if resultsSummary?has_content]
                [@ww.param name='buildNumber']${resultsSummary.buildNumber}[/@ww.param]
            [/#if]
            [@ww.param name='buildKey']${plan.key}[/@ww.param]
        [/@ww.url]
        <a href="${editLabelUrl}" class="labels-edit[#if !showIcon] assistive[/#if]" title="[@ww.text name='labels.buttons.edit' /]">
            [@ui.icon type="edit" useIconFont=true textKey="labels.buttons.edit" showTitle=false /]
        </a>
        <script type="text/javascript">
            new BAMBOO.LABELS.LabelDialog({
                labelsDialog: {
                    header: "[@ww.text name='labels.title' /]",[#if !withShortcut]
                    shortcutKey: null[/#if]
                },
                removeUrl: '${req.contextPath}/build/label/ajax/deleteLabel.action?buildKey=${plan.key}[#if buildNumber?has_content]&buildNumber=${resultsSummary.buildNumber}[/#if]'
            });
        </script>
    [/#if]
[/#macro]

[#macro showLabels labels plan='' resultsSummary='' includeLinks=true showRemove=true id='']
    <span class="label-list"[#if id?has_content] id="${id}"[/#if]>[#rt]
        [#list labels as label][#t]
            [#t]${soy.render("aui.labels.label", {
                "text": label,
                "id": "label-" + label,
                "url": includeLinks?string("${req.contextPath}/browse/label/${label?url}", ""),
                "isCloseable": (showRemove && plan?has_content && fn.hasPlanPermission('WRITE', plan.key)),
                "extraAttributes": { "data-label": label }
            })}[#t]
        [/#list]
    </span>[#lt]
[/#macro]

[#macro showLabelsWithNone plan resultsSummary='' includeLinks=true showRemove=true id='']
    [#if resultsSummary?has_content && buildNumber?has_content]
        [#assign labels = resultsSummary.labelNames!/]
    [#else]
        [#assign labels = plan.labelNames!/]
    [/#if]

    [#if labels?has_content]
        [@showLabels labels=labels plan=plan resultsSummary=resultsSummary! includeLinks=includeLinks showRemove=showRemove id=id/]
    [#else]
        <span class="label-none"[#if id?has_content] id="${id}"[/#if]>[@ww.text name='labels.none' /]</span>
    [/#if]
[/#macro]
