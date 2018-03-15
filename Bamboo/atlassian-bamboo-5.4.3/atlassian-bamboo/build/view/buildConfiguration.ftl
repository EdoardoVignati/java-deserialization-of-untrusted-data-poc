[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]

[#import "/lib/build.ftl" as bd]

<html>
<head>
    [@ui.header pageKey='build.configuration.title.long' object=immutableBuild.name title=true /]
    <meta name="tab" content="config"/>
    ${webResourceManager.requireResourcesForContext("ace.editor")}
</head>
<body>
    [#assign dropDownText][@ww.text name='job.edit' /][/#assign]
    [@cp.configDropDown dropDownText 'planConfiguration.subMenu' /]

    [@ui.header pageKey='build.configuration.title.long' /]

    [#if immutableBuild.suspendedFromBuilding]
        [@ww.text name='build.enable.job.description' id='buildEnableJobDescription']
            [@ww.param][@ww.url action='resumeBuild' namespace='/build/admin' buildKey=immutableBuild.key returnUrl="/browse/${immutableBuild.key}/config"/][/@ww.param]
        [/@ww.text]
        [@ui.messageBox title=buildEnableJobDescription /]
    [/#if]

    [#-- 1. Plan & project details--]
    [@ui.bambooInfoDisplay titleKey="job.details" headerWeight="h2"]
        [@ww.label labelKey='job.key' name='build.planKey' /]
        [@ww.label labelKey='job.name' name='build.buildName' /]
        [@ww.label labelKey='job.description' name='build.description' hideOnNull='true' /]
        [@ww.label labelKey='job.lastVcsRevisionKey' name='lastVcsRevisionKey' hideOnNull='true' /]
        [@ww.label labelKey='job.workingDirectory' name='workingDirectoryDefinition' hideOnNull='true'/]
    [/@ui.bambooInfoDisplay]

    [#-- 3a. Tasks --]
    [#include "./viewTasks.ftl"]

    [#-- 4. Requirements--]
    [@ui.bambooInfoDisplay titleKey="requirement.title" headerWeight="h2"]
        [@bd.configureBuildRequirement requirementSetDecorator=requirementSetDecorator plan=immutablePlan showForm=false showOperations=false /]
    [/@ui.bambooInfoDisplay]

    [#--5. Artifacts--]
    [#if artifactDefinitions?has_content]
        [@ui.bambooInfoDisplay titleKey="artifact.produced.title" headerWeight="h2"]
            <p>[@ww.text name='artifact.definition.description'/]</p>
            [@bd.displayArtifactDefinitions artifactDefinitions=artifactDefinitions showOperations=false/]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if artifactSubscriptions?has_content]
        [@ui.bambooInfoDisplay titleKey="artifact.consumed.title" headerWeight="h2"]
            <p>[@ww.text name='artifact.consumed.description'/]</p>
            [@bd.displayArtifactSubscriptions artifactSubscriptions=artifactSubscriptions showOperations=false showSubstitutionVariables=true /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 5. Notifications --]
    [#if immutablePlan.type != "JOB" && (chain.notificationSet.notificationRules)?has_content]
        [@ui.bambooInfoDisplay titleKey="notification.title" headerWeight="h2"]
            [@bd.existingNotificationsTable /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 8. Miscellaneous --]
    [#if miscellaneousBuildConfigurationViewHtmlList?has_content]
        [@ui.bambooInfoDisplay titleKey="build.miscellaneous" headerWeight="h2"]
            [#include "./viewMiscellaneous.ftl"]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 8. Permissions --]
    [#if immutablePlan.type != "JOB" && fn.hasPlanPermission('ADMINISTRATION', immutablePlan) ]
        [@ui.bambooInfoDisplay titleKey="chain.permissions.title" headerWeight="h2"]
            [@ww.action name="viewChainPermissions" executeResult="true"]
                [@ww.param name="planKey" value="'${immutablePlan.key}'"/]
            [/@ww.action]
        [/@ui.bambooInfoDisplay]
    [/#if]

</body>
</html>
