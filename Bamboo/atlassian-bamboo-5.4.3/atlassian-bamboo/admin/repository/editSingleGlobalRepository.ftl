[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.ConfigureSingleGlobalRepository" --]
[#import "/build/common/repositoryCommon.ftl" as rc]

<div id="repository-edit-html">
    [@ui.bambooSection dependsOn='selectedRepository' showOn=repository.key id='repository-edit-${repository.key}']
        ${repository.getEditHtml(buildConfiguration)!}
    [/@ui.bambooSection]
</div>
[#assign advancedEditHtml]${repository.getAdvancedEditHtml(buildConfiguration)!}[/#assign]
[#if advancedEditHtml?has_content]
    <div id="repository-advanced-edit-html">[@ui.bambooSection dependsOn='selectedRepository' showOn=repository.key]${advancedEditHtml}[/@ui.bambooSection]</div>[#t]
[/#if]
