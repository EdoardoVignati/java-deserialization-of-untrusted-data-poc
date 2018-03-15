[#-- ========================================================================================== @agt.executablePlans --]
[#--
    List of executable buildables (builds and jobs)
    @requires executableBuildables
--]
[#macro executablePlans showLastBuild=false]
[#-- Executable Builds --]
    [@ui.bambooPanel]
        [#if executableBuildables?has_content]
        <table class="aui">
            <caption>[@ww.text name='agent.builds.execute.description' /]</caption>
            <thead>
            <th>&nbsp;</th>
            <th>[@ww.text name='plan.title' /]</th>
                [#if showLastBuild]
                <th>[@ww.text name='agent.builds.execute.built.last.title' /]</th>
                [/#if]
            </thead>
            <tbody>
                [#list executableBuildables as build]
                <tr>
                    <td class="minColumn">${build_index + 1}.</td>
                    <td>[@ui.renderPlanNameLink plan=build /]</td>
                    [#if showLastBuild]
                        <td>
                            [#assign lastBuild = (action.findLastBuild(build))!("") /]
                            [#if lastBuild?has_content]
                                [@ww.text name='agent.builds.execute.built.last' ]
                                    [@ww.param][@ui.icon type=lastBuild.buildState /][@ui.renderBuildResultSummary buildResultSummary=lastBuild /][/@ww.param]
                                    [@ww.param]${lastBuild.relativeBuildDate}[/@ww.param]
                                [/@ww.text]

                                [#if lastBuild.failed]
                                    [#assign successBuild = (action.findLastSuccessfulBuild(build))!("") /]
                                    <span class="subGrey">

                                        [#if successBuild?has_content]
                                            [@ww.text name='agent.builds.execute.built.last.success' ]
                                            [@ww.param][@ui.renderBuildResultSummary buildResultSummary=successBuild /][/@ww.param]
                                            [@ww.param]${successBuild.relativeBuildDate}[/@ww.param]
                                        [/@ww.text]
                                        [#else]
                                            [@ww.text name='agent.builds.execute.built.last.success.none' /]
                                        [/#if]
                                    </span>
                                [/#if]
                            [#else]
                                <span class="subGrey">
                                    [@ww.text name='agent.builds.execute.built.last.none' /]
                                </span>
                            [/#if]
                        </td>
                    [/#if]
                </tr>
                [/#list]
            </tbody>
        </table>
        [#else]
        <p>[@ww.text name='agent.builds.execute.none' /]</p>
        [/#if]
    [/@ui.bambooPanel]
[/#macro]

[#-- ============================================================================================= @agt.agentDetails --]
[#--
    Displays the top section of the agents page
    @requires headerKey
    @requires agentId
    @requires showOptions (none, short, all)
--]
[#macro agentDetails headerKey, agentId, showOptions, refresh=false, showStatus='yes', descriptionKey='' ]
    [@ui.bambooPanel titleKey=headerKey ]

        [@ww.text name='agent.builds.successRatio.long' id="successRatePercentageTitle"]
            [@ww.param]${statistics.totalSuccesses}[/@ww.param]
            [@ww.param]${statistics.totalNumberOfResults}[/@ww.param]
        [/@ww.text]
    <div style="overflow: hidden;">
        <div id="agentSuccessRate" class="successRatePercentage" title="${successRatePercentageTitle}">
            <p>
                <span>${statistics.successPercentage}%</span>
                [@ww.text name='agent.builds.successRatio']
                    [@ww.param]${statistics.totalSuccesses}[/@ww.param]
                    [@ww.param]${statistics.totalNumberOfResults}[/@ww.param]
                [/@ww.text]
            </p>
        </div>
        <!-- END #successRatePercentage -->
        <div>
            [#if descriptionKey?has_content ]
                <p>
                    [@ww.text name=descriptionKey /]
                </p>
            [/#if]
            [#if refresh]
                [@ww.url id='agentDetailsSnippetUrl' namespace='/ajax' action='viewAgentDetailsSnippet' escapeAmp=false
                agentId=agentId showOptions=showOptions showStatus=showStatus /]
                [@dj.reloadPortlet id='agentDetailsWidget' url="${agentDetailsSnippetUrl}" reloadEvery=10 ]
                    [@ww.action name="viewAgentDetailsSnippet" namespace="/ajax" executeResult="true" ]
                        [@ww.param name='showOptions']${showOptions}[/@ww.param]
                        [@ww.param name='agentId']${agentId}[/@ww.param]
                        [@ww.param name='showStatus']${showStatus}[/@ww.param]
                    [/@ww.action]
                [/@dj.reloadPortlet]
            [#else]
                [@ww.action name="viewAgentDetailsSnippet" namespace="/ajax" executeResult="true" ]
                    [@ww.param name='showOptions']${showOptions}[/@ww.param]
                    [@ww.param name='agentId']${agentId}[/@ww.param]
                    [@ww.param name='showStatus']${showStatus}[/@ww.param]
                [/@ww.action]
            [/#if]
        </div>
    </div>
    [#-- buttons --]
        [#if showOptions?? && fn.hasAdminPermission()]
            [@ui.displayButtonContainer]
                [#if showOptions == 'all' ]
                    [@ww.url action='viewAgent' namespace='/agent' agentId='${agentId}' id='viewAgentUrl' /]
                    [@ww.url action='editAgentDetails' namespace='/admin/agent' agentId='${agentId}' returnUrl='${currentUrl}' id='editAgentDetailsUrl' /]
                    [@cp.displayLinkButton buttonId="" buttonLabel="agent.view.activity" buttonUrl=viewAgentUrl /]
                    [@cp.displayLinkButton buttonId="" buttonLabel="agent.edit" buttonUrl=editAgentDetailsUrl /]
                    [#if agent.type.identifier != "elastic"]
                        [@ww.url id="agentAssignmentUrl" action='configureAgentAssignments' namespace='/admin/agent' agentId='${agentId}' returnUrl='${currentUrl}' /]
                        [@cp.displayLinkButton buttonId="" buttonLabel="agents.assignment.agent.button" buttonUrl=agentAssignmentUrl /]
                    [/#if]
                    [#if buildAgent.active]
                        [#if buildAgent.enabled]
                            [@ww.url action='disableAgent' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}' id='disableAgentUrl' /]
                            [@cp.displayLinkButton buttonId="disableQueue:${buildAgent.id}" buttonLabel="agent.disable" cssClass="mutative" buttonUrl=disableAgentUrl /]
                        [#else]
                            [@ww.url action='enableAgent' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}' id='enableAgentUrl'/]
                            [@cp.displayLinkButton buttonId="enableQueue:${buildAgent.id}" buttonLabel="agent.enable" cssClass="mutative" buttonUrl=enableAgentUrl /]
                        [/#if]
                    [/#if]

                    [#if buildAgent.active && !buildAgent.requestedToBeStopped]
                        [@ww.url action='stopAgentNicely' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}' id='stopAgentNicelyUrl' /]
                        [@cp.displayLinkButton buttonId="stopNicely${buildAgent.id}" buttonLabel="agent.stop.request" buttonUrl=stopAgentNicelyUrl altTextKey='agent.stop.request.description' mutative=true cssClass="requireConfirmation" /]
                    [/#if]

                    [#switch agent.type.identifier]
                        [#case "local"]
                            [#if buildAgent.active && buildAgent.agentStatus.allowDelete]
                                [@ww.url action='stopAgent' namespace='/admin/agent' agentId='${agentId}' id='stopAgentUrl' /]
                                [@cp.displayLinkButton buttonId="" buttonLabel="agent.stop" buttonUrl=stopAgentUrl altTextKey='agent.stop.description' /]
                            [#elseif !buildAgent.active]
                                [@ww.url action='startAgent' namespace='/admin/agent' agentId='${agentId}' id='startAgentUrl' /]
                                [@cp.displayLinkButton buttonId="" buttonLabel="agent.start" buttonUrl=startAgentUrl /]
                            [/#if]
                        [#-- no break here --]
                        [#case "remote"]
                            [#if buildAgent.agentStatus.allowDelete]
                                [@ww.url action='removeAgent' namespace='/admin/agent' agentId='${buildAgent.id}' id='removeAgentUrl' /]
                                [@ww.text name='agent.delete.description' id='removeAgentTitleText'][@ww.param]${buildAgent.id}[/@ww.param][/@ww.text]
                                [@cp.displayLinkButton buttonId="" buttonLabel="agent.delete" mutative=true buttonUrl=removeAgentUrl altText=removeAgentTitleText cssClass="requireConfirmation" /]
                            [#else]
                                [@cp.displayLinkButton buttonId="" buttonLabel="agent.delete" altTextKey="agent.delete.disable.description" disabled=true /]
                            [/#if]
                            [#break]
                        [#case "elastic"]
                            [#break]
                    [/#switch]
                [#elseif showOptions == 'short' ]
                    [@ww.url action='viewAgent' namespace='/admin/agent' agentId='${agentId}' id='viewAgentUrl' /]
                    [@cp.displayLinkButton buttonId="" buttonLabel="agent.admin" buttonUrl=viewAgentUrl /]
                [/#if]
            [/@ui.displayButtonContainer]
        [/#if]

    [/@ui.bambooPanel]
[/#macro]

[#-- =================================================================================================== @agt.header --]
[#--
    Displays the title of the page
    @requires agent
    @requires agentsListUrl - URL for the agents page
--]
[#macro header]
    [#assign heading]<a href="${agentsListUrl}">[@ww.text name='agent.title' /]</a> &rsaquo; ${agent.name?html}
    <span class="grey">([@ww.text name='agent.type.' + agent.type.identifier /])</span>[#if buildAgent.dedicated] [@ui.agentDedicatedLozenge/][/#if][/#assign]
    [@ui.header page=heading description=agent.description /]
[/#macro]

[#-- ======================================================================================== @agt.displayStatusCell --]
[#--
    Shows an agent status
--]
[#macro displayStatusCell agent]
    [#assign currentAgentStatus = agent.agentStatus /]
<img src="${req.contextPath}${currentAgentStatus.imagePath}" alt="${currentAgentStatus.label}"/>
    [#if currentAgentStatus.url??]
    <a href="${req.contextPath}${currentAgentStatus.url}">[#rt]
    [/#if]
    [#if !agent.active]
        [@ww.text name='agent.status.offline.title' /][#t]
    [#else]
    ${currentAgentStatus.label}[#t]
    [/#if]
    [#if currentAgentStatus.url??]
    </a> [#lt]
    [/#if]
    [#if !agent.enabled]
        [#if currentAgentStatus.idle || !agent.active]
        <span class="errorText">([@ww.text name='agent.status.disabled.title' /])</span>
        [#else]
        <span class="errorText">[@ww.text name='agent.status.disabledButBusy.title' /]</span>
        [/#if]
    [/#if]
    [#if agent.active && agent.requestedToBeStopped]
    <span class="errorText" title="[@ww.text name='agent.stop.request.description' /]">[@ww.text name='agent.status.stopRequested' /]</span>
    [/#if]
[/#macro]
[#-- ==================================================================================== @agt.displayOperationsCell --]
[#--
    Shows available operations
--]
[#macro displayOperationsCell agent]
<a id="view:${agent.id}" href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId='${agent.id}'/]">[@ww.text name='global.buttons.view' /]</a> |
<a id="edit:${agent.id}" href="[@ww.url action='editAgentDetails' namespace='/admin/agent' agentId='${agent.id}' returnUrl='${currentUrl}'/]">[@ww.text name='global.buttons.edit' /]</a>
[/#macro]

[#macro displayOperationsHeader agentType deleteOnly=false basicSelectorsOnly=false isPaginated=false isCompleteContentSelected=false ]
<p>
        <span>
            [@ww.text name='global.selection.select' /]:
            <span tabindex="0" role="link" selector="${agentType}_all">[@ww.text name='global.selection.all' /]</span>,
            <span tabindex="0" role="link" selector="${agentType}_none">[@ww.text name='global.selection.none' /]</span>[#rt]
            [#if !basicSelectorsOnly]
                ,[#t]
                <span tabindex="0" role="link" selector="${agentType}_idle">[@ww.text name='agent.status.idle.title' /]</span>,
                <span tabindex="0" role="link" selector="${agentType}_disabled">[@ww.text name='agent.status.disabled.title' /]</span>
            [/#if]
        </span>

        <span class="form-actions-bar">
            [@ww.text name='global.selection.action' /]:
            <span class="aui-buttons">
                [@ww.submit value=action.getText("agent.delete") name="deleteButton" id="delete${agentType}AgentButton" cssClass="requireConfirmation aui-button" titleKey="agent.delete.multiple.description"/]
                [#if !deleteOnly]
                [@ww.submit value=action.getText("agent.disable") name="disableButton" id="disable${agentType}AgentButton" cssClass="aui-button" /]
                [@ww.submit value=action.getText("agent.enable") name="enableButton" id="enable${agentType}AgentButton" cssClass="aui-button" /]
            [/#if]
            </span>
        </span>
</p>

    [#if isPaginated]
    <p>
        [@ww.hidden name="completeContentSelected" cssClass="${agentType}_completeContentSelected" nameValue="${isCompleteContentSelected?string}" /]

        [#assign shownElementsCount = pager.page.endIndex - pager.page.startIndex /]
        [#if shownElementsCount != pager.totalSize ]
        <div class="${agentType}_paginatedSelectAllWarning ${agentType}_paginatedWarning hidden formCompleteContentSelectionStatus">
            [@ww.text name="agent.mark.pagination.count"][@ww.param value="${shownElementsCount}"/][/@ww.text]
            <span tabindex="0" role="link" selector="${agentType}_allPages">
                [@ww.text name="agent.mark.pagination.select.all"][@ww.param value="${pager.totalSize}"/][/@ww.text]
            </span>
        </div>
        <div class="${agentType}_paginatedAllPagesSelected ${agentType}_paginatedWarning [#if !isCompleteContentSelected] hidden [/#if] formCompleteContentSelectionStatus">
            [@ww.text name="agent.mark.pagination.selected.all"][@ww.param value="${pager.totalSize}"/][/@ww.text]
        </div>
        [/#if]
    </p>
    [/#if]

<script type="text/javascript">
    AJS.$(function ()
          {
              SelectionActions.init("${agentType}");
          });
</script>
[/#macro]

[#-- ====================================================================================== @agt.displayCapabilities --]
[#--
    Shows a an li showing a set of capabilities. Agent may not actually exist

    @requires capabilitySet - set of capabilities to display
--]
[#macro displayCapabilities capabilitySetDecorator addCapabilityUrlPrefix='' elasticImageConfiguration='' showEdit=true showDelete=false showDescription=true returnAfterOpUrl='']

    [#list capabilitySetDecorator.groups as group]
        [#if addCapabilityUrlPrefix?has_content]
            [#assign addCapLink]
            <a id="addCapability:${group.typeKey}" href="${addCapabilityUrlPrefix}&capabilityType=${group.typeKey}">[@ww.text name='global.buttons.add' /] [@ww.text name='agent.capability.type.${group.typeKey}.title' /]</a>
            [/#assign]
        [#else]
            [#assign addCapLink = '' /]
        [/#if]
        [@ui.bambooPanel headerWeight='h3' titleKey='agent.capability.type.${group.typeKey}.title' tools='${addCapLink!}']
            [#if showDescription]
            <p>[@ww.text name='agent.capability.type.${group.typeKey}.description' /]</p>
            [/#if]

        <table id="capabilities-${group.typeKey}" class="capabilities aui">
            <thead>
            <tr>
                <th class="labelPrefixCell">
                    [@ww.text name='agent.capability.type.${group.typeKey}.key' /]
                    [@ww.text name='agent.capability.type.${group.typeKey}.key.description' id='keyDescription' /]
                    [#if keyDescription?has_content]
                        <br/>
                        <span class="subGrey">${keyDescription}</span>
                    [/#if]
                </th>
                <th class="valueCell">
                    [@ww.text name='agent.capability.type.${group.typeKey}.value' /]
                    [@ww.text name='agent.capability.type.${group.typeKey}.value.description' id='valueDescription' /]
                    [#if valueDescription?has_content]
                        <br/>
                        <span class="subGrey">${valueDescription}</span>
                    [/#if]
                </th>
                <th class="operations">
                    Operations
                </th>
            </tr>
            </thead>
            <tbody>
                [#list group.decoratedObjects as capability]
                <tr[#if capabilityKey?exists && capabilityKey == capability.key] class="selectedRow"[/#if]>
                    <td class="labelPrefixCell">
                        [@showName capability=capability /]
                    </td>
                    <td class="valueCell">
                    ${capability.value!?html}
                        [#if capability.overriddenValue?has_content]
                            <br/>
                            <span class="subGrey">(Overrides: ${capability.overriddenValue?html})</span>
                        [/#if]
                    </td>
                    <td class="operations">
                        [@showCapabilityOperations capability=capability agent=agent elasticImageConfiguration=elasticImageConfiguration showView=true showEdit=showEdit showDelete=showDelete returnAfterOpUrl=returnAfterOpUrl capabilityName='${capability.label}'/]
                    </td>
                </tr>
                [/#list]
            </tbody>
        </table>
        [/@ui.bambooPanel]
    [/#list]
[/#macro]

[#-- ================================================================================================= @agt.showName --]
[#-- Function to return the name of the decorated capability object --]
[#macro showName capability]
    [#if fn.hasGlobalAdminPermission()]
    <a id="title:${capability.key?html}" href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key /]">${capability.label?html}</a>
    [#else]
    ${capability.label?html}
    [/#if]
    [#if capability.extraInfo?has_content]
    <span class="subGrey">(${capability.extraInfo})</span>
    [/#if]
[/#macro]

[#-- ================================================================================ @agt.showRequirementOperations --]
[#-- Show requirement operations --]
[#macro showRequirementOperations requirement build returnUrl='']
    [#if !requirement.readonly]
        [#if !editRequirementJsAdded!(false)]
            [#assign editRequirementJsAdded=true /]
        <script type="text/javascript">
            var updateBuildRequirement = function (data)
            {
                window.location.reload(true);
            };
        </script>
            [@dj.simpleDialogForm width="592" triggerSelector=".edit-requirements" submitCallback="updateBuildRequirement"/]
        [/#if]

        [#assign editUrl='${req.contextPath}/build/admin/edit/editBuildRequirement.action?buildKey=${build.key}&requirementId=${requirement.id?url}' /]
        [#if returnUrl?has_content]
            [#assign editUrl='${editUrl}&amp;returnUrl=${returnUrl}' /]
        [/#if]
    <a href="${editUrl}" class="edit-requirements" title="[@ww.text name='agent.requirement.edit.description' /]">[@ww.text name='global.buttons.edit' /]</a>

        [#assign deleteUrl='${req.contextPath}/build/admin/edit/deleteBuildRequirement.action?buildKey=${build.key}&requirementId=${requirement.id?url}' /]
        [#if returnUrl != '']
            [#assign deleteUrl='${deleteUrl}&amp;returnUrl=${returnUrl}' /]
        [/#if]
    <a href="${deleteUrl}" class="requireConfirmation mutative" title="[@ww.text name='agent.requirement.delete.description'][@ww.param]${requirement.label}[/@ww.param][/@ww.text]">
        [@ww.text name='global.buttons.delete' /]
    </a>
    [/#if]
[/#macro]

[#-- ================================================================================ @agt.editRequirementForm --]
[#-- Show requirement operations --]
[#macro editRequirementForm requirement]
    [@ui.bambooSection]
        [@ww.hidden name='buildKey' value=immutablePlan.key /]
        [@ww.hidden name='requirementId' value=requirement /]
        [@ww.hidden name='existingRequirement' /]

        [@ww.label labelKey='requirement.add.requirement' name='existingRequirementName' /]

        [@ww.select name='requirementMatchType' toggle='true'
        list=matchTypeOptions listKey='name' listValue='label']
        [/@ww.select]

        [@ui.bambooSection dependsOn='requirementMatchType' showOn='equal']
            [@ww.textfield name='requirementMatchValue' /]
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='requirementMatchType' showOn='match']
            [@ww.textfield name='regexMatchValue' descriptionKey='requirement.add.regex.description'/]
        [/@ui.bambooSection]

    [/@ui.bambooSection]
[/#macro]
[#-- ================================================================================= @agt.showCapabilityOperations --]
[#--
    Show capability operations. show* flags determines if links will be attempted to be shown (may not actually appear
    depending on permissions or agent existance
--]
[#macro showCapabilityOperations capability agent='' elasticImageConfiguration='' showView=false showEdit=false showDelete=false returnAfterOpUrl='' capabilityName='']

    [#assign finalReturnUrl = returnAfterOpUrl/]
    [#if !finalReturnUrl?has_content]
        [#assign finalReturnUrl = currentUrl /]
    [/#if]

    [#if showView]
    <a id="view:${capability.key?html}" href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key /]">[@ww.text name='global.buttons.view' /]</a>
    [/#if]
    [#if fn.hasAdminPermission()]
        [#assign sharedCapabilityType = (capability.capabilitySet.sharedCapabilitySetType)!("") /]

        [#if sharedCapabilityType?has_content]
        [#-- Shared capability --]
            [#if showEdit && fn.hasGlobalAdminPermission()]
                [#if showView] | [/#if]
            <a id="edit:${capability.key?html}Shared${sharedCapabilityType}" href="[@ww.url action='editSharedCapability' namespace='/admin/agent' sharedCapabilitySetType=sharedCapabilityType capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
            [/#if]
            [#if showDelete && fn.hasGlobalAdminPermission()]
                [#if showEdit] | [/#if]
            <a id="delete:${capability.key?html}Shared${sharedCapabilityType}" href="[@ww.url action='deleteShared${sharedCapabilityType}Capability' namespace='/admin/agent' capabilityKey=capability.key returnUrl=finalReturnUrl /]" class="requireConfirmation mutative" title="[@ww.text name='agent.capability.delete.description'][@ww.param]'${capabilityName}'[/@ww.param][/@ww.text]">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]

        [#else]
        [#-- Image or agent capability --]
            [#if agent?has_content]
                [#if showEdit]
                    [#if showView] | [/#if]
                <a id="edit:${capability.key?html}From${agent.name?html}" href="[@ww.url action='editCapability' namespace='/admin/agent' agentId=agent.id capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
                [/#if]
                [#if showDelete]
                    [#if showEdit] | [/#if]
                <a id="delete:${capability.key?html}From${agent.name?html}"
                   href="[@ww.url action='deleteAgentCapability' namespace='/admin/agent' agentId=agent.id capabilityKey=capability.key returnUrl=finalReturnUrl /]"
                   class="mutative requireConfirmation"
                   title="[@ww.text name='agent.capability.delete.description'][@ww.param]${capabilityName}[/@ww.param][/@ww.text]">[@ww.text name='global.buttons.delete' /]</a>
                [/#if]
            [#elseif elasticImageConfiguration?has_content]
            [#-- Agent has not been found... may belong to an elastic image instead --]
                [#if showEdit]
                    [#if showView] | [/#if]
                <a id="edit:${capability.key?html}From${elasticImageConfiguration.id}" href="[@ww.url action='editElasticCapability' namespace='/admin/elastic' configurationId=elasticImageConfiguration.id capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
                [/#if]
                [#if showDelete]
                    [#if showEdit || showView] | [/#if]
                <a id="delete:${capability.key?html}From${elasticImageConfiguration.id}" href="[@ww.url action='deleteElasticCapability' namespace='/admin/elastic' configurationId=elasticImageConfiguration.id capabilityKey=capability.key returnUrl=finalReturnUrl /]" class="mutative requireConfirmation" title="[@ww.text name='agent.capability.delete.description'][@ww.param]${capabilityName}[/@ww.param][/@ww.text]">[@ww.text name='global.buttons.delete' /]</a>
                [/#if]
            [/#if]
        [/#if]
    [/#if]
[/#macro]
[#-- ======================================================================================= @agt.shoRequirementCell --]
[#-- Show requirement cell --]
[#macro shoRequirementCell  requirement]
<td class="valueCell" title="[@ww.text name='requirement.matchType.${requirement.matchType}.description' /]">
    [@ww.text name='requirement.matchType.${requirement.matchType}' /][#rt]
    [#if requirement.matchValue?has_content]
        <span>${requirement.matchValue!?html}</span>
    [/#if]
</td>
[/#macro]

[#-- ============================================================================== @agt.displayEditCapabilityFields --]
[#macro displayEditCapabilityFields]
    [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
    [@ww.label labelKey='agent.capability.type' value="${typeText}" /]
    [@ww.label labelKey='agent.capability.type.${capabilityType}.key' name='capability.label' /]
    [@ww.textfield labelKey='agent.capability.type.${capabilityType}.value' name='capabilityValue' /]
[/#macro]

[#-- ============================================================================== @agt.onlineAgents --]
[#macro onlineAgents showLogs=true showOperations=true name='']

[#-- Description at the top--]
    [#if onlineRemoteAgents?has_content]
        [#if numberOfOnlineRemoteAgents == 0]
            [@ww.text name='agent.remote.numberOnline.none'/]
        [#else]
            [#if elasticBambooEnabled]
                [#if numberOfOnlineElasticAgents != 0]
                    [#if numberOfOnlineRemoteAgents != numberOfOnlineElasticAgents]
                        [@ww.text name='${elasticEnabledTextKey}']
                            [@ww.param value=numberOfOnlineRemoteAgents /]
                            [@ww.param value=numberOfOnlineRemoteAgents - numberOfOnlineElasticAgents /]
                            [@ww.param value=numberOfOnlineElasticAgents /]
                            [@ww.param value=numberOfRequestedElasticAgents /]
                            [@ww.param value=allowedNumberOfRemoteAgents /]
                            [@ww.param]
                            <a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                            [@ww.param]</a>[/@ww.param]
                        [/@ww.text]
                    [#else]
                        [@ww.text name='${onlyElasticOnlineTextKey}']
                            [@ww.param value=numberOfOnlineRemoteAgents /]
                            [@ww.param value=numberOfRequestedElasticAgents /]
                            [@ww.param value=allowedNumberOfRemoteAgents /]
                            [@ww.param]
                            <a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                            [@ww.param]</a>[/@ww.param]
                        [/@ww.text]
                    [/#if]
                [#else]
                    [@ww.text name='${noElasticOnlineTextKey}']
                        [@ww.param value=numberOfOnlineRemoteAgents /]
                        [@ww.param value=numberOfRequestedElasticAgents /]
                        [@ww.param value=allowedNumberOfRemoteAgents /]
                        [@ww.param]
                        <a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                        [@ww.param]</a>[/@ww.param]
                    [/@ww.text]
                [/#if]
            [#else]
                [#if name?has_content]
                    [@ww.text name='agent.remote.numberOnline.matching']
                        [@ww.param value=numberOfOnlineRemoteAgents /]
                        [@ww.param]${name?html}[/@ww.param]
                    [/@ww.text]
                [#else]
                    [@ww.text name='agent.remote.numberOnline']
                        [@ww.param value=numberOfOnlineRemoteAgents /]
                    [/@ww.text]
                [/#if]
            [/#if]
        [/#if]
    [/#if]


[#--The Data Table--]
    [#if onlineRemoteAgents?has_content]
        [@ww.form action="configureAgents!reconfigure.action" id="remoteAgentConfiguration" theme="simple"]
            [#if showOperations]
            <hr>
                [@displayOperationsHeader agentType='RemoteOnline'/]
            [/#if]
        <table id="remote-agents" class="aui">
            <colgroup>
                [#if showOperations]
                    <col width="5"/>
                [/#if]
                <col/>
                <col width="185"/>
                [#if showOperations]
                    <col width="95"/>
                [/#if]
            </colgroup>
            <thead>
            <tr>
                [#if showOperations]
                    <th>&nbsp;</th>
                [/#if]
                <th>[@ww.text name='agent.table.heading.name' /]</th>
                <th>[@ww.text name='agent.table.heading.status' /]</th>
                [#if showOperations]
                    <th>[@ww.text name='agent.table.heading.operations' /]</th>
                [/#if]
            </tr>
            </thead>
            <tbody>
                [#foreach agent in onlineRemoteAgents]
                <tr class="agent${agent.agentStatus}">
                    [#if showOperations]
                        <td>
                            <input name="selectedAgents" type="checkbox" value="${agent.id}" class="selectorAgentType_RemoteOnline selectorAgentEnabled_${agent.enabled?string} selectorAgentStatus_${agent.agentStatus}">
                        </td>
                    [/#if]
                    <td>[@ui.renderAgentNameAdminLink agent/]</td>
                    <td class="agentStatus">[@agt.displayStatusCell agent=agent /]</td>
                    [#if showOperations]
                        <td valign="center">
                            [@agt.displayOperationsCell agent=agent /]
                        </td>
                    [/#if]
                </tr>
                [/#foreach]
            </tbody>
        </table>
        [/@ww.form]
    [#else]
        [#if name?has_content]
            [@ww.text name='agent.remote.noneMatching']
                [@ww.param]${name?html}[/@ww.param]
            [/@ww.text]
        [#else]
            [@ww.text name='agent.remote.none' /]
        [/#if]
    [/#if]

    [#if showLogs]
    [#--Live Remote Agent Logs--]
        [@dj.reloadPortlet id='remoteAgentsWidget' url='${req.contextPath}/ajax/viewRemoteAgentsLogSnippet.action' reloadEvery=10]
            [@ww.action name="viewRemoteAgentsLogSnippet" namespace="/ajax" executeResult="true"]
            [/@ww.action]
        [/@dj.reloadPortlet]
    [/#if]

[/#macro]

[#-- ============================================================================== @agt.offlineAgents --]
[#macro offlineAgents]
<div id="offlineAgentSection">
    [@ww.action name="viewOfflineRemoteAgents" namespace="/ajax" executeResult="true" /]
</div>
[/#macro]

[#-- ============================================================================== @agt.remoteAgentAuthentications --]
[#macro remoteAgentAuthentications]
<div id="remoteAgentAuthenticationSection">
    [@ww.action name="viewRemoteAgentAuthentications" namespace="/ajax" executeResult="true" /]
</div>
[/#macro]