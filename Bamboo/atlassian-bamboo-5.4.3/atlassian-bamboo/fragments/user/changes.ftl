[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#-- @ftlvariable name="commitView" type="com.atlassian.bamboo.commit.CommitView" --]

[#import "/lib/chains.ftl" as cn]

<div id="latest-builds">
        [#if commitViews?has_content]
            [#assign commitView = commitViews.get(0)]
            [#assign prevCommitDate = commitView.commit.date?string("yyyy-MM-dd")]
            <h3>
                [@ui.time commitView.commit.date]${commitView.commit.date?string("EEEE")}
                <span class="date">${commitView.commit.date?string("d MMMM yyyy")}</span>
                [/@ui.time]
            </h3>
            <ul class="commits">
                [#list commitViews as commitView]
                    [#if commitView.summaries?has_content]
                        [#if prevCommitDate != commitView.commit.date?string("yyyy-MM-dd")]
                            </ul>
                                <h3>[@ui.time commitView.commit.date]${commitView.commit.date?string("EEEE")}
                                    <span class="date">${commitView.commit.date?string("d MMMM yyyy")}</span>[/@ui.time]</h3>
                            <ul class="commits">
                        [/#if]
                        <li>
                            <p>${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commitView.commit.comment))}</p>
                            [@ui.time datetime=commitView.commit.date]${commitView.commit.date?string("h:mm:ss a")}[/@ui.time]
                            <ul class="related-builds">
                                [#list commitView.summaries as resultSummary]
                                    <li>
                                        [#assign plan= resultSummary.immutablePlan]
                                        [@ww.url id="changeUrl" value='/browse/${resultSummary.planResultKey}' /]
                                        [@cn.showFullPlanName url=changeUrl plan=plan icon=fn.getPlanStatusIcon(resultSummary)?lower_case includeProject=true buildNumber=resultSummary.buildNumber /]
                                    </li>
                                [/#list]
                            </ul>
                        </li>
                        [#assign prevCommitDate = commitView.commit.date?string("yyyy-MM-dd")]
                    [/#if]
                [/#list]
            </ul>
        [#else]
            <p>[@ww.text name="dashboard.mybamboo.changes.nocommits"/]</p>
        [/#if]
</div>
