[#-- @ftlvariable name="pager" type="com.atlassian.bamboo.filter.Pager" --]

[#import "/lib/chains.ftl" as cn]

[#macro showBuildResultsTable pager showAgent showOperations showArtifacts sort showPager=true showHeader=true showDuration=true useRelativeDate=false showFullBuildName=true]
[#assign extraColumns  = 0 /]


    <table id="buildResultsTable" class="aui" [#if !(pager.page.list)?has_content]style="display: none"[/#if]>
        <thead[#if !showHeader] class="assistive"[/#if]>
            <tr>
                <th>[@ww.text name='buildResult.completedBuilds.status'/]</th>
                <th>[@ww.text name='buildResult.completedBuilds.reason'/]</th>
                <th>[@ww.text name='buildResult.completedBuilds.completionTime'/]</th>
                [#if showDuration]
                    <th>[@ww.text name='buildResult.completedBuilds.duration'/]</th>
                [/#if]
                [#if showAgent]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th>[@ww.text name="buildResult.completedBuilds.agent"/]</th>
                [/#if]
                <th>[@ww.text name='buildResult.completedBuilds.testResults'/]</th>
                <th>[@ww.text name='buildResult.completedBuilds.flags'/]</th>
                [#if showArtifacts]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th>[@ww.text name='buildResult.completedBuilds.artifacts'/]</th>
                [/#if]
                [#if showOperations && fn.hasPlanPermission('WRITE', immutablePlan)]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th></th>
                [/#if]
            </tr>
        </thead>
        [#if showPager]
        <tfoot>
            [#if (pager.page)?has_content]
                <tr>
                    <td colspan="${6 + extraColumns}">
                        [@cp.pagination /]
                    </td>
                </tr>
            [/#if]
        </tfoot>
        [/#if]
        <tbody>
        [#list (pager.page.list)! as buildResult]
            <tr>
              [@showBuildResultRow buildResult showAgent showOperations showArtifacts showPager showDuration useRelativeDate showFullBuildName/]
            </tr>
        [/#list]
        </tbody>
    </table>
[#if !(pager.page.list)?has_content]
    <p class="buildResultsNone">[@ww.text name='buildResult.completedBuilds.noBuilds'/]</p>
[/#if]
[/#macro]

[#macro showBuildResultRow buildResult showAgent showOperations showArtifacts showPager=true showDuration=true useRelativeDate=false showFullBuildName=true]
                <td class="${buildResult.buildState}">
                    [#if showFullBuildName]
                        [@ui.icon '${fn.getPlanStatusIcon(buildResult)?lower_case}'/]
                        <a href="${req.contextPath}/browse/${buildResult.immutablePlan.project.key}">${buildResult.immutablePlan.project.name}</a> &rsaquo;

                        [#assign plan=buildResult.immutablePlan]
                        [#if fn.isChain(plan)]
                            <a href="${req.contextPath}/browse/${plan.key}" [#if plan.description?has_content]title="${plan.description}"[/#if]>${plan.buildName}</a> &rsaquo;
                        [#elseif fn.isJob(plan)]
                            [#assign chainSummary=buildResult.chainResultsSummary]
                            [@cn.showFullPlanName plan=plan.parent /]
                            &rsaquo;
                        [/#if]

                        [#assign planResult=buildResult]
                        [#if fn.isJob(plan)]
                            [#assign planResult=buildResult.chainResultsSummary]
                        [/#if]

                        <a href="${req.contextPath}/browse/${planResult.planResultKey}">#${planResult.planResultKey.buildNumber}</a>

                        [#if fn.isJob(plan)]
                            &rsaquo;
                            <a href="${req.contextPath}/browse/${buildResult.planResultKey}">${plan.buildName}</a>
                        [/#if]
                    [#else]
                        [#assign title=buildResult.buildState/]
                        [#if buildResult.continuable?? && buildResult.continuable]
                            [#assign title][@ww.text name="build.buildState.stoppedOnManual"/][/#assign]
                        [/#if]
                        <a class="statusIndicator" id="buildResult_${buildResult.planResultKey}" href="${req.contextPath}/browse/${buildResult.planResultKey}" title="${title}">[@ui.icon type="${fn.getPlanStatusIcon(buildResult)}" /] #${buildResult.buildNumber}</a>
                    [/#if]
                    [@cp.commentIndicator resultsSummary=buildResult /]
                </td>
                <td>
                    <span id="commits_${buildResult.planResultKey}" class="commits">${buildResult.reasonSummary}</span>
                    [#if buildResult.labelNames?has_content]
                        <br/>
                        [#import "/fragments/labels/labels.ftl" as lb /]
                        [@lb.showLabels buildResult.labelNames buildResult.immutablePlan buildResult true false /]
                    [/#if]
                    [#if buildResult.hasChanges()]
                        <script type="text/javascript">
                            AJS.$(function(){
                                initCommitsTooltip("commits_${buildResult.planResultKey}", "${buildResult.planKey}", "${buildResult.buildNumber}")
                            });
                        </script>
                    [/#if]
                </td>

                [#if buildResult.buildCompletedDate?has_content ]
                    [#assign buildDate=buildResult.buildCompletedDate?datetime?string("EEE, d MMM, hh:mm a")]
                [#else]
                    [#assign buildDate]
                        [@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]
                    [/#assign]
                [/#if]

                [#if useRelativeDate]
                    <td title="${buildDate}">${buildResult.relativeBuildDate}</td>
                [#else]
                    <td title="${buildResult.relativeBuildDate}">${buildDate}</td>
                [/#if]

                [#if showDuration]
                    <td>${buildResult.processingDurationDescription}</td>
                [/#if]

                [#if showAgent]
                    <td>
                        [#if buildResult.buildAgentId??]
                            [#assign pipelineDefinition = action.getPipelineDefinitionByBuildResult(buildResult)! /]
                            [#if pipelineDefinition?has_content]
                                [@ui.renderPipelineDefinitionNameLink pipelineDefinition/]
                            [#else]
                                (${buildResult.buildAgentId})
                            [/#if]
                        [/#if]
                    </td>
                [/#if]

                <td>
                    [#if buildResult.testResultsSummary.totalTestCaseCount > 0 ]
                        <a href="${req.contextPath}/browse/${buildResult.planResultKey}/test">${buildResult.testSummary}</a>
                    [#else]
                        [@ww.text name='buildResult.completedBuilds.noTests'/]
                    [/#if]
                </td>

                <td>
                    [#if buildResult.onceOff || buildResult.rebuild || buildResult.customBuild]
                        [#if buildResult.onceOff][@ui.lozenge colour="complete" textKey="buildResult.flags.customRevision"/][/#if]
                        [#if buildResult.rebuild][@ui.lozenge colour="moved" textKey="buildResult.flags.rebuild"/][/#if]
                        [#if buildResult.customBuild][@ui.lozenge colour="current" textKey="buildResult.flags.customBuild"/][/#if]
                    [/#if]
                </td>
                [#if showArtifacts]
                <td>
                    [#assign artifactLinks=buildResult.artifactLinksThatExist!/]
                    [#if artifactLinks?has_content]
                        [#assign artifactCount=0/]
                        [#list artifactLinks as artifactLink]
                            [#if artifactLink.url?has_content]
                                <div><a href="${req.contextPath}${artifactLink.url}">${artifactLink.label?html}</a></div>
                                [#assign artifactCount=artifactCount + 1 /]
                                [#if artifactCount > 2]
                                    [#break]
                                [/#if]
                            [/#if]
                        [/#list]
                        [#if artifactCount < artifactLinks.size()]
                            [@ww.text name='buildResult.completedBuilds.moreArtifacts'][@ww.param value=artifactLinks.size() - artifactCount/][/@ww.text]
                        [/#if]
                    [#else]
                        [@ww.text name='buildResult.completedBuilds.noArtifacts'/]
                    [/#if]
                </td>
                [/#if]
                [#if showOperations && fn.hasPlanPermission('WRITE', buildResult.immutablePlan)]
                <td class="operationsColumn">

                    [@ww.url id='deleteUrl' namespace='/build/admin' action='deletePlanResults' buildNumber='${buildResult.buildNumber}' buildKey='${buildResult.planResultKey.planKey}'/]
                        <a class="deleteLink mutative" id="deleteBuildResult_${buildResult.planResultKey}"
                           href="${deleteUrl}"
                           title="Delete the build results"
                           onclick="return confirm('[@ww.text name="buildResult.completedBuilds.confirmDelete"/]');">[@ww.text name='global.buttons.delete'/]
                        </a>
                </td>
                [/#if]
[/#macro]