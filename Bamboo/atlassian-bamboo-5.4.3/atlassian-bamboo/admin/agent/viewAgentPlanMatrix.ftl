[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrix" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrix" --]
<html>
<head>
    <title>[@ww.text name='agent.matrix.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

[#assign matrixDescription]
    [@ww.text name='agent.matrix.description' ]
        [@ww.param][@ui.icon type="cross-agent" text="Agent cannot run plan" /][/@ww.param]
    [/@ww.text]
[/#assign]

[@ui.header pageKey='agent.matrix.heading' description="${matrixDescription}" /]
[#if selectedPlans?has_content]
<div class="agent-plan-matrix">
    <table class="aui">[#compress]
        <thead>
        <tr>
            <th></th>
            [#list agents as agent]
                <th class="agentHeading">
                [@ui.renderAgentNameAdminLink agent/]
                </th>
            [/#list]
            [#if elasticEnabled && images?has_content]
                [#list images as image]
                    <th class="agentHeading">
                        <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${image.id}">[@ui.icon type="elastic" /]${image.configurationName?html}</a>
                    </th>
                [/#list]
            [/#if]
        </tr>
        </thead>
        <tbody>
            [#list selectedPlans as plan]
            <tr>
                <th class='planHeading'>
                [@ww.url id='chainLink' value='/browse/${plan.key}'/]
                    <a title="${plan.name}" href="${chainLink}">${plan.name}</a>
                </th>
            </tr>
                [#list action.getBuildablesForPlan(plan) as build]
                <tr>
                    <th class="jobHeading">
                    [@ww.url id='editBuildConfigurationUrl' action='editBuildConfiguration' namespace='/build/admin/edit' buildKey=build.key/]
                        [#if build.type.equals("JOB")]
                        [@ww.url id='chainLink' value='/browse/${build.parent.key}'/]
                            <a title="${build.key}" href="${editBuildConfigurationUrl}">${build.buildName}</a>
                            [#else]
                                <a title="${build.key}" href="${editBuildConfigurationUrl}">${build.name}</a>
                        [/#if]
                    </th>
                    [#assign agentsForPlan = action.getAgentPlanMatrixRow(build) /]
                    [#list agents as agent]
                        <td class="checkboxCell">
                            [#assign result = agentsForPlan.get(agent.id) /]
                            [#if result.matches]
                                [@ui.icon type="tick-agent" text="Agent can run plan" /]
                            [#else]
                                [@ui.icon type="cross-agent" text="Agent cannot run plan" /]
                                [@listRejectedRequirements/]
                            [/#if]
                        </td>
                    [/#list]
                    [#if elasticEnabled]
                        [#assign imageMatrixRow = action.getImagePlanMatrixRow(build) /]
                        [#if imageMatrixRow?has_content]
                            [#list images as image]
                                <td class="checkboxCell">
                                    [#assign result = imageMatrixRow.get(image.id) /]
                                    [#if result.matches]
                                        [@ui.icon type="tick-agent" text="Elastic Image can run plan" /]
                                    [#else]
                                        [@ui.icon type="cross-agent" text="Elastic Image cannot run plan" /]
                                        [@listRejectedRequirements/]
                                    [/#if]
                                </td>
                            [/#list]
                        [/#if]
                    [/#if]
                </tr>
                [/#list]
            [/#list]
        </tbody>
    [/#compress]
    </table>
    <script type="text/javascript">
        AJS.$(function ($) {
            var createInlineDialogContent = function ($contents, trigger, showInlineDialog) {
                $contents.html($(trigger).next("div").clone().removeClass("assistive"));
                inlineDialog.refresh();
                showInlineDialog();
            },
                    inlineDialog = AJS.InlineDialog(".agent-plan-matrix .icon-cross-agent", "agent-plan-matrix-details", createInlineDialogContent, {
                        onHover: true,
                        fadeTime: 0,
                        showDelay: 0,
                        useLiveEvents: true,
                        width: 250,
                        offsetY: 0
                    });
        });
    </script>
</div>
[/#if]
</body>
</html>

[#macro listRejectedRequirements]
    [#assign rejectedRequirements = action.getDecoratedSet(result.rejectedRequirements) /]
        <div class="assistive">
        [#if result.otherRejectionReasons?has_content]
            [#if result.otherRejectionReasons.size() == 1]
                ${result.otherRejectionReasons.get(0)}
            [#else]
                <ul>
                    [#list result.otherRejectionReasons as reason]
                        <li>${result.otherRejectionReasons}</li>
                    [/#list]
                </ul>
            [/#if]
        [#else]
            <ol>
                [#list rejectedRequirements.decoratedObjects as rejected]
                    [#if rejected.customUnmetExplanation?has_content]
                        <li>${rejected.customUnmetExplanation!}</li>
                    [#else]
                        <li>${rejected.label!?html} ${rejected.matchType} ${rejected.matchValue!?html}</li>
                    [/#if]
                [/#list]
            </ol>
        [/#if]
    </div>
[/#macro]