[#-- @ftlvariable name="datetime" type="java.util.Date" --]
[#-- @ftlvariable name="stack" type="com.opensymphony.xwork2.util.OgnlValueStack" --]

[#-- =============================================================================================== @ui.bambooPanel --]
[#-- bambooPanel - this is used for display of input forms. --]
[#macro bambooPanel title='' titleKey='' description='' descriptionKey='' tools='' toolsContainer='div' auiToolbar='' cssClass='' content='' headerWeight='h2']

<div class="form-view[#if cssClass?has_content] ${cssClass}[/#if]">
    [#if title?has_content || titleKey?has_content]
        [#if tools?has_content]
            <${toolsContainer} class="floating-toolbar">
        ${tools}
        </${toolsContainer}>
        [/#if]
        [#if auiToolbar?has_content]
        <div class="aui-toolbar inline">${auiToolbar}</div>
        [/#if]
    <${headerWeight}[#if auiToolbar?has_content] class="has-aui-toolbar"[/#if]>[#rt]
        [#if title?has_content || titleKey?has_content]
        ${fn.resolveName(title, titleKey)}[#t]
        [/#if]
    </${headerWeight}>[#lt]
    [/#if]
    [#if description?has_content || descriptionKey?has_content]
    <p>${fn.resolveName(description, descriptionKey)}</p>
    [/#if]
    [#nested]
</div>

[/#macro]

[#-- ========================================================================================= @ui.bambooInfoDisplay --]
[#-- bambooInfoDisplay - similar to bambooPanel, but used only for display of info (no input) --]
[#macro bambooInfoDisplay id='' title='' titleKey='' tools='' toolsContainer='div' float=false height='' cssClass='' headerWeight='h3']
    <div class="form-view[#if float] floatingPanel[/#if][#if cssClass?has_content] ${cssClass}[/#if]"[#t]
    [#if height?has_content] style="min-height: ${height};"[/#if][#t]
    [#if id?has_content] id="${id}"[/#if]>[#t]
    [#if title?has_content || titleKey?has_content]
        [#if tools?has_content]
            <${toolsContainer} class="floating-toolbar">
        ${tools}
        </${toolsContainer}>
        [/#if]
    <${headerWeight}>${fn.resolveName(title, titleKey)}</${headerWeight}>[#lt]
    [/#if]

    [#nested]
    </div>
[/#macro]

[#-- ============================================================================================= @ui.bambooSection --]
[#macro bambooSection step=0 title='' titleKey='' description='' descriptionKey='' dependsOn='' showOn=true tools='' cssClass='' toolsContainer='div' sectionContainer='fieldset' id='' collapsible=false isCollapsed=true]
    [#if collapsible]
        [#local nested][#nested][/#local]
        [#if nested?contains('control-form-error')]
            [#local isCollapsed = false /]
        [/#if]
        [#local className = ('collapsible-section ' + isCollapsed?string('collapsed ', '') + cssClass)?trim]
    [#else]
        [#local className = cssClass]
    [/#if]
    [#local style = '']
    [#local foundAMatch = false]

    [#if dependsOn?has_content]
        [#local dependsOnValue = (stack.findValue(dependsOn).toString())!]
        [#local className]
            [#if className?has_content]${className} [/#if][#t]
        dependsOn${dependsOn} [#t]
            [#list showOn?string?trim?split(" ") as showOnValue]
            showOn${showOnValue} [#t]
                [#if !foundAMatch]
                    [#if dependsOnValue == showOnValue]
                        [#local style = '']
                        [#local foundAMatch = true]
                    [#elseif ("__" + dependsOnValue) == showOnValue]
                        [#local style = 'display: none;']
                        [#local foundAMatch = true]
                    [#else]
                        [#local style = 'display: none;']
                    [/#if]
                [/#if]
            [/#list]
        [/#local]
    [/#if]
    [#local summary]
        [#if step > 0 || title?has_content || titleKey?has_content]
            [#if collapsible && isCollapsed]
                [@ui.icon type="expand" text=i18n_globalButtonsExpand/]
            [#elseif collapsible]
                [@ui.icon type="collapse" text=i18n_globalButtonsCollapse/]
            [/#if]
            [#if tools?has_content]<${toolsContainer} class="floating-toolbar">${tools}</${toolsContainer}>[/#if]
            <h3[#if collapsible] class="collapsible-header" tabindex="0"[/#if]>[#t/]
                [#if step > 0]<em>${step}:</em>[/#if][#t/]
                [#if title?has_content || titleKey?has_content]${fn.resolveName(title, titleKey)}[/#if][#t/]
            </h3>[#lt/]
        [/#if]
    [/#local]

    <${sectionContainer}[#if id?has_content] id="${id?trim}"[/#if][#if className?has_content] class="${className?trim}"[/#if][#if style?has_content] style="${style?trim}"[/#if]>
    [#if summary?has_content]
        [#if collapsible]
        <div class="summary">
        ${summary}
        </div>
        [#else]
        ${summary}
        [/#if]
    [/#if]
    [#if description?has_content || descriptionKey?has_content]
        [@ui.displayText description descriptionKey /]
    [/#if]
    [#if collapsible]
    <div class="collapsible-details">
    ${nested!}
    </div>
    [#else]
        [#nested]
    [/#if]
    </${sectionContainer}>
[/#macro]

[#--deprecated since 4.3, instead use fn.resolveName--]
[#macro resolvedName text="" textKey=""]
    ${fn.resolveName(text, textKey)}[#t/]
[/#macro]

[#-- =============================================================================================== @ui.displayLink --]
[#macro displayLink href title="" titleKey="" icon='' iconPath='' id='' inList=false showText=true showIcon=true useIconFont=false accessKey='' requiresConfirmation=false isAsynchronous=false cssClass='' data='' mutative=false]
    [#assign linkClass][#rt/]
        [#if mutative]mutative [/#if]
        [#if inList]item-link [/#if][#t/]
        [#if requiresConfirmation]requireConfirmation [/#if][#t/]
        [#if isAsynchronous]asynchronous [/#if][#t/]
        [#if showIcon && !icon?has_content && !iconPath?has_content]iconless [/#if]
    [/#assign][#lt/]
    [#if inList]
    <li class="dropdown-item">[/#if][#t/]
    <a [#if !showText]title="${fn.resolveName(title, titleKey)}" [/#if]href="${href}"[#if data?has_content] ${data}[/#if] [#t/]
        [#if accessKey?has_content]accesskey="${accessKey}" [/#if][#t/]
        [#if id?has_content]id="${id}" [/#if][#t/]
        [#if linkClass?trim?has_content]class="${linkClass}[#if cssClass?trim?has_content] ${cssClass}[/#if]"[/#if][#t/]
            >[#t/]
            [#if showIcon][#if icon?has_content][@ui.icon type=icon useIconFont=useIconFont /][#elseif iconPath?has_content]<img src="${iconPath}"/> [/#if][/#if][#t/]
        [#if showText]
        ${fn.resolveName(title, titleKey)}[#t/]
        [/#if]
    </a>[#t/]
    [#if inList]</li>[/#if][#t/]
[/#macro]

[#-- =============================================================================================== @ui.displayLinkForAUIDialog --]
[#macro displayLinkForAUIDialog cssClass="" title="" titleKey="" icon='' id='' inList=false showText=true useIconFont=false showTitle=false accessKey='' href='']
    [#if inList]<li class="dropdown-item">[/#if][#t/]
    <a [#if !showText || showTitle]title="${fn.resolveName(title, titleKey)}" [/#if][#t/]
        [#if accessKey?has_content]accesskey="${accessKey}" [/#if][#t/]
        [#if id?has_content]id="${id}" [/#if][#t/]
        [#if href?has_content]href="${href}" [/#if][#t/]
        [#if inList || cssClass?has_content]class="[#if inList]item-link [/#if][#if cssClass?has_content]${cssClass}[/#if]" [/#if][#t/]
            >[#t/]
            [#if icon?has_content][@ui.icon type=icon useIconFont=useIconFont /][/#if][#t/]
            [#if showText]
    ${fn.resolveName(title, titleKey)}[#t/]
    [/#if]
    </a>[#t/]
    [#if inList]</li>[/#if][#t/]
[/#macro]


[#-- =============================================================================================== @ui.displayText --]
[#macro displayText text='' key='']
<div class="description">[#rt]
    [#if text?has_content || key?has_content ]
        ${fn.resolveName(text, key)}
    [/#if]
    [#nested]
</div>[#lt]
[/#macro]

[#-- ========================================================================================= @ui.displayFieldGroup --]
[#macro displayFieldGroup descriptionText='' descriptionKey='' descriptionContent='']
<div class="field-group">
    [#nested]
    [#if descriptionText?has_content || descriptionKey?has_content || descriptionContent?trim?has_content]
        <div class="description">
            [#if descriptionText?has_content || descriptionKey?has_content]
            ${fn.resolveName(descriptionText, descriptionKey)}
            [/#if]
            ${descriptionContent}
        </div>
    [/#if]
</div>
[/#macro]

[#-- ======================================================================================== @ui.displayDescription --]
[#macro displayDescription text='' key='']
    [#assign content][#nested][/#assign]
    [@displayFieldGroup descriptionText=text descriptionKey=key descriptionContent=content /]
[/#macro]

[#-- ==================================================================================== @ui.displayButtonContainer --]
[#macro displayButtonContainer secondary=false]
<div class="aui-toolbar2">
    <div class="aui-toolbar-2-inner">
        <div class="aui-toolbar2-${secondary?string('secondary', 'primary')}">
            <div class="aui-buttons">
                [#nested]
            </div>
        </div>
    </div>
</div>
[/#macro]

[#-- ============================================================================================= @ui.displayButton --]
[#macro displayButton id='' accesskey='' title='' value='' valueKey='' uri='']
[@compress single_line=true]
<input type="button" class="button"
        [#if id?has_content] id="${id}" [/#if]
        [#if accesskey?has_content] accesskey="${accesskey}" [/#if]
        [#if title?has_content] title="${title}" [/#if]
        [#if value?has_content] value="${value}" [/#if]
        [#if valueKey?has_content] value="[@ww.text name=valueKey /]" [/#if]
        [#if uri?has_content] onclick="location.href='${uri}'" [/#if]
/>[/@compress]
[/#macro]


[#-- ================================================================================================= @ui.commaList --]
[#macro commaList list]
    [#list list as item]
        ${item}[#if item_has_next], [/#if][#t]
    [/#list]
[/#macro]

[#-- ================================================================================================= @ui.barGraph--]
[#macro barGraph color width title]
<div title="${title}" style="background-color: ${color}; width: ${width}%; height: 5px; font-size: 5px;  /* IE hack */"></div>
[/#macro]

[#-- ================================================================================================= @ui.header--]
[#macro header object='' page='' pageKey='' description='' descriptionKey='' cssClass='' title=false showPlanSuspended=false headerElement='h1']
    [#assign headerText]
        [#if object?has_content]${object?html}: [/#if][#t]
        [#if page?has_content || pageKey?has_content]${fn.resolveName(page, pageKey)}[/#if][#t]
    [/#assign]

    [#if title]
        [#if headerText?trim?has_content]
        <title>${headerText?trim}</title>
        [/#if]
    [#else]
        [#if headerText?trim?has_content]
        <${headerElement}[#if cssClass?has_content] class="${cssClass}"[/#if]>${headerText?trim}</${headerElement}>[#t]
        [/#if]
        [#if description?has_content || descriptionKey?has_content]
            [@ui.displayText description descriptionKey /]
        [/#if]
    [/#if]
[/#macro]


[#-- ================================================================================= @ui.agentDedicatedLozenge --]
[#macro agentDedicatedLozenge subtle=false]
    [@ui.lozenge textKey="agent.dedicated" subtle=subtle/][#t]
[/#macro]
[#-- ================================================================================= @ui.renderAgentNameLink --]
[#--Please find equivalent soy methods in agent.soy--]
[#macro renderAgentNameLink agent dedicatedLozenge=false]
    [#if agent.definition.type.identifier == "elastic"]
        <span id="${agent.id}Elastic">
            [#if fn.hasAdminPermission()]
                <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action">
                    [@ui.icon type="elastic" text="(elastic)" /]
                </a>
            [#else]
                [@ui.icon type="elastic" text="(elastic)" /]
            [/#if]
        </span>
        [@dj.tooltip target='${agent.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>[#if dedicatedLozenge && agent.dedicated] [@ui.agentDedicatedLozenge subtle=true/][/#if][#t/]
[/#macro]

[#macro renderPipelineDefinitionNameLink definition]
    [#if definition.type.identifier == "elastic"]
        <span id="${agent.id}Elastic">
            [#if fn.hasAdminPermission()]
                <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action">
                    [@ui.icon type="elastic" text="(elastic)" /]
                </a>
            [#else]
                [@ui.icon type="elastic" text="(elastic)" /]
            [/#if]
        </span>
        [@dj.tooltip target='${definition.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/agent/viewAgent.action?agentId=${definition.id}">${definition.name?html}</a>[#t/]
[/#macro]

[#macro renderAgentNameAdminLink agent]
    [#if agent.definition.type.identifier == "elastic"]
        <span id="${agent.id}Elastic">
            [#if fn.hasAdminPermission()]
                <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action">
                    [@ui.icon type="elastic" text="(elastic)" /]
                </a>
            [#else]
                [@ui.icon type="elastic" text="(elastic)" /]
            [/#if]
        </span>
        [@dj.tooltip target='${agent.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/admin/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>[#if agent.dedicated] [@ui.agentDedicatedLozenge subtle=true/][/#if][#t/]
[/#macro]


[#-- ================================================================================= @ui.renderPlanNameLink --]
[#macro renderPlanNameLink plan]
    [#if fn.hasPlanPermission('READ', plan) ]
    [#-- if plan description is not empty render it as title --]
    <a [#if plan.description?has_content]
            title="${plan.description}"
    [#else]
            title="${plan.planKey.key}"
    [/#if]
            href="${req.contextPath}/browse/${plan.planKey.key}" [#if plan.suspendedFromBuilding] class="Suspended" [/#if]>${plan.name}</a>[#t]
    [#else]
    ${plan.name}[#t]
    [/#if]
[/#macro]

[#macro renderPlanConfigLink plan]
    <a title="${plan.key}" href="[@ww.url value='/browse/${plan.key}/config'/]">
    [#if plan.type=="JOB"]
    ${plan.parent.project.name} &rsaquo; ${plan.parent.buildName} &rsaquo; ${plan.buildName}[#t]
    [#else]
    ${plan.project.name} &rsaquo; ${plan.buildName}[#t]
    [/#if]</a>[#t]
[/#macro][#lt]

[#macro renderBuildResultSummary buildResultSummary='']
[#if buildResultSummary?has_content]
    <a title="${buildResultSummary.planResultKey} (${buildResultSummary.buildCompletedDate})" class="${buildResultSummary.buildState}" href="${req.contextPath}/browse/${buildResultSummary.planResultKey}">${buildResultSummary.planResultKey}</a>[#t]
[/#if]
[/#macro]

[#-- ================================================================================= @ui.renderEnvironmentNameLink --]
[#macro renderEnvironmentNameLink environmentRepositoryLink]
    [#assign environment=environmentRepositoryLink.environment/]
    [#assign project=action.getDeploymentProject(environment.id)/]
    [#assign projectName]
        [#if project.description?has_content]
            ${project.description}
        [#else]
            ${project.name}
        [/#if]
    [/#assign]
    [#assign envName]
        [#if environment.description?has_content]
            ${environment.description}
        [#else]
            ${environment.name}
        [/#if]
    [/#assign]

    [#if fn.hasEntityPermission('READ', environment) ]
        <a title="${project.name}-${environment.name}"
           href="${req.contextPath}/deploy/viewEnvironment.action?id=${environment.id}">${projectName} - ${envName}</a>[#t]
    [#else]
        ${projectName} - ${envName}[#t]
    [/#if]
[/#macro]


[#-- ================================================================================= @ui.renderValidJiraIssues --]

[#macro renderValidJiraIssues content buildResultSummary ]
    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(content?trim), buildResultSummary)?trim}[#t]
[/#macro]

[#macro renderValidJiraIssuesForDeploymentVersion content deploymentVersion ]
    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(content?trim), deploymentVersion)?trim}[#t]
[/#macro]

[#macro renderJiraIssues content]
    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(content?trim))?trim}[#t]
[/#macro]

[#-- ================================================================================================= @ui.clear --]
[#--
    DEPRECATED: If you use this come and see Jason to schedule your kneecapping
--]
[#macro clear]
<div class="clearer"></div>
[/#macro]
[#-- ================================================================================================= @ui.displayUserFullName --]
[#macro displayUserFullName user='']
[#if user?has_content]
    ${fn.getUserFullName(user)?html}[#t]
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayActualFullName --]
[#macro displayUserActualFullName user='']
    [#if user?has_content]
        [#if user.fullName?has_content]
        ${user.fullName?html}[#t]
        [/#if]
    [/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayUserGravatar --]
[#macro displayUserGravatar userName='' size='' class='' alt=''][#rt]
    [#assign defaultGravatar][@cp.getStaticResourcePrefix/]/images/icons/useravatar.png[/#assign]
    <img [#rt]
    [#if class?has_content]class="${class}" [/#if][#t]
        src="${ctx.getGravatarUrl(userName, size)!defaultGravatar}" [#t]
    [#if size?has_content]height="${size}" width="${size}" [/#if][#t]
    [#if alt?has_content]alt="${alt?html}" [/#if][#t]
        />[#lt]
[/#macro]
[#-- ================================================================================================= @ui.displayBambooAvatar --]
[#macro displayBambooAvatar size='' class='' alt=''][#rt]
    [#assign bambooAvatar][@cp.getStaticResourcePrefix/]/images/bamboo-icon-30.png[/#assign]
<img [#rt]
    [#if class?has_content]class="${class}" [/#if][#t]
        src="${bambooAvatar}" [#t]
    [#if size?has_content]height="${size}" width="${size}" [/#if][#t]
    [#if alt?has_content]alt="${alt?html}" [/#if][#t]
        />[#lt]
[/#macro]
[#-- ================================================================================================= @ui.displayAuthorAvatar --]
[#macro displayAuthorAvatarForCommit commit avatarSize='24'][#rt]
    [#assign altText][@ui.displayAuthorFullName author=commit.author /][#t][/#assign]
    [#if commit.author?has_content && ctx.isAuthorBambooServer(commit.author.name)]
        [@ui.displayBambooAvatar class="profileImage" size=avatarSize alt=altText/]
    [#else]
        [@ui.displayUserGravatar userName=(commit.author.linkedUserName)! size=avatarSize class="profileImage" alt=altText/]
    [/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayAuthorFullName --]
[#macro displayAuthorFullName author='']
[#if author?has_content]
    ${fn.getAuthorFullName(author)?html}[#t]
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayAuthorOrProfileLink --]
[#macro displayAuthorOrProfileLink author]
[@compress singleLine=true]
    [#if req?has_content]
        [#if author.linkedUserName?has_content]
        ${req.contextPath}/browse/user/${author.linkedUserName}
        [#else]
        ${req.contextPath}/browse/author/${author.getNameForUrl()}
        [/#if]
    [#elseif baseUrl?has_content]
        [#if author.linkedUserName?has_content]
        ${baseUrl}/browse/user/${author.linkedUserName}
        [#else]
        ${baseUrl}/browse/author/${author.getNameForUrl()}
        [/#if]
    [/#if]
[/@compress]
[/#macro]
[#-- ================================================================================================= @ui.displayRelativeDates --]
[#macro displayRelativeDates date='']
[#if date?has_content]
    <span title="${(date?datetime)!}">${durationUtils.getRelativeDate(date)}</span>
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayBuildHungDurationInfoHtml --]
[#macro displayBuildHungDurationInfoHtml buildTime averageTime buildHangDetails]
<br/>This build has been running for <strong>${durationUtils.getPrettyPrint(buildTime)}</strong>.[#t]
[#if buildTime > averageTime && averageTime > 0]
    [#assign _fraction=((durationUtils.getNormalizedTime(buildTime)-averageTime)*100/averageTime)?round]
    [#if _fraction > 0]
    This is <strong>${_fraction}%</strong> longer than usual.
    [/#if]
[/#if]
[#if buildHangDetails.lastLogTime != 0]
    <br/>It has been <strong>${durationUtils.getPrettyPrint(buildHangDetails.timeSinceLastLogTime)}</strong> since Bamboo received a log message for this build.
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayBuildHungDurationInfoText --]
[#macro displayBuildHungDurationInfoText buildTime='', averageTime='', buildHangDetails='']
This build has been running for ${durationUtils.getPrettyPrint(buildTime)}[#t]
[#if buildTime > averageTime && averageTime > 0]
[#assign _fraction=((durationUtils.getNormalizedTime(buildTime)-averageTime)*100/averageTime)?round]
[#if _fraction > 0]
, which is ${_fraction}% longer than usual[#t]
[/#if]
[/#if]
.
[#if buildHangDetails.lastLogTime != 0]
It has been ${durationUtils.getPrettyPrint(buildHangDetails.timeSinceLastLogTime)} since Bamboo received a log message for this build.
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayLogLines --]
[#macro displayLogLines buildLog]
[#if buildLog?has_content]
    <table id="buildLog">
        [#list buildLog as line]
            <tr>
                <td class="time">
                ${line.formattedDate}
                </td>
                <td[#if line.cssStyle??] class="${line.cssStyle}" [/#if]>${line.log}</td>
            </tr>
        [/#list]
    </table>
[/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayYesOrNo --]
[#macro displayYesOrNo displayBool]
[#if displayBool?string == 'true']
    [@ww.text name='global.common.yes' /]
[#else]
    [@ww.text name='global.common.no' /]
[/#if]
[/#macro]

[#-- ================================================================================================ @ui.displayJdk --]
[#macro displayJdk jdkLabel isJdkValid]
[@ww.label labelKey='builder.common.jdk' value=jdkLabel /]
[#if !isJdkValid]
    [@ui.messageBox type="warning"]
        [@ww.text name='builder.common.jdk.invalid' ]
            [@ww.param]${jdkLabel!}[/@ww.param]
        [/@ww.text]
        [#if fn.hasGlobalAdminPermission() ]
            [@ww.text name='builder.common.jdk.invalid.admin' ]
                [@ww.param]<a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action?capabilityType=jdk&jdkLabel=${jdkLabel!}">[/@ww.param]
                [@ww.param]</a>[/@ww.param]
            [/@ww.text]
        [/#if]
    [/@ui.messageBox]
[/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayAddJdkInline --]
[#macro displayAddJdkInline]
    [#if fn.hasGlobalAdminPermission()]
        [@ww.text id='addSharedJdkCapabilityTitle' name='builder.common.jdk.inline.heading' /]
        [@ww.url  id='addSharedJdkCapabilityUrl' value='/ajax/configureSharedJdkCapability.action' returnUrl=currentUrl /]
    <a class="addSharedJdkCapability" title="${addSharedJdkCapabilityTitle}" href="${addSharedJdkCapabilityUrl}">${addSharedJdkCapabilityTitle}</a>
    [/#if]
[/#macro]

[#-- =================================================================================== @ui.displayAddBuilderInline --]
[#macro displayAddExecutableInline executableKey=""]
    [#if fn.hasGlobalAdminPermission()]
        [@ww.text id='addSharedBuilderCapabilityTitle' name='builders.form.inline.heading' /]
        [@ww.url  id='addSharedBuilderCapabilityUrl' value='/ajax/configureSharedBuilderCapability.action?builderKey=${executableKey}' returnUrl=currentUrl/]
    <a class="addSharedBuilderCapability" title="${addSharedBuilderCapabilityTitle}" href="${addSharedBuilderCapabilityUrl}">${addSharedBuilderCapabilityTitle}</a>
    [/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayIdeIcon --]
[#macro displayIdeIcon]
    [#assign currUser = user /]
    [#assign port = bambooUserManager.getBambooUser(currUser).idePort /]
    <img src="http://localhost:${port}/icon" alt=""
        class="ideConnectorIcon"
        title="${action.getText('ideConnector.openBuild')}"
        onerror="this.width=1"
        onclick="this.src='http://localhost:${port}/build?build_key=${immutableBuild.key}&build_number=${buildNumber}&server_url=${baseUrl}&id=' + Math.floor(Math.random()*1000)"
        style="cursor: pointer">
[/#macro]

[#-- ====================================================================================================== @ui.icon --]
[#--
    Shows a span for an icon

    @requires type - a string containing the icon type (eg. "failed") which will be prefixed with "icon-"
    @optional text/textKey - a string or i18n key to be inserted inside the icon span, which will be hidden using CSS
    @optional showTitle - a boolean indicating whether the title attribute should be added to the icon
    @optional useIconFont - a boolean indicating whether to use the AUI icon font
--]
[#macro icon type text="" textKey="" showTitle=true useIconFont=false]
[#if useIconFont]${soy.render("aui.icons.icon", {
    "icon": type,
    "useIconFont": true,
    "accessibilityText": fn.resolveName(text, textKey),
    "extraAttributes": (showTitle && (text?has_content || textKey?has_content))?string('title="' + fn.resolveName(text, textKey) + '"', "")
})}[#else][#t]${soy.render("widget.icons.icon", {
    "type": type,
    "text": fn.resolveName(text, textKey),
    "showTitle": showTitle
})}[/#if][#t]
[/#macro]

[#-- =================================================================================================== @ui.lozenge --]
[#--
    Shows a span for a lozenge, see https://extranet.atlassian.com/display/AUI/Lozenge+Guide for more information

    @requires colour - a string containing the lozegne Colour Name, these are:
      "default" <-- grayish
      "success" <-- green
      "error"   <-- red
      "current" <-- yellow
      "complete"<-- blue
      "moved"   <-- brown
    @optional text/textKey - a string or i18n key to be inserted inside the lozenge span
    @optional showTitle - a boolean indicating whether the title attribute should be added to the lozenge
    @optional subtle - a boolean indicating whether to use the subtle styling or not
--]
[#macro lozenge colour="default" text="" textKey="" showTitle=true subtle=false]
${soy.render("widget.lozenges.lozenge", {
"colour": colour,
"text": fn.resolveName(text, textKey),
"showTitle": showTitle,
"subtle": subtle
})}[#t]
[/#macro]

[#-- ============================================================================================= @ui.branchLozenge --]
[#macro branchLozenge planBranchName label="" cssClass=""]
${soy.render("widget.lozenges.branch", {
"planBranchName": planBranchName,
"label": label,
"cssClass": cssClass
})}[#t]
[/#macro]

[#-- ================================================================================================ @ui.messageBox --]
[#macro messageBox id="" type="info" title="" titleKey="" content="" cssClass="" closeable=false icon=true hidden=false]
    [#assign class="aui-message " + type /]
    [#if closeable]
        [#assign class = class + " closeable"]
    [/#if]
    [#if cssClass?has_content]
        [#assign class = class + " " + cssClass]
    [/#if]
    <div [#if id?has_content]id="${id}"[/#if] class="${class}"[#if hidden] style="display: none;"[/#if]>
    [#if titleKey?has_content || title?has_content]
        <p class="title">
            [#if icon]<span class="aui-icon icon-${type}"></span>[/#if]
            <strong>${fn.resolveName(title, titleKey)}</strong>
        </p>
        [#if content?has_content]${content}[/#if]
        [#nested /]
    [#else]
        [#if content?has_content]${content}[/#if]
        [#nested /]
        [#if icon]<span class="aui-icon icon-${type}"></span>[/#if]
    [/#if]
    </div>
[/#macro]

[#-- ====================================================================================================== @ui.standardMenu --]
[#--
    Display a menu in Bamboo.  Does not allow grouping of attributes.  Nested should be a bunch of <li>'s to be displayed in the menu

    @requires triggerText - a string/title of the drop down
    @requires id - a unique id for the drop down.
--]
[#macro standardMenu triggerText id triggerId="" cssClass="" icon="" useIconFont=false disabled=false triggerBeforeDropdown=true subtle=false compact=false iconOnly=false]
    [@groupedMenu triggerText=triggerText id=id triggerId=triggerId cssClass=cssClass icon=icon useIconFont=useIconFont disabled=disabled triggerBeforeDropdown=triggerBeforeDropdown subtle=subtle compact=compact iconOnly=iconOnly]
    <ul>
        [#nested]
    </ul>
[/@groupedMenu]
[/#macro]

[#-- ====================================================================================================== @ui.standardMenu --]
[#--
    Display a menu in Bamboo that contains grouped elements.  Nested should be a bunch of <div class="aui-dropdown2-section"> with a <ul> under each, one for each group of items.

    @requires triggerText - a string/title of the drop down
    @requires id - a unique id for the drop down.
--]
[#macro groupedMenu triggerText id triggerId="" cssClass="" icon="" useIconFont=false disabled=false triggerBeforeDropdown=true subtle=false compact=false iconOnly=false]
    [#local trigger]
        <button class="aui-button aui-dropdown2-trigger[#if subtle] aui-button-subtle[/#if][#if compact] aui-button-compact[/#if]" aria-owns="${id}" aria-haspopup="true"[#if disabled] aria-disabled="true"[/#if][#if triggerId?has_content] id="${triggerId}"[/#if]>[#rt]
            [#if icon?has_content]
                [@ui.icon type=icon useIconFont=useIconFont text=iconOnly?string(triggerText, "") /] [#t]
            [/#if]
            [#if !iconOnly]
                ${triggerText}[#t]
            [/#if]
        </button>[#lt]
    [/#local]
    [#if triggerBeforeDropdown]${trigger}[/#if]
    <div class="aui-dropdown2 aui-style-default[#if cssClass?has_content] ${cssClass}[/#if]" id="${id}">[#nested]</div>
    [#if !triggerBeforeDropdown]${trigger}[/#if]
[/#macro]

[#-- ====================================================================================================== @ui.time --]
[#--
    Provides a consistent formatting for the <time> element

    @requires datetime - datetime object
    @optional cssClass - class to add to the time element
    @optional showTitle - @deprecated, doesn't do anything
    @optional relative - boolean indicating whether to show the date relative to "now"
    @optional format - 'short' or 'long' - non-relative dates can also use 'full'
--]
[#macro time datetime cssClass='' showTitle=false relative=false format='']
[#local nested][#nested][/#local][#t]
[#if soy??]
        [#if nested?has_content]
            [#t]${soy.render("bamboo.widget.time.time", {
                "datetime": datetime,
                "content": nested,
                "extraClasses": cssClass
                })}[#t]
        [#else]
            [#t]${soy.render(relative?string("bamboo.widget.time.relative", "bamboo.widget.time.timestamp"), {
                "datetime": datetime,
                "format": format,
                "extraClasses": cssClass
        })}[#t]
        [/#if]
[#else]
    <time datetime="${datetime?string("yyyy-MM-dd'T'HH:mm:ssZ")}" title="${datetime?string(action.getText('bamboo.date.format.full'))}"[#if cssClass?has_content] class="${cssClass}"[/#if]>[#nested]</time>[#t]
[/#if]
[/#macro]
[#-- =========================================================================================== @ui.renderWebPanels --]

[#macro renderWebPanels location]
    [#list ctx.getWebPanels(location) as webpanel]
    ${webpanel}
    [/#list]
[/#macro]

[#-- ================================================================================================= @ui.itemCount --]
[#-- Provides a little box with a number in it.--]
[#macro itemCount count]
<span class="item-count">${count}</span>
[/#macro]

[#-- =========================================================================================== @ui.copyToClipboard --]
[#-- A flash widget to copy to clipboard.  Parameters text, font, fontSize, copyMessage, copyCompleteMessage         --]
[#-- For example: text=toCopy&font=Arial&fontSize=11&copyMessage=copy!&copyCompleteMessage=done.                     --]
[#-- The defaults are nothing for text, copyMessage=copy, copyCompleteMessage=copied, font=Arial, fontSize=10        --]
[#-- The default AUI icon used is 16 x 16.                                                                           --]
[#macro copyToClipboard text="" width="90" height="20" copyMessage="copy" copyCompleteMessage="copied."]
    [#if text?has_content]
    <span class="copy-clipboard">
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="55" height="${height}" id="clippy-${text}">
        <param name="movie" value="[@cp.getStaticResourcePrefix/]/flash/clippy.swf"/>
        <param name="allowScriptAccess" value="always"/>
        <param name="quality" value="high"/>
        <param name="scale" value="noscale"/>
        <param NAME="FlashVars" value="text=${text}">
        <embed src="[@cp.getStaticResourcePrefix/]/flash/clippy.swf"
                width="${width}" height="${height}" name="clippy-${text}" quality="high" allowScriptAccess="always"
                type="application/x-shockwave-flash" width="${width}" height="${height}"
                pluginspage="http://www.macromedia.com/go/getflashplayer"
                FlashVars="text=${text}&copyMessage=${copyMessage}&copyCompleteMessage=${copyCompleteMessage}&fontSize=13"/>
    </object>
    </span>
    [/#if]
[/#macro]

[#macro actionwarning]
    [#if action.hasActionWarnings() ]
        [@ui.messageBox type='warning']
            [#if actionWarnings.size() == 1 ]
            <p>${formattedActionWarnings.iterator().next()}</p>
            [#else ]
            <ul>
                [#list formattedActionWarnings as warning]
                    <li>${warning}</li>
                [/#list]
            </ul>
            [/#if]
        [/@ui.messageBox]
    [/#if]
[/#macro]

[#-- ================================================================================================= @ui.planLink --]
[#--
    Generates standardized plan link

    @requires plan - plan for which link has to be generated
--]
[#macro planLink plan]
[#-- @ftlvariable name="plan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
    [#if plan.hasMaster()]
        <a href="[@ww.url value='/browse/${plan.planKey.key}'/]">${plan.project.name} &rsaquo; ${plan.master.buildName} &rsaquo; [@ui.icon type="devtools-branch" useIconFont=true /] ${plan.buildName}</a>
    [#else ]
        <a href="[@ww.url value='/browse/${plan.planKey.key}'/]">${plan.project.name} &rsaquo; ${plan.buildName}</a>
    [/#if]
[/#macro]