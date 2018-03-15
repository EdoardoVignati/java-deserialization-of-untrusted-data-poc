[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.PlanResultsAction" --]
<div class="commentsummary">
[#list resultsSummary.comments as comment]
    <strong>[@ui.displayUserFullName user=comment.user /]</strong>
    on <strong>${resultsSummary.immutablePlan.buildName}</strong>
    [#if comment.lastModificationDate?has_content]
        ${durationUtils.getRelativeDate(comment.lastModificationDate)} [@ww.text name='global.dateFormat.ago'/]:       
    [/#if]
    <br/>
    [@ui.renderValidJiraIssues comment.content  resultsSummary  /]
    [#if comment_index gte 2]
        [#break]
    [/#if]
    [#if comment_has_next]
        <hr/>
    [/#if]
[/#list]
</div>