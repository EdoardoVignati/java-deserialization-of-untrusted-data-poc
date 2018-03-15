[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.CreateDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.CreateDeploymentVersion" --]

[#assign headerText]
    [@ww.text name='deployment.version.create.title']
        [@ww.param]${deploymentProject.name}[/@ww.param]
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

[@ww.form id='createDeploymentVersion' action='doCreateDeploymentVersion' namespace='/deploy' cancelUri='${returnUrl!"/deploy/viewDeploymentProjectEnvironments.action?id=${deploymentProject.id}"}']

    [#assign planBranchPickerId = 'deploymentProjectPlanBranch' /]
    [#assign planBranchPickerContainerId = '${planBranchPickerId}_container' /]

    [@ww.hidden id='masterBranchPlanKey' name='masterBranchKey' /]
    [@ww.hidden id='linkedPlanKey' name='linkedPlanKey' /]
    [@ww.hidden id='deploymentProjectBranchKey' name='deploymentProjectBranchKey' /]

    [@ui.header pageKey='deployment.version.create.choose.build.results' headerElement='h3' /]
    <div id="fieldArea_sourcePlanId" class="field-group">
        <label for="sourcePlanId" id="fieldLabelArea_sourcePlanId">[@s.text name="deployment.project.plan" /]</label>
            <span id="sourcePlanId" class="field-value">
                ${soy.render ("bamboo.web.resources:bamboo-js", "widget.plan.renderPlanNameLinkWithoutBranch", {
                    "plan": linkedPlan
                })}
            </span>
    </div>

    <div id="${planBranchPickerContainerId}" [#if !masterPlanBranches?has_content]class="hidden"[/#if]>
        [@s.textfield
            id=planBranchPickerId
            name='deploymentReleaseBranch'
            labelKey='deployment.project.plan.branch.for.version'
            placeholderKey='deployment.project.plan.branch.placeholder'
            required=true
            masterPlanPickerId='masterBranchPlanKey'
            includeMasterBranch=true
            template='branchPicker'
            cssClass='long-field'/]
    </div>

    [@ww.hidden name='deploymentProjectId'/]
    [@ww.hidden name='planKey'/]

    [@ui.bambooSection cssClass="select-build-result"]
        [#if action.fieldErrors.get("customBuildResults")?has_content]
            [#assign customBuildResultsError=action.fieldErrors.get("customBuildResults")[0] /]
        [/#if]

        ${soy.render("bamboo.web.resources:build-result-list-selector", "bamboo.feature.build.result.resultSelectionList", {
            "results": latestResultSummaries!,
            "customBuildResultsError": customBuildResultsError!'',
            "selectedBuildNumber": buildNumber,
            "placeHolderBuildNumber": placeholderBuildNumber,
            "planKey": linkedPlanKey,
            "planName": linkedPlan.name,
            "isBuildRecent": buildInThreeMostRecent
        })}
    [/@ui.bambooSection]

    [#if action.fieldErrors.get("versionName")?has_content]
        [#assign versionNameError=action.fieldErrors.get("versionName")[0] /]
    [/#if]

    ${soy.render("bamboo.deployments:view-deployment-version", "bamboo.page.deployment.version.showVersionNames", {
        "deploymentProjectId": deploymentProject.id,
        "deploymentFromMainBranch": deploymentFromMainBranch,
        "latestVersion": latestVersion!,
        "versionName": versionName,
        "nextVersionName": nextVersionName!'',
        "versionNameError": versionNameError!''
    })}

    [@ui.bambooSection titleKey='deployment.version.create.changes.since' cssClass="changes-since"]
        <div class="deployment-preview">
            ${soy.render("bamboo.deployments:view-deployment-version", "bamboo.page.deployment.version.preview", {
            })}
        </div>
    [/@ui.bambooSection]

    [@ww.param name='buttons']
        [@ww.submit value=action.getText('deployment.project.create.version') name='save' primary=true cssClass='create-version-button' /]
    [/@ww.param]
[/@ww.form]

<script>
    AJS.$(function ($) {
        BAMBOO.createVersionPreview.init({
                                             deploymentProjectId: ${deploymentProject.id},
                                             resultsCount: ${latestResultSummaries.size()},
                                             selectors: {
                                                 formSelector: "#createDeploymentVersion",
                                                 versionPreviewContainerSelector: "#new-version-details",
                                                 newVersionResultRadioName: "buildResult",
                                                 planKeySelector: "#linkedPlanKey",
                                                 deploymentProjectBranchKey: "#deploymentProjectBranchKey",
                                                 branchPickerSelector: "#${planBranchPickerId}",
                                                 pickVersionSelector: ".pick-version-section",
                                                 selectBuildSelector: ".select-build-result",
                                                 changesSinceSelector: ".changes-since",
                                                 customResultFieldSelector: '#custom-build-result',
                                                 customResultFieldErrorSelector: '#custom-build-result-error',
                                                 customResultRadioSelector: '#build-result-other',
                                                 saveButtonSelector: ".create-version-button",
                                                 sourcePlanLinkSelector: "#sourcePlanId"
                                             }
                                         });
    });
</script>

</body>
</html>