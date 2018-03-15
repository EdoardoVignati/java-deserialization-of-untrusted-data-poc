[#-- @ftlvariable name="build" type="com.atlassian.bamboo.build.Buildable" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#-- @ftlvariable name="addedComment" type="com.atlassian.bamboo.comment.Comment" --]
[#-- @ftlvariable name="comments" type="java.util.List<com.atlassian.bamboo.comment.Comment>" --]
[#include "notificationCommonsHtml.ftl"]
[#assign flavorHtml]
<span class="username">
    [#if addedComment.user?has_content]
        [@ui.displayUserFullName user=addedComment.user /]
    [#elseif addedComment.userName?has_content]
        ${addedComment.userName?html}
    [#else]
        Anonymous User
    [/#if]
</span>
commented on:
[/#assign]

[@templateOuter baseUrl=baseUrl showTitleStatus=false]
    [@notificationTitleBlock baseUrl addedComment.userName flavorHtml]
        [@displayBuildTitle baseUrl build buildSummary.planResultKey buildSummary.buildNumber/]
    [/@notificationTitleBlock]

    <h3><a href="${baseUrl}/browse/${buildSummary.planResultKey}">${comments?size} Comment[#if comments?size != 1]s[/#if]</a></h3>

    <table width="100%" cellpadding="0" cellspacing="0" class="comments">
        <tbody>
            [#list comments as comment]
            <tr class="comment[#if comment.id == addedComment.id] active[/#if]">
                <td valign="top" class="comment-avatar">
                    [@displayGravatar baseUrl comment.userName!"" "32"/]
                </td>
                <td>
                    <div class="commentsummary">
                        <span class="username">
                            [#if comment.user?has_content]
                                <a href="${baseUrl}/browse/user/${comment.user.name}">[@ui.displayUserFullName user=comment.user/]</a>
                            [#elseif comment.userName?has_content]
                                ${comment.userName?html}
                            [#else]
                                Anonymous User
                            [/#if]
                        </span>
                        <small class="email-metadata">${comment.lastModificationDate?datetime}</small>
                    </div>
                    <div class="wiki-content">
                        ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(comment.content), buildSummary)}
                    </div>
                </td>
            </tr>
            [/#list]
        </tbody>
    </table>

    [@showActions]
        [@addAction "View Online" "${baseUrl}/browse/${buildSummary.planResultKey}" true/]
        [@addAction "Add Comments" "${baseUrl}/browse/${buildSummary.planResultKey}?commentMode=true"/]
    [/@showActions]

[/@templateOuter]