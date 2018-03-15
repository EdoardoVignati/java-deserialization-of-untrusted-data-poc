[#macro showAgentNumbers executableAgentMatrix elasticBambooEnabled i18nSuffix viewAgentsUrl viewImagesUrl editRequirementsUrl]
<span id="agentAvailabilityDescription">
    [#assign buildAgents=executableAgentMatrix.buildAgents /]
    [#assign imageMatches=executableAgentMatrix.imageMatches /]
    [#if buildAgents?has_content]
        <span id="executableAgentsText">[#rt]
            [@ww.text name='requirement.executableAgents.short.descriptionValue' ]
            [@ww.param name="value" value="${buildAgents.size()}"/]
        [/@ww.text][#t]
        </span>[#lt]
        [@dj.tooltip target="executableAgentsText" addMarker=true url=viewAgentsUrl /]
    [#else]
        [#if !elasticBambooEnabled || !imageMatches?has_content ]
            <span class="errorText">[@ww.text name='requirement.executableAgents.empty.${i18nSuffix}' /]</span>
        [/#if]
    [/#if]
    [#if elasticBambooEnabled && imageMatches?has_content ]
        [#if buildAgents?has_content]
            <span>[#rt]
                [@ww.text name="requirement.executableImages.short.descriptionText" /][#t]
            </span>[#lt]
        [/#if]
        <span id="executableImageText">[#rt]
            [@ww.text name="requirement.executableImages.short.descriptionValue" ]
            [@ww.param name="value" value="${imageMatches.size()}"/]
        [/@ww.text][#t]
        </span>[#lt]
        [@dj.tooltip target="executableImageText" addMarker=true url=viewImagesUrl /]
    [/#if]
    [#if buildAgents?has_content || imageMatches?has_content]
        [@ww.text name='requirement.executableAgents.short.description.${i18nSuffix}' ]
            [@ww.param name="value" value="${buildAgents.size() + imageMatches.size()}"/]
            [@ww.param]
                [#if editRequirementsUrl?has_content]
                    <a href="${editRequirementsUrl}">
                        [@ww.text name="requirement.executableAgents.short.capabilities" /]
                    </a>
                [#else]
                    [@ww.text name="requirement.executableAgents.short.capabilities" /]
                [/#if]
            [/@ww.param]
        [/@ww.text]
    [/#if]
</span>
[/#macro]

[#--Requires action.sortMatchingAgents Method--]
[#macro showMatchingAgents executableAgentsMatrix i18nSuffix viewAgentsUrl]
    [#if executableAgentsMatrix?has_content]
        <p>[@ww.text name='requirement.executableAgents.tooltip.${i18nSuffix}'/]:</p>
        <ul>
            [#assign matchingAgents = executableAgentsMatrix.buildAgents /]
            [#list action.sortMatchingAgents(matchingAgents) as agent]
                [#if agent_index == 5]
                    [#break]
                [/#if]
                <li><a href="${viewAgentsUrl}">
                ${agent.name?html}</a>
                    [#if !agent.active]
                        <span class="subGrey">([@ww.text name='agent.status.offline' /])</span>
                    [#elseif !agent.enabled]
                        <span class="subGrey">([@ww.text name='agent.status.disabled' /])</span>
                    [/#if]
                </li>
            [/#list]
        </ul>
        [#if executableAgentsMatrix.buildAgents.size() > 5]
            <div class="moreExecutableAgents">
                <a href="${viewAgentsUrl}">More&hellip;</a>
            </div>
        [/#if]
    [/#if]
[/#macro]

[#macro showMatchingImages executableAgentsMatrix i18nSuffix]
    [#if executableAgentsMatrix?has_content]
        <p>[@ww.text name='requirement.executableImages.tooltip.${i18nSuffix}'/]:</p>
        <ul>
            [#list executableAgentsMatrix.imageMatches as image]
                <li>
                    [#if fn.hasGlobalAdminPermission()]
                    <a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId='${image.id}' /]">[/#if]
                        ${image.amiId?html} (${image.configurationName?html})
                    [#if fn.hasGlobalAdminPermission()]</a>[/#if]
                </li>
            [/#list]
        </ul>
    [/#if]
[/#macro]