[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]

[#macro displayReorderQueueActions buildContext returnUrl index bottomIndex]
    <ul class="queueActions queueReorderActions">
    [#if index > 0 ]
        [@ww.url id='reorderQueueTop' namespace='/build/admin' action='reorderBuild' buildKey="${buildContext.planKey}" queueIndex="0" returnUrl="${returnUrl}" /]
        <li>
            <a class="internalLink" href="${reorderQueueTop}" title="${action.getText('queue.reorder.top')}">
                <img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_first.gif" border="0" alt="${action.getText('queue.reorder.top')}" width="16" height="16" align="absmiddle">
            </a>
        </li>
        [@ww.url id='reorderQueueUp' namespace='/build/admin' action='reorderBuild' buildKey="${buildContext.planKey}" queueIndex="${index - 1}" returnUrl="${returnUrl}" /]
        <li>
            <a class="internalLink" href="${reorderQueueUp}" title="${action.getText('queue.reorder.up')}">
                <img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_up_blue.gif" border="0" alt="${action.getText('queue.reorder.up')}" width="16" height="16" align="absmiddle">
            </a>
        </li>
    [#else]
        <li><img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_first.gif" border="0" alt="-" width="16" height="16" align="absmiddle"></li>
        <li><img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_up_blue.gif" border="0" alt="-" width="16" height="16" align="absmiddle"></li>
    [/#if]
    [#if index < bottomIndex ]
        [@ww.url id='reorderQueueDown' namespace='/build/admin' action='reorderBuild' buildKey="${buildContext.planKey}" queueIndex="${index + 1}" returnUrl="${returnUrl}" /]
        <li>
            <a class="internalLink" href="${reorderQueueDown}" title="${action.getText('queue.reorder.down')}">
                <img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_down_blue.gif" border="0" alt="${action.getText('queue.reorder.down')}" width="16" height="16" align="absmiddle">
            </a>
        </li>
        [@ww.url id='reorderQueueBottom' namespace='/build/admin' action='reorderBuild' buildKey="${buildContext.planKey}" queueIndex="${bottomIndex}" returnUrl="${returnUrl}" /]
        <li>
            <a class="internalLink" href="${reorderQueueBottom}" title="${action.getText('queue.reorder.bottom')}">
                <img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_last.gif" border="0" alt="${action.getText('queue.reorder.bottom')}" width="16" height="16" align="absmiddle">
            </a>
        </li>
    [#else]
        <li><img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_down_blue.gif" border="0" alt="-" width="16" height="16" align="absmiddle"></li>
        <li><img src="[@cp.getStaticResourcePrefix /]/images/icons/arrow_last.gif" border="0" alt="-" width="16" height="16" align="absmiddle"></li>
    [/#if]
    </ul>
[/#macro]

<div id="queues">
    <p class="headingInfo">
        [#if fn.hasAdminPermission() ]
            <a id="enableAllQueues" class="internalLink mutative" href="[@ww.url action='configureAgents!activateAll' namespace='/admin/agent' returnUrl='${returnUrl}'/]">[@ww.text name='queue.enableAll'/]</a> |
            <a id="disableAllQueues" class="internalLink mutative" href="[@ww.url action='configureAgents!deactivateAll' namespace='/admin/agent' returnUrl='${returnUrl}'/]">[@ww.text name='queue.disableAll'/]</a>
        [/#if]
    </p>
    <h2>
        <a href="${req.contextPath}/agent/viewAgents.action">[@ww.text name='agent.title' /]</a>        
    </h2>
    <div>
        [#list buildAgents as agent]
            [#if agent.active]
            <div class="queue [#if !agent.enabled] disabled[/#if]  [#if agent_index % 2 == 1][/#if]">
                <h3>
                    [#if fn.hasAdminPermission() ]
                    <span class="actionLinks">
                        [#if agent.enabled]
                            <a id="disableQueue:${agent.id?c}" class="internalLink" href="[@ww.url action='disableAgent' namespace='/admin/agent' agentId='${agent.id?c}' returnUrl='${returnUrl}'/]">[@ww.text name='global.buttons.disable'/]</a>
                        [#else]
                            <a id="enableQueue:${agent.id?c}" class="internalLink" href="[@ww.url action='enableAgent' namespace='/admin/agent' agentId='${agent.id?c}' returnUrl='${returnUrl}'/]">[@ww.text name='global.buttons.enable'/]</a>
                        [/#if]
                    </span>
                    [/#if]
                    [@ui.renderAgentNameLink agent/]
                    [#if !agent.enabled]
                        <span class="legacy-warning">[@ww.text name='queue.agent.disabled' /]</span>
                    [/#if]
                </h3>

            [#assign currentlyBuilding = action.getCurrentlyBuilding(agent.id)!("") /]
            [#if !currentlyBuilding?has_content]
                <ol>
                    <li>[@ww.text name='agent.inactive' /]</li>
                </ol>
            [#else]
                <ol>
                    [#assign buildId = currentlyBuilding.buildIdentifier /]
                    [#assign progressBar = currentlyBuilding.progressBar]
                    [#if fn.hasPlanPermission('READ', buildId.planKey)]
                    <li class="on">
                        <h4>
                            <a id="viewBuild:${buildId.planKey}:${agent.definition.id?c}" href="${req.contextPath}/browse/${buildId.planKey}/log">${buildId.planName}</a>
                        </h4>
                        <ul class="queueActions">
                            [#if fn.hasPlanPermission('BUILD', buildId.planKey)]
                            <li id="currentlyBuildingActions">
                                [#if agent.agentStatus == 'Cancelling']
                                    <img src="[@cp.getStaticResourcePrefix /]/images/icons/delete_disabled.gif" border="0" alt="[@ww.text name='agent.build.cancelling' /]" width="16" height="16" align="absmiddle" />
                                [#else]
                                    <a class="internalLink build-stop" href="${req.contextPath}/build/admin/stopPlan.action?planKey=${buildId.planKey}&amp;returnUrl=${returnUrl}">[@ui.icon type="build-stop" textKey="agent.build.cancel" /]</a>
                                [/#if]
                            </li>
                            [/#if]
                        </ul>
                        <p class="queueStatus">
                            [#if (currentlyBuilding.elapsedTime)! > 0]
                                [#if currentlyBuilding.buildHangDetails?has_content]
                                    <span class="errorText">Building for ${durationUtils.getPrettyPrint(currentlyBuilding.elapsedTime)} (Build Hung).</span>
                                [#else]
                                    Building for ${durationUtils.getPrettyPrint(currentlyBuilding.elapsedTime)}.
                                    [#if progressBar.underAverageTime]
                                        <em>${progressBar.prettyTimeRemaining}</em>
                                    [/#if]
                                [/#if]
                            [#else]
                                Updating source code to ${(currentlyBuilding.buildChanges.vcsRevisionKey)!('latest.')}
                            [/#if]

                        </p>
                            [#if progressBar.valid]
                                <div class="progressBar">

                                [#if progressBar.underAverageTime]
                                    [#assign msg = "Approximately ${progressBar.percentageCompletedAsString} completed"]
                                [#else]
                                    [#assign msg = "Current build has exceeded average build time. Running at ${progressBar.percentageCompletedAsString} of the average build time"]
                                [/#if]
                                <div class="progressBarCurrent"  style="width: ${progressBar.timeElapsedWidth}%;" title="${msg}"></div>
                                <div class="progressBarExpected" style="width: ${progressBar.totalTimeWidth}%;" title="Average build duration of previous builds: ${durationUtils.getPrettyPrint(progressBar.estimatedDuration)}"></div>
                                </div> <!-- END .progressBar -->
                            [/#if]
                        <div class="clearer"></div>
                    </li>
                    [#else]
                        <li class="on">
                            <h4>
                                [@ww.text name='queue.hidden.build.building' /]
                            </h4>

                            <p class="queueStatus">
                                [@ww.text name='queue.hidden.build.status' /]
                            </p>
                        </li>
                    [/#if]
                </ol>
            [/#if]
            </div> <!-- END .queue -->
            [/#if]
        [/#list]

        <div id="buildQueueDiv" class="queue">
            <h3>
                [#if queue?has_content && fn.hasAdminPermission() ]
                    <span class="actionLinks">
                        <span class="internalLink toggleQueue toggleQueueControl" onclick="return buildQueue.displayActions('actions-queueControl');" title="[@ww.text name="queue.actions.toggle.normal.tooltip" /]">[@ww.text name="queue.actions.toggle.normal"/]</span> |
                        <span class="internalLink toggleQueue toggleQueueReorder" onclick="return buildQueue.displayActions('actions-queueReorder');" title="[@ww.text name="queue.actions.toggle.reorder.tooltip" /]">[@ww.text name="queue.actions.toggle.reorder"/]</span>
                    </span>
                [/#if]
                [@ww.text name='queue.heading' /]
            </h3>
            <ol>
            [#if queue?has_content]
                [#list queue as buildContext]
                    [#if fn.hasPlanPermission('READ', buildContext.planKey) ]
                        [#assign currentlyBuilding=(action.getCurrentlyBuilding(buildContext.buildResultKey))!('') /]
                        <li class="queueItem[#if reorderedBuildKey?? && buildContext.planKey = reorderedBuildKey] reorderedBuild[/#if]">
                            <h4>
                                ${buildContext_index+1}. <a id="viewBuild:${buildContext.planKey}:queue" href="${req.contextPath}/browse/${buildContext.planResultKey}">${buildContext.planName}</a>
                            </h4>
                            [#if fn.hasAdminPermission() ]
                                [@displayReorderQueueActions buildContext=buildContext returnUrl=returnUrl index=buildContext_index bottomIndex=queue.size() - 1 /]
                            [/#if]
                            <ul class="queueActions queueControlActions">
                            [#if currentlyBuilding?has_content && !currentlyBuilding.executableElasticImages.isEmpty()]
                                <li>
                                [#if fn.hasAdminPermission() ]
                                    <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action" id="${buildContext.planKey}Elastic">
                                        [@ui.icon type="elastic" text="This plan can be built in the cloud." /]
                                    </a>
                                    [@dj.tooltip target='${buildContext.planKey}Elastic'][@ww.text name="queue.status.waiting.elastic.admin" /][/@dj.tooltip]
                                [#else]
                                    <span id="${buildContext.planKey}Elastic">[@ui.icon type="elastic" text="This plan can be built in the cloud." /]</span>
                                    [@dj.tooltip target='${buildContext.planKey}Elastic'][@ww.text name="queue.status.waiting.elastic" /][/@dj.tooltip]
                                [/#if]
                                 </li>
                            [/#if]
                            [#if fn.hasPlanPermission('BUILD', buildContext.planKey) ]
                                <li><a class="internalLink build-stop" href="${req.contextPath}/build/admin/stopPlan.action?planKey=${buildContext.planKey}&amp;returnUrl=${returnUrl}">[@ui.icon type="build-stop" textKey="queue.delete.from" /]</a></li>
                            [/#if]
                            </ul>
                            <p class="queueStatus">
                                [#if currentlyBuilding?has_content]
                                    [#if currentlyBuilding.hasExecutableAgents()]
                                        <span title="Can run on agents [#rt/]
                                        [#list currentlyBuilding.executableBuildAgents as agent]
                                            ${agent.name?html}[#if agent_has_next], [/#if][#lt/]
                                        [/#list]">[#lt/]
                                            [@ww.text name='queue.status.waiting'/]</span>
                                    [#elseif !currentlyBuilding.executableElasticImages.isEmpty()]
                                        <span style="color:red">[@ww.text name='queue.status.cantBuild.elastic'/]</span>
                                    [#else]
                                        <span style="color:red">[@ww.text name='queue.status.cantBuild'/]</span>
                                    [/#if]
                                [#else]
                                    ${buildContext.planKey} not correctly removed from JMS queue. Please try again.
                                [/#if]
                            </p>
                            <div class="clearer"></div>
                        </li>
                    [#else]
                        <li>
                            <h4>${buildContext_index+1}. [@ww.text name='queue.hidden.build.waiting'/]</h4>
                            <p class="queueStatus">
                                [@ww.text name='queue.hidden.build.status' /]
                            </p>
                        </li>
                    [/#if]
                [/#list]
            [#else]
                <li>
                    [@ww.text name='queue.empty' /]
                </li>
            [/#if]
            </ol>
        </div>
    </div>
    [@ui.clear /]
</div> <!-- END #queues -->

