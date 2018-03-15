[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.execution.actions.ExecuteManualDeployment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.execution.actions.ExecuteManualDeployment" --]

[#assign headerText]
    [@ww.text name="deployment.execute.title"]
        [@ww.param]${(environment.name)!''}[/@ww.param]
    [/@ww.text]
[/#assign]

<html>
<head>
    [@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='deployments.versions.howtheywork'][@ww.text name='deployments.versions.howtheywork.title'/][/@help.url]</div>
[@ui.header page=headerText headerElement='h2'/]

[#if action.hasAtLeastOneVersion()]
    [#assign cancelUrl = '${returnUrl!"/deploy/viewAllDeploymentProjects.action"}' /]
[/#if]

<script>
    (function ($) {
        new Bamboo.Feature.DeploymentRelease({
            el: $('#fieldArea_selectReleaseOption'),

            [#if preselectedVersion??]
                event: 'promote',
            [/#if]

            data: {
                [#if versionId > 0]
                    release: '${preselectedVersion.name?js_string}'
                [/#if]
            }
        });
    }(AJS.$));
</script>

[@ww.url id="createVersionUrl" action="createDeploymentVersion" namespace="/deploy" deploymentProjectId=deploymentProject.id /]
[@ww.form id="executeManualDeployment" action="executeManualDeployment" namespace="/deploy" cancelUri=cancelUrl!"" ]
    [@ww.hidden name="environmentId"/]

    [#if !action.hasActionErrors()]
        <div class="aui-group">
            <div class="aui-item aui-item-select-release">

                [#if versionId > 0]
                    <h3>[@ww.text name='deployment.execute.version'/]</h3>
                [/#if]

                <fieldset id="fieldArea_selectReleaseOption" class="group">

                [#if versionId == 0]
                    <legend>
                        <span>[@ww.text name='deployment.execute.version'/]</span>
                    </legend>
                    <div class="radio">
                        <input id="releaseTypeCreateOption"
                            name="releaseTypeOption" class="radio handleOnSelectShowHide" type="radio" value="CREATE"
                            [#if releaseTypeOption == "CREATE"]checked="checked"[/#if] autocomplete="off"
                            [#if !hasBranches && !defaultPlanHasBuildResults]disabled=disable[/#if]
                        >
                        <label for="releaseTypeCreateOption">[@ww.text name="deployment.version.create"/]</label>
                        [#if !hasBranches && !defaultPlanHasBuildResults]
                            [@ui.messageBox type="warning"]
                                [@ww.text name='deployment.version.create.empty.error']
                                    [@ww.param][@ui.planLink linkedPlan /][/@ww.param]
                                [/@ww.text]
                            [/@ui.messageBox]
                        [#else]
                            [@ui.bambooSection dependsOn='releaseTypeOption' showOn='CREATE' cssClass='field-group']
                                [#if hasBranches]
                                    [@s.textfield
                                        name='newReleaseBranchKey'
                                        id='newReleaseBranchKey'
                                        labelKey='deployment.execute.version.existing.branch'
                                        required=true
                                        masterPlanKey=masterPlanKey
                                        includeMasterBranch=true
                                        template='branchPicker'
                                    /]
                                [/#if]
                                <div id="emptyBuildResults" class="hidden">
                                    [@ui.messageBox type="warning"][@ww.text name="deployment.version.create.error"/][/@ui.messageBox]
                                </div>
                                [@s.textfield
                                    name='newReleaseBuildResult'
                                    id='newReleaseBuildResult'
                                    labelKey='deployment.version.create.choose.build.results'
                                    required=true
                                    masterPlanPickerId=hasBranches?string('newReleaseBranchKey', '')
                                    deploymentProjectId=deploymentProject.id
                                    masterPlanKey=masterPlanKey
                                    initialValue=action.toJson(selectedResult)?js_string
                                    template='buildPicker'
                                    helpDialog='deployment.version.create.choose.build.results.help'
                                    placeHolder='deployment.version.create.choose.build.results.help.placeholder'
                                    loadAndProcess=(releaseTypeOption == "PROMOTE" || !action.hasErrors())
                                /]
                                [@s.textfield
                                    name='versionName'
                                    id='versionName'
                                    required=true
                                    masterPickerId='newReleaseBuildResult'
                                    deploymentProjectId=deploymentProject.id
                                    labelKey='deployment.environment.result.version'
                                    template='releaseInput'
                                    autocomplete='off'
                                /]
                            [/@ui.bambooSection]
                        [/#if]
                    </div>
                    <div class="radio">
                        <input id="releaseTypePromoteOption" name="releaseTypeOption"
                            class="radio handleOnSelectShowHide" type="radio" value="PROMOTE"
                            [#if action.hasAtLeastOneVersion() && releaseTypeOption == "PROMOTE"]checked="checked"[/#if]
                            [#if !action.hasAtLeastOneVersion()]disabled=disable[/#if] autocomplete="off"
                        >
                        <label for="releaseTypePromoteOption">
                            [@ww.text name="deployment.version.promote"/]
                            [#if !action.hasAtLeastOneVersion()] - [@ww.text name="deployment.version.promote.error"/][/#if]
                        </label>

                        [@ui.bambooSection dependsOn='releaseTypeOption' showOn='PROMOTE' cssClass='field-group']
                            [#if hasReleasesFromBranches]
                                [@s.textfield
                                    name='promoteReleaseBranchKey'
                                    id='promoteReleaseBranchKey'
                                    labelKey='deployment.execute.version.existing.branch'
                                    required=false
                                    allowClear=true
                                    masterPlanKey=masterPlanKey
                                    includeMasterBranch=true
                                    releasedInDeployment=deploymentProject.id
                                    template='branchPicker'
                                    placeHolder='deployment.execute.version.existing.branch.placeholder'
                                /]
                            [/#if]
                            [@s.textfield
                                name='promoteVersion'
                                id='promoteVersion'
                                required=true
                                masterPickerId='promoteReleaseBranchKey'
                                labelKey='deployment.environment.result.version'
                                deploymentProjectId=deploymentProject.id
                                template='releasePicker'
                                placeHolder='deployment.environment.result.version.placeholder'
                                loadAndProcess=(releaseTypeOption == "CREATE" || !action.hasErrors())
                            /]
                        [/@ui.bambooSection]
                    </div>
                [#else]
                    [@ui.bambooSection cssClass='field-group']
                        <div class="field-group">
                            <label>[@ww.text name="deployment.execute.version.existing.branch"/]</label>
                            ${soy.render("bamboo.deployments:deployments-main",
                                "bamboo.widget.deployment.version.branch", {
                                    'planBranchName': preselectedVersion.planBranchName
                                })
                            }
                        </div>
                        [@s.label labelKey='deployment.environment.result.version' value=preselectedVersion.name/]
                        [@s.hidden name='promoteVersion' id='promoteVersion' value=preselectedVersion.name/]
                        [@s.hidden name='releaseTypeOption' id='releaseTypeOption' value="PROMOTE"/]
                    [/@ui.bambooSection]
                [/#if]
            </fieldset>
            <div id="rollbackWarning" class="hidden">
                [@ui.messageBox titleKey="deployment.version.create.rollback.warning.title" type="warning"][@ww.text name="deployment.version.create.rollback.warning"/][/@ui.messageBox]
            </div>
        </div>

        <div class="aui-item">
            <div id="new-version-preview" class="deployment-version-preview">
                <div id="new-version-details">
                    <span class="icon icon-loading"></span>
                </div>
                <div id="tasks-to-run" class="hidden">
                    ${soy.render("bamboo.deployments:view-deployment-preview", "bamboo.page.deployment.execution.tasks", {
                    'decoratedTaskDefinitions': decoratedTaskDefinitions,
                    'canEdit': environment.operations.canEdit,
                    'envId': environment.id
                    })}
                </div>
            </div>
            <script>
                AJS.$(function ($) {
                    BAMBOO.deploymentPreview.init({
                    previousVersionId: [#if (lastDeploymentResult.deploymentVersion)??]${lastDeploymentResult.deploymentVersion.id}[#else]null[/#if],
                        deploymentProjectId: ${deploymentProject.id},
                        environmentId: ${environment.id},
                        selectors: {
                            versionPreviewContainerSelector: "#new-version-details",
                            tasksDialogLinkSelector: "#tasks-to-run"
                        }
                    });
                });
            </script>
            </div>
        </div>
        [@ww.param name="buttons"]
            [@ww.submit
                value=action.getText('deployment.execute.go')
                disabled=(!action.hasAtLeastOneVersion() && !hasBranches && !defaultPlanHasBuildResults)
                primary=true
                name='save'
            /]
        [/@ww.param]
    [/#if]
[/@ww.form]

</body>
</html>