[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectDetails" --]

[#if id gt 0]
    [#assign postfix="update"/]
[#else]
    [#assign postfix="create"/]
[/#if]

<html>
<head>
[@ui.header pageKey="deployment.project.${postfix}" title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>


<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.howtheywork"][@ww.text name="deployments.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey="deployment.project.${postfix}" headerElement="h2" /]

<p>[@s.text name="deployment.project.configure.description" /]</p>

[#if id gt 0]
    [#assign cancelUri="/deploy/config/configureDeploymentProject.action?id=" + id /]
[#else]
    [#assign cancelUri="/deploy/viewAllDeploymentProjects.action" /]
[/#if]

[#assign planPickerId = 'deploymentProjectPlan' /]
[#assign planBranchPickerId = 'deploymentProjectPlanBranch' /]
[#assign planBranchPickerContainerId = '${planBranchPickerId}_container' /]
[#assign planBranchDefaultContainerId= 'branch-default-lozenge' /]
[#assign deploymentProjectNameId = 'deploymentProjectName' /]

[@ww.form id="configureDeploymentProjectDetails"
action="saveDeploymentProjectDetails" namespace="/deploy/config"
submitLabelKey="deployment.project.${postfix}.button" cancelUri=cancelUri]

    [@ww.hidden name="id" /]

    [@ui.bambooSection titleKey="deployment.project.configure.details.title" cssClass="project-details"]
        [@s.textfield labelKey='deployment.project.name' name='name' id=deploymentProjectNameId required=true /]
        [@s.textfield labelKey='deployment.project.description' name='description' cssClass='long-field'  /]
    [/@ui.bambooSection]

    [#assign sourcePlanTools][@help.url pageKey="deployments.versions.howtheywork"][@ww.text name="deployments.versions.howtheywork.title"/][/@help.url][/#assign]
    [@ui.bambooSection titleKey="deployment.project.configure.sourcePlan.title"
        cssClass="source-plan"
        tools=sourcePlanTools]

        <p class="heading-description">
            [@s.text name="deployment.project.configure.sourcePlan.title.description" /]
        </p>

        [@s.textfield
            labelKey='deployment.project.plan' name='masterPlanKey'
            id=planPickerId required=true template='planPicker'
            placeholderKey='deployment.project.plan.placeholder'
            cssClass='long-field'
        /]

        <div id="${planBranchPickerContainerId}" class="form-indent [#if !masterPlanBranches?has_content]hidden[/#if]">

            [@ww.radio name='usingDefaultBranch'
                template='radio.ftl'
                theme='aui'
                fieldValue='true'
                nameValue='planBranchType'
                labelKey='deployment.trigger.branch.selection.option.INHERITED'
                cssClass="branch-plan"
                toggle='true'
            /]

            [@ui.bambooSection dependsOn="usingDefaultBranch" showOn="true"]
                [@s.label
                    key='deployment.trigger.branch.selection.option.INHERITED.label'
                    containerId=planBranchDefaultContainerId
                    template='branchLabel'
                /]
            [/@ui.bambooSection]

            [@ww.radio name='usingDefaultBranch'
                template='radio.ftl'
                theme='aui'
                fieldValue='false'
                nameValue='planBranchType'
                labelKey='deployment.trigger.branch.selection.option.CUSTOM'
                cssClass="branch-plan"
                toggle='true'
            /]

            [@ui.bambooSection dependsOn="usingDefaultBranch" showOn="false"]
                [@s.textfield
                    name='branchKey'
                    id=planBranchPickerId
                    required=true
                    masterPlanPickerId=planPickerId
                    includeMasterBranch=false
                    allowClear=false
                    template='branchPicker'
                    cssClass='long-field'
                /]
            [/@ui.bambooSection]

        </div>
    [/@ui.bambooSection]

[/@ww.form]

</body>
</html>