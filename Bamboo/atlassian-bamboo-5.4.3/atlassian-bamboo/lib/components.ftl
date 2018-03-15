[#-- @ftlvariable name="ctx" type="com.atlassian.bamboo.ww2.FreemarkerContext" --]
[#-- @ftlvariable name="buildResultsSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]

[#-- ========================================================================================= @cp.displayJiraIssuesSummary --]
[#-- Displays a summary of JIRA Issues. --]
[#macro displayJiraIssuesSummary buildResultsSummary maxIssues=5 ]
    [#import '../plugins/jira-plugin/viewJiraIssueComponents.ftl' as jiraComponents /]

    [#if jiraApplicationLinkDefined!false]
        [@jiraComponents.jiraIssueSummaryHolder resultsSummary=buildResultsSummary maxIssues=maxIssues/]
    [#else]
        [@jiraComponents.jiraMissingApplinkInfo /]
    [/#if]
[/#macro]

[#-- ================================================================================ @cp.oAuthAuthenticationRequest --]

[#macro oauthAuthenticationRequest authenticationUrl authenticationInstanceName='']
    [#if !authenticationInstanceName?has_content]
        [#assign jiraName][@ww.text name="jira.title"/][/#assign]
    [#else]
        [#assign jiraName]${authenticationInstanceName}[/#assign]
    [/#if]

    [@ui.messageBox type="info"]
    <p>[@ww.text name="oauth.authentication.request.explanation"][@ww.param]${jiraName}[/@ww.param][/@ww.text]</p>
    <a class="oauth-approve" href="${authenticationUrl}">[@ww.text name="oauth.authentication.title"/]</a>
    [/@ui.messageBox]
[/#macro]


[#-- ================================================================================== @cp.displayAuthorSummary --]

[#macro displayAuthorSummary author]
    [@ui.bambooInfoDisplay titleKey='Builds triggered by ${author.name?html}' height='300px' cssClass='authorSummary']
        [@ui.displayText]
        Builds triggered by an author are those builds which contains changes committed by the author.
        [/@ui.displayText]

        [@ww.label labelKey='author.summary.all.builds.triggered' name='author.numberOfTriggeredBuilds'/]

        [#if author.numberOfTriggeredBuilds gt 0]
            [#assign failedPercent=author.numberOfFailedBuilds / author.numberOfTriggeredBuilds]
            [#assign successPercent=author.numberOfSuccessfulBuilds / author.numberOfTriggeredBuilds]
        [#else]
            [#assign failedPercent=0 /]
            [#assign successPercent=0 /]
        [/#if]

        [@ww.label labelKey='build.common.fail' value='${author.numberOfFailedBuilds} (${failedPercent?string.percent})' /]
        [@ww.label labelKey='build.common.successful' value='${author.numberOfSuccessfulBuilds} (${successPercent?string.percent}) ' /]
    [/@ui.bambooInfoDisplay]
    [@ui.bambooInfoDisplay titleKey='author.summary.breakages.and.fixes' height='300px' cssClass='authorSummary']
        [@ui.displayText]
        <i>Broken</i> means the build has failed but the previous build was successful.<br/>
        <i>Fixed</i> means that the build was successful but the previous build has failed.
        [/@ui.displayText]

        [#if author.numberOfTriggeredBuilds gt 0]
            [#assign breakagePercent=author.numberOfBreakages / author.numberOfTriggeredBuilds]
            [#assign fixesPercent=author.numberOfFixes / author.numberOfTriggeredBuilds]
        [#else]
            [#assign breakagePercent=0 /]
            [#assign fixesPercent=0 /]
        [/#if]


        [@ww.label labelKey='author.summary.broken.by.author']
            [@ww.param name='value' ]
                [@ww.text name='author.summary.of.all.builds.triggered']
                    [@ww.param]${author.numberOfBreakages}[/@ww.param]
                    [@ww.param]${breakagePercent?string.percent}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.label]
        [@ww.label labelKey='author.summary.fixed.by.author']
            [@ww.param name='value' ]
                [@ww.text name='author.summary.of.all.builds.triggered']
                    [@ww.param]${author.numberOfFixes}[/@ww.param]
                    [@ww.param]${fixesPercent?string.percent}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.label]

        [#assign difference=author.numberOfFixes - author.numberOfBreakages /]

        [#if difference > 0]
            [#assign textColour='Successful' /]
        [#else]
            [#assign textColour='Failed' /]
        [/#if]
        [@ww.label labelKey='author.summary.difference.of.fixes.and.breaks' name='author.numberOfFixes - author.numberOfBreakages' cssClass='${textColour}' /]
    [/@ui.bambooInfoDisplay]
<div class="clearer"></div>
[/#macro]

[#-- ================================================================================ @cp.displayAuthorOrProfileLink --]

[#macro displayAuthorOrProfileLink author]
    [@compress singleLine=true]
        [#if author.linkedUserName?has_content]
            [@ww.url id='profileUrl'
            value='/browse/user/${author.linkedUserName}' /]
        ${profileUrl}
        [#else]
            [@ww.url id='authorUrl'
            value='/browse/author/${author.getNameForUrl()}' /]
        ${authorUrl}
        [/#if]
    [/@compress]
[/#macro]

[#-- ================================================================================ @cp.displayNotificationWarnings --]
[#macro displayNotificationWarnings messageKey='' addServerKey='' cssClass='info'  allowInlineEdit=false id='' hidden=false]
    [#if allowInlineEdit]
        [@dj.simpleDialogForm
        triggerSelector=".addInstantMessagingServerInline"
        actionUrl="/ajax/configureInstantMessagingServerInline.action?returnUrl=${currentUrl?url}"
        width=800
        height=415
        submitLabelKey="global.buttons.update"
        submitMode="ajax"
        submitCallback="function() {window.location.reload();}"
        /]
        [@dj.simpleDialogForm
        triggerSelector=".addMailServerInline"
        actionUrl="/ajax/configureMailServerInline.action?returnUrl=${currentUrl?url}"
        width=860
        height=540
        submitLabelKey="global.buttons.update"
        submitMode="ajax"
        submitCallback="function() {window.location.reload();}"
        /]
    [/#if]
    [#if messageKey?has_content]
        [#assign notificationWarningMsg][#rt]
            [@ww.text name=messageKey]
                [@ww.param name="value"]<a href="${req.contextPath}/profile/userProfile.action">[/@ww.param]
                [@ww.param name="value"]</a>[/@ww.param]
            [/@ww.text][#t]
            [#if fn.hasAdminPermission()][#lt]<br/> <span>[#rt]
                [@ww.text name=addServerKey]
                    [@ww.param name="value"]
                    <a class="addMailServerInline" title="${action.getText('config.email.title')}">[/@ww.param]
                    [@ww.param name="value"]
                    <a class="addInstantMessagingServerInline" title="${action.getText('instantMessagingServer.admin.add')}">[/@ww.param]
                    [@ww.param name="value"]</a>[/@ww.param]
                [/@ww.text]</span>[#t]
            [/#if]
        [/#assign][#lt]
        [@ui.messageBox type=cssClass id=id hidden=hidden]${notificationWarningMsg}[/@ui.messageBox]
    [/#if]
[/#macro]

[#-- ============================================================================================= @cp.favouriteIcon --]
[#macro favouriteIcon plan operationsReturnUrl user='']
    [#if user?has_content && plan.type != 'JOB']
        [@compress single_line=true]

            [#assign isFavourite = action.isFavourite(plan)]
            [@ww.url id='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]
            [#if isFavourite ]
            <a href="${setFavouriteUrl}" class="internalLink mutative" id="toggleFavourite_${plan.key}">[@ui.icon type="favourite-remove" text="Remove this plan from your favourites" /]</a>
            [#else]
            <a href="${setFavouriteUrl}" class="internalLink mutative" id="toggleFavourite_${plan.key}">[@ui.icon type="favourite" text="Add this plan to your favourites" /]</a>
            [/#if]

        [/@compress]
    [/#if]
[/#macro]

[#-- ============================================================================================= @cp.dashboardFavouriteIcon --]
[#macro dashboardFavouriteIcon plan operationsReturnUrl user='']
    [#if user?has_content]
        [@compress single_line=true]
            [#assign isFavourite = action.isFavourite(plan)]
            [@ww.url id='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]

            [#assign planI18nPrefix = fn.getPlanI18nKeyPrefix(plan)/]
            [#if isFavourite]
            <a class="unmarkBuildFavourite usePostMethod" id="toggleFavourite_${plan.key}" href="${setFavouriteUrl}" data-plan-key="${plan.key}" title="[@ww.text name=planI18nPrefix+'.favourite.off'/]">[@ui.icon type="favourite-remove" textKey='build.favourite'/]</a>
            [#else]
            <a class="markBuildFavourite usePostMethod" id="toggleFavourite_${plan.key}" href="${setFavouriteUrl}" data-plan-key="${plan.key}" title="[@ww.text name=planI18nPrefix+'.favourite.on'/]">[@ui.icon type="favourite" textKey='build.favourite'/]</a>
            [/#if]

        [/@compress]
    [/#if]
[/#macro]

[#-- ==================================================================================== @cp.currentBuildStatusIcon --]
[#macro currentBuildStatusIcon build id='' classes='' showLink=true]
    [@compress single_line=true]
        [#if showLink]
                <a [#if id?has_content]
                id="${id}" [#t]
        [/#if]
            [#if classes?has_content]
                    class="${classes}" [#t]
            [#elseif build.active]
                    class="${build.key}_active" [#t]
            [/#if]
            [#assign lastResult=build.lastResultKey!]
            [#if lastResult?has_content]
                    href="${req.contextPath}/browse/${lastResult.key}">[#t/]
            [#else]
                href="${req.contextPath}/browse/${build.key}">[#t/]
            [/#if]
        [/#if]
        [#assign latestResultsSummary=build.latestResultsSummary! /]

        [#if build.suspendedFromBuilding]
            [@ui.icon type="disabled" text="Plan Disabled" /][#t/]
        [#elseif build.active && build.isExecuting()]
            [@ui.icon type="building" text="Build in progress" /][#t/]
        [#elseif build.active]
            [@ui.icon type="queued" text="Build queued" /][#t/]
        [#elseif build.isBusy?exists && build.isBusy()]
            [@ui.icon type="sync" text="Checking out source code" /][#t/]
        [#elseif latestResultsSummary?has_content ]
            [#if latestResultsSummary.continuable]
                [@ui.icon type="successfulpartial" text="Last build stopped at manual stage" /][#t/]
            [#elseif latestResultsSummary.successful]
                [@ui.icon type="successful" text="Last build was successful" /][#t/]
            [#elseif latestResultsSummary.failed]
                [@ui.icon type="failed" text="The last build failed" /][#t/]
            [#elseif latestResultsSummary.notBuilt]
                [@ui.icon type="notbuilt" text="The last build was not built" /][#t/]
            [/#if]
        [#else]
            [@ui.icon type="disabled" text="No build history" /][#t/]
        [/#if]
        [#if showLink]
        </a>[#t/]
        [/#if]
    [/@compress]
[/#macro]

[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro resultsSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro buildResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.chainResultsSubMenu --]
[#macro chainResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.buildSubMenu --]
[#macro buildSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.chainSubMenu --]
[#macro chainSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.editPlanConfigurationTabs --]
[#macro editPlanConfigurationTabs build formId selectedTab='build.details' location="planConfiguration.subMenu"]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]planConfig[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]

[#-- ========================================================================-===================== @cp.profileSubMenu --]
[#macro profileSubMenu selectedTab='personalDetails']
    [#import "menus.ftl" as menu/]
    [@menu.displayTabbedContent location="system.user" selectedTab=selectedTab admin=true]
        [#nested /]
    [/@menu.displayTabbedContent]
[/#macro]

[#-- ================================================================================================ @cp.pagination --]
[#macro pagination ]
<ul class="pager">
    [#if pager.hasPreviousPage]
        <li>
            <a href="${req.contextPath}${pager.firstPageUrl}" class="firstLink"><img src="[@ww.url value='/images/build_nav_arrow_first.gif' /]" alt="First"/></a>
        </li>
        <li>
            <a href="${req.contextPath}${pager.previousPageUrl}" class="previousLink" accesskey="P"><img src="[@ww.url value='/images/build_nav_arrow_left.gif' /]" alt="Previous"/></a>
        </li>
    [#else]
        <li><span class="firstLink"><img src="[@ww.url value='/images/build_nav_arrow_first_grey.gif' /]" alt="First"/></span>
        </li>
        <li>
            <span class="previousLink"><img src="[@ww.url value='/images/build_nav_arrow_left_grey.gif' /]" alt="Previous"/></span>
        </li>
    [/#if]
    <li class="label">Showing ${pager.page.startIndex + 1}-${pager.page.endIndex} of ${pager.totalSize}</li>
    [#if pager.hasNextPage]
        <li>
            <a href="${req.contextPath}${pager.nextPageUrl}" class="nextLink" accesskey="N"><img src="[@ww.url value='/images/build_nav_arrow_right.gif' /]" alt="Next"/></a>
        </li>
        <li>
            <a href="${req.contextPath}${pager.lastPageUrl}" class="lastLink"><img src="[@ww.url value='/images/build_nav_arrow_last.gif' /]" alt="Last"/></a>
        </li>
    [#else]
        <li>
            <span class="nextLink"><img src="[@ww.url value='/images/build_nav_arrow_right_grey.gif' /]" alt="Next"/></span>
        </li>
        <li>
            <span class="lastLink"><img src="[@ww.url value='/images/build_nav_arrow_last_grey.gif' /]" alt="Last"/></span>
        </li>
    [/#if]
</ul>
[/#macro]

[#-- ========================================================================-===================== @cp.commentIndicatorAsText --]
[#--used for jira bamboo plugin--]
[#macro commentIndicatorAsText buildResultsSummary]
    [#if buildResultsSummary.comments?has_content]
        [@ww.url id='commentUrl'  value="/browse/${buildResultsSummary.planResultKey}" /]

    <a id="comment:${buildResultsSummary.planResultKey}" href="${commentUrl}">
        [@ww.text name='buildResult.comment.count' ]
                [@ww.param name="value" value="${buildResultsSummary.comments.size()}"/]
            [/@ww.text]
    </a>
    [/#if]
[/#macro]

[#-- ========================================================================================== @cp.commentIndicator --]
[#macro commentIndicator resultsSummary]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ImmutableResultsSummary" --]
    [#if resultsSummary.hasComments()]
        [@ww.url id='commentUrl'  value="/browse/${resultsSummary.planResultKey}" /]

        [#assign commentId = "comment_${resultsSummary.planResultKey}" /]
        <a id="${commentId}" href="${commentUrl}">[@ui.icon type="comment" useIconFont=true text="Commented" /]</a>
        <script type="text/javascript">
            AJS.$(function () {
                initCommentTooltip("${commentId}", "${resultsSummary.planKey}", "${resultsSummary.buildNumber}")
            });
        </script>
    [/#if]
[/#macro]


[#-- ======================================================================================== @cp.getStaticResourcePrefix --]
[#macro getStaticResourcePrefix]
${staticResourcePrefix!req.contextPath}[#t]
[/#macro]

[#-- ======================================================================================== @cp.toggleDisplayByGroup --]
[#macro toggleDisplayByGroup toggleGroup_id jsRestore=true]
<script type="text/javascript">
    AJS.$("#${toggleGroup_id}_toggler_on").bind("click", function ()
    {
        toggleOff(null, '${toggleGroup_id}');
    });
    AJS.$("#${toggleGroup_id}_toggler_off").bind("click", function ()
    {
        toggleOn(null, '${toggleGroup_id}');
    });

        [#if jsRestore]
        AJS.$("#${toggleGroup_id}_target").ready(function ()
                                                 {
                                                     restoreTogglesFromCookie('${toggleGroup_id}');
                                                 });
        [/#if]
</script>
[/#macro]


[#-- ======================================================================================== @cp.entityPagination --]
[#--
    Shows pagination links for Users and Group browsers.

    @requires actionUrl - the url to post back to for the page numbers
    @requires paginagionSupport - paginationSupport object
--]

[#macro entityPagination actionUrl paginationSupport ]
    [#assign sanitizedActionUrl=fn.sanitizeUri(actionUrl)/]
<div>
    <ul class="pager">

        [#assign previousIndexes=paginationSupport.previousStartIndexes?if_exists /]
        [#assign nextIndexes=paginationSupport.getNextStartIndexes()?if_exists /]

        [#if paginationSupport.items?has_content]
            [#assign startIndex=paginationSupport.startIndex + 1 /]
            [#assign endIndex=paginationSupport.endIndex /]
        [/#if]

        [#if previousIndexes?has_content || nextIndexes?has_content]
            [#assign currentIndex=0]

            [#if previousIndexes?has_content]
                <li>
                    <a href="${sanitizedActionUrl}startIndex=${paginationSupport.previousIndex}" class="previousLink" title="Previous">Previous</a>
                </li>

                [#if previousIndexes?size gt 9]
                    ...
                    [#assign startFrom = previousIndexes?size - 8]
                [#else]
                    [#assign startFrom = 1]
                [/#if]

                [#list previousIndexes as prevIndex]
                    [#assign currentIndex=currentIndex+1 /]

                    [#if currentIndex gte startFrom]
                        <li>
                            <a href="${sanitizedActionUrl}startIndex=${prevIndex}" class="numberedLink">${currentIndex}</a>
                        </li>
                    [/#if]
                [/#list]
            [/#if]

            [#assign currentIndex=currentIndex + 1 /]
            <li>${currentIndex}</li>

            [#if nextIndexes?has_content]
                [#list nextIndexes as nextIndex]
                    [#assign currentIndex=currentIndex + 1 /]
                    <li><a href="${sanitizedActionUrl}startIndex=${nextIndex}" class="numberedLink">${currentIndex}</a>
                    </li>
                [/#list]
                <li>
                    <a href="${sanitizedActionUrl}startIndex=${paginationSupport.nextIndex}" class="nextLink" title="Next">Next</a>
                </li>
            [#else]
                [#if !paginationSupport.items.onLastPage()]
                    <li>
                        <a href="${sanitizedActionUrl}startIndex=${paginationSupport.nextIndex}" class="nextLink" title="Next">Next</a>
                    </li>
                [/#if]
            [/#if]
        [#else]
            [#if paginationSupport.tryNext]
                <li><a href="${sanitizedActionUrl}startIndex=0" class="previousLink" title="Previous">Previous</a></li>
            [/#if]

            [#if paginationSupport.items?? && !paginationSupport.items.onLastPage()]
                <li><a href="${sanitizedActionUrl}tryNext=true" class="nextLink" title="Next">Next</a></li>
            [/#if]
        [/#if]
    </ul>
</div>

[/#macro]

[#-- =========================================================================================== @cp.displayErrorsForPlan --]
[#macro displayErrorsForPlan plan errorAccessor]
    [#assign buildErrors=errorAccessor.getErrors(plan.planKey)]
    [@displayErrors buildErrors plan.key /]
[/#macro]

[#macro displayErrorsForResult planResult errorAccessor manualReturnUrl=""]
    [#assign buildErrors=errorAccessor.getErrors(planResult.planResultKey)]
    [@displayErrors buildErrors planResult.planResultKey.planKey.key planResult.planResultKey.buildNumber manualReturnUrl/]
[/#macro]

[#macro displayErrors buildErrors planKey="" buildNumber="" manualReturnUrl=""]
    [#if buildErrors?has_content]
    <div id="plan-errors">
        [#if fn.hasAdminPermission()]
            <div class="floating-toolbar">
                <a href="[@ww.url value='/chain/removePlanErrorsFromLog.action?' planKey=planKey buildNumber=buildNumber returnUrl=currentUrl /]">[@ui.icon type="delete"/] [@ww.text name="plan.error.bulk.delete"/]</a>
            </div>
        [/#if]
        <h2 id="buildPlanSummaryErrorLog">[@ww.text name='plan.error.title'/]</h2>

        <ol>
            [#list buildErrors as error]
                [#if manualReturnUrl?has_content]
                [@cp.showSystemError error=error returnUrl=manualReturnUrl/]
            [#else]
                [@cp.showSystemError error=error returnUrl=currentUrl/]
            [/#if]
            [/#list]
        </ol>
    </div>
    [/#if]
[/#macro]

[#macro displayDeploymentErrors buildErrors deploymentResult manualReturnUrl=""]
    [#if buildErrors?has_content]
    <div id="deployment-errors">
        <h2 id="buildPlanSummaryErrorLog">[@ww.text name='plan.error.title'/]</h2>
        <ol>
            [#list buildErrors as error]
                [#if manualReturnUrl?has_content]
                    [@cp.showSystemError error=error returnUrl=manualReturnUrl deploymentResult=deploymentResult/]
                [#else]
                    [@cp.showSystemError error=error returnUrl=currentUrl deploymentResult=deploymentResult/]
                [/#if]
            [/#list]
        </ol>
    </div>
    [/#if]
[/#macro]

[#-- =========================================================================================== @cp.showSystemError --]
[#--
    Shows a @ui.messageBox showing the build errors

    @requires error - An ErrorDetails object
--]
[#macro showSystemError error returnUrl='' deploymentResult='']
    [@ui.messageBox type="warning" cssClass='system-error-message']
    <p class="title">[#rt]
        [#if error.buildSpecific]
            [#if !deploymentResult?has_content]
                <a href="[@ww.url value='/browse/${error.buildKey}' /]">${error.buildName}</a>
                [#if error.buildNumber?? && error.buildExists]
                    &rsaquo; <a href="[@ww.url value='/browse/${error.buildResultKey}' /]">${error.buildResultKey}</a>
                [/#if]
            : [#lt]
            [/#if]
        [#elseif error.elastic]
            Elastic Bamboo Error : [#lt]
        [#else]
            General Error : [#lt]
        [/#if]
        <em>${htmlUtils.getTextAsHtml(error.context)}</em>[#lt]
    </p>

        [#if error.throwableDetails??]
        <div class="grey">(${error.throwableDetails.name!?html}[#rt]
            [#if error.throwableDetails.message?has_content]
                : ${error.throwableDetails.message?html}[#rt]
            [/#if]
            )[#lt]
        </div>
        [/#if]

        [#if error.elastic]
            [#if error.instanceIds?has_content]
            <em>Elastic Instances : </em>
                [#list error.instanceIds as instanceId]
                ${instanceId?html}[#t]
                    [#if instanceId_has_next]
                    ,[#lt]
                    [/#if]
                [/#list]
            [/#if]
        [/#if]

    <div>
        (${error.lastOccurred?datetime}[#rt]
        [#if error.numberOfOccurrences > 1]
            , Occurrences: ${error.numberOfOccurrences}[#lt]
        [/#if]
        [#if error.agentIds?has_content]
            , Agents: [#lt]
            [#list error.agentIdentifiers as agent]
                [#if agent.name?has_content]
                    <a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]">${agent.name?html}</a>[#t]
                [#else]
                    id: ${agent.id}
                [/#if]
                [#if agent_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
        )[#lt]
    </div>
    <div>
        [#assign removeErrorReturnUrl=returnUrl!currentUrl /]
        [#if error.throwableDetails??]
            [@ui.icon type="view"/]
            <a href="${req.contextPath}/admin/viewError.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}" rel="help" data-use-help-popup="true">[@ww.text name="plan.error.view"/]</a>
            [@ww.form id='removeErrorHiddenForm_${error.errorNumber}' action='removeErrorFromLog?buildKey=${error.buildKey}&amp;error=${error.errorNumber}&amp;returnUrl=${removeErrorReturnUrl}' namespace='/admin' formEndClearer=false cssClass='popupRemoveErrorLogForm']
                <input type='submit' class='hidden'>
            [/@ww.form]
        [/#if]
        [#if fn.hasAdminPermission() ]
            [@ui.icon type="delete"/]
            <a href="${req.contextPath}/admin/removeErrorFromLog.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}&amp;returnUrl=${removeErrorReturnUrl}" class="system-error-message-remove">[@ww.text name="plan.error.delete"/]</a>
        [/#if]
    </div>
    [/@ui.messageBox]
[/#macro]

[#macro printAuditLogEntity auditLogMessage]
    [#if auditLogMessage.entityType??]${auditLogMessage.entityType}: [/#if]${auditLogMessage.entityHeader?html}[#t]
[/#macro]

[#-- =================================================================== @cp.configChangeHistory changeListPager --]
[#macro configChangeHistory pager showChangedEntityDetails=false jobMap=""]
    [#if pager.getPage()??]
    <div id="audit-log">
        <table id="audit-log-table" class="aui">
            <thead>
            <tr>
                <th id="al-timestamp">[@ww.text name='auditlog.timestamp' /]</th>
                <th id="al-user">[@ww.text name='auditlog.user' /]</th>
                [#if showChangedEntityDetails]
                    <th id="al-entity">[@ww.text name='auditlog.entity' /]</th>
                [/#if]
                <th id="al-change">[@ww.text name='auditlog.changed.field' /]</th>
                <th id="al-old-value">[@ww.text name='auditlog.old.value' /]</th>
                <th id="al-new-value">[@ww.text name='auditlog.new.value' /]</th>
            </tr>
            </thead>
            <tfoot>
            <tr>
                <td colspan="7">[@cp.pagination /]</td>
            </tr>
            </tfoot>
            <tbody>
                [#list pager.page.list as message]
                <tr>
                    <td headers="al-timestamp">${message.date?datetime?string("HH:mm, d MMM")}</td>
                    <td headers="al-user">
                        [#if message.username?? && message.username != "SYSTEM"]
                            <a href="[@ww.url value='/browse/user/${message.username}'/]">${message.username?html}</a>
                        [#else]
                            SYSTEM
                        [/#if]
                    </td>
                    [#if showChangedEntityDetails]
                        <td headers="al-entity">
                            [#if message.jobKey?exists]
                                <a href="${req.contextPath}/build/admin/edit/editBuildDetails.action?buildKey=${message.jobKey}">${jobMap.get(message.jobKey)}</a>
                                [#if message.entityHeader?has_content]
                                    <span class="audit-log-item-separator">&rsaquo;</span> [@printAuditLogEntity message/]
                                [/#if]
                            [#elseif message.entityHeader?has_content]
                                [@printAuditLogEntity message/]
                            [#else]
                                &nbsp;
                            [/#if]
                        </td>
                    [/#if]

                    [#if message.messageType == "FIELD_CHANGE"]
                        <td headers="al-change">${message.message}</td>
                        <td headers="al-old-value">${(message.oldValue!"")?html}</td>
                        <td headers="al-new-value">${(message.newValue!"")?html}</td>
                    [#else]
                        <td headers="al-change" colspan="3">${message.message}</td>
                    [/#if]
                </tr>
                [/#list]
            </tbody>
        </table>
    </div>
    [#else]
    <p>[@ww.text name='auditlog.no.changes.recorded' /]</p>
    [/#if]

[/#macro]

[#macro successStatistics statistics averageDuration isJob]
<div id="successRate">
    <div class="successRatePercentage">
        <p>
            <span>${statistics.successPercentage}%</span>
            [@ww.text name='build.common.statSuccessful' /]
        </p>
    </div>
    <!-- END #successRatePercentage -->
    <dl>
        <dt>
            [#if isJob]
                [@ww.text name='build.common.successful' /]:
            [#else]
                [@ww.text name='chain.summary.graph.successfulBuilds' /]:
            [/#if]
        </dt>
        <dd>${statistics.totalSuccesses} / ${statistics.totalNumberOfResults}</dd>
        <dt>[@ww.text name='build.common.averageDuration' /]:</dt>
        <dd>${durationUtils.getPrettyPrint(averageDuration)}</dd>
    </dl>
</div> <!-- END #successRate -->
[/#macro]

[#macro buildStatistics statistics averageDuration hasResults]
<ul id="build-statistics">
    <li class="builds">
        <span class="value">${statistics.totalNumberOfResults}</span>
        <span class="key">[@ww.text name="build.statistics.builds" /]</span>
    </li>
    <li class="successful">
        <span class="value">${statistics.successPercentage}%</span>
        <span class="key">[@ww.text name="build.statistics.successful" /]</span>
        [#if hasResults]
            <figure id="build-success-chart" data-successful="${statistics.successPercentage}" data-failed="${(100-statistics.successPercentage)}"></figure>
        [/#if]
    </li>
    <li class="duration">
        <span class="value">${durationUtils.getPrettyPrint(averageDuration, PrettyLength.SHORT)}</span>
        <span class="key">[@ww.text name="build.statistics.averageDuration" /]</span>
        [#if hasResults]
            [@ww.action name="viewBuildNumberChart" namespace="/charts" executeResult="true" /]
        [/#if]
    </li>
</ul>
    [#if hasResults]
    <script type="text/javascript">
        BAMBOO.BuildStatistics.init();
    </script>
    [/#if]
[/#macro]

[#-- Displays an aui drop down for the configuration pages.  Requires a whole bunch of li's to be nested --]
[#macro configDropDown buttonText location]
<div id="editConfigurationButton" class="toolbar aui-toolbar inline">
    <ul class="toolbar-group">
        <li class="toolbar-item aui-dd-parent">
            <a class="toolbar-trigger" title="${buttonText}">
            ${buttonText} [@ui.icon type="drop" /]
            </a>
            <ul class="aui-dropdown aui-dropdown-right hidden">
                [#list action.getWebSectionsForLocation(location) as section ]
                    [#list action.getWebItemsForSection(location + '/' + section.key) as item]
                        [#assign id=item.link.getRenderedId(webFragmentsContextMap)/]
                        [#if !id??]
                            [#assign id=action.renderFreemarkerTemplate(item.key)?html/]
                        [/#if]
                        [#assign url=item.link.getDisplayableUrl(req, webFragmentsContextMap)]
                        <li class="dropdown-item">
                            <a class="item-link" [#if id??] id="${id}"[/#if] href="${url}">${item.webLabel.displayableLabel}</a>
                        </li>
                    [/#list]
                [/#list]
            </ul>
        </li>
    </ul>
</div>
<script type="text/javascript">
    AJS.$(function ()
          {
              AJS.$("#editConfigurationButton .aui-dd-parent").dropDown("Standard", { trigger: "a.toolbar-trigger" });
          });
</script>
[/#macro]

[#macro filterDropDown filterController isAgentFilter=false]
    [#if filterController??]
    <div id="filterButton" class="toolbar aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item aui-dd-parent">
                <a class="toolbar-trigger">
                    Showing
                    [#if isAgentFilter]
                    ${filterController.agentFilterName}
                    [#else]
                    ${filterController.selectedFilterName}
                    [/#if]
                    [@ui.icon type="drop" /]
                </a>
                <ul class="aui-dropdown aui-dropdown-right hidden">
                    [#list filterController.filterMap.keySet() as key]
                            [#if isAgentFilter]
                        [@ww.url id="filterUrl" action="setResultsFilter" namespace="/agent" returnUrl=currentUrl]
                            [@ww.param name="filterController.agentFilterKey"]${key}[/@ww.param]
                        [/@ww.url]
                    [#else]
                        [@ww.url id="filterUrl" action="setResultsFilter" namespace="/build" returnUrl=currentUrl buildKey="${immutablePlan.key}"]
                            [@ww.param name="filterController.selectedFilterKey"]${key}[/@ww.param]
                        [/@ww.url]
                    [/#if]
                            [@ui.displayLink id="filter:${key}"
                    title=filterController.filterMap[key]
                    href=filterUrl
                    inList=true /]
                        [/#list]
                </ul>
            </li>
        </ul>
    </div>
    <script type="text/javascript">
        AJS.$(function ()
              {
                  AJS.$("#filterButton .aui-dd-parent").dropDown("Standard", { trigger: "a.toolbar-trigger" });
              });
    </script>
    [/#if]
[/#macro]

[#macro displayCommentList result headingLevel='h3']
    [#assign commentList = [] /]
    [#list result.comments as comment]
        [#assign renderedComment][@ui.renderValidJiraIssues comment.content result /][/#assign]
        [#assign userDisplayName][#if comment.user??][@ui.displayUserFullName user=comment.user /][/#if][/#assign]
        [#assign commentList = commentList + [{
        "id": comment.id,
        "comment": renderedComment,
        "lastModificationDate": comment.lastModificationDate?string("yyyy-MM-dd'T'HH:mm:ss"),
        "prettyLastModificationDate": durationUtils.getRelativeDate(comment.lastModificationDate),
        "avatar": ctx.getGravatarUrl((comment.user.name)!'', "32")!'',
        "user": comment.user!false,
        "userDisplayName": userDisplayName,
        "result": result
        }] /]
    [/#list]
    [#if fn.hasPlanPermission('WRITE', result.immutablePlan)]
        [#local showOperations]true[/#local]
    [/#if]
${soy.render("bamboo.feature.comments.commentList", {
"comments": commentList,
"showOperations": showOperations??,
"headingLevel": headingLevel,
"showTopLevelHeading": (headingLevel == 'h3')
})}
[/#macro]

[#--Displays existing comments and button-triggered form to add a new comment.  Whilst it is a component, the delete links currently dont use the return url--]
[#macro displayComments result returnUrl showFormOnLoad=false]
    [#if user?? || result.hasComments()]
    <div class="comments" id="comments">
        [#if result.stageResults?has_content && (result.comments?has_content || !result.hasComments())]
            [@displayCommentList result=result/]
        [/#if]

        [#if user?? && fn.hasPlanPermission('READ', result.immutablePlan)]
            [#include "/feature/comments/commentForm.ftl" /]
        [/#if]

        [#if result.stageResults?has_content]
            [#assign aggregatedJobResultComments]
                [#list result.stageResults as stage]
                    [#list stage.sortedBuildResults as buildResult]
                        [#if buildResult.comments?has_content]
                            [#assign job = buildResult.immutablePlan/]
                            <h3>Comments on
                                <a href="${req.contextPath}/browse/${buildResult.planResultKey}">${job.buildName}</a>
                            </h3>
                            [@displayCommentList result=buildResult headingLevel='h4'/]
                        [/#if]
                    [/#list]
                [/#list]
            [/#assign]
            [#if aggregatedJobResultComments?has_content]
            ${aggregatedJobResultComments}
            [/#if]
        [/#if]
    </div>
    [/#if]
[/#macro]

[#import "/fragments/variable/variables.ftl" as variables/]
[#import "/lib/resultSummary.ftl" as ps]
[#--Displays manually overriden variables--]
[#macro displayManualVariables result]
    [#assign manualVariables=result.manuallyOverriddenVariables]
    [#if manualVariables?has_content || (result.onceOff && result.repositoryChangesets?first?has_content)]
    <div class="variables">
        <h2>[@ww.text name='buildResult.variable.title' /]</h2>
        [#if result.onceOff && result.repositoryChangesets?first?has_content]
            <dl class="details-list">
                <dt>[@ww.text name='buildResult.variable.customRevision' /]</dt>
                <dd>[@ps.showCommit plan=result.immutablePlan repositoryChangeset=result.repositoryChangesets?first/]</dd>
            </dl>
        [/#if]
        [#if manualVariables?has_content]
            [@variables.displayManualVariables id="chainManualVariables" variablesList=manualVariables /]
        [/#if]
    </div>
    [/#if]
[/#macro]

[#macro captcha]
    [@ww.textfield labelKey="user.captcha" name="captcha" required="true" tabindex="4" /]
    <div class="field-group">
        <img id="captcha-image" class="captcha-image" src="${req.contextPath}/captcha"/>
        [@dj.imageReload target="captcha-image" titleKey="user.captcha.reload"/]
    </div>
[/#macro]

[#macro displayOperationsHeader applicableForRepositories tagName='span']
    <${tagName} class="bulk-command">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_all">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_none">[@ww.text name='global.selection.none' /]</span>[#rt]
        [#if applicableForRepositories]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_plans">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_jobs">[@ww.text name='bulk.selection.jobs' /]</span>
        [/#if]
    </${tagName}>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSelectionActions.init();
        });
    </script>
[/#macro]

[#macro displayProjectOperationsHeader key class applicableForRepositories enableProjectCheckbox ]
    <span class="${class}">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>[#rt]
        [#if applicableForRepositories]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_sub_plans_${key}">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
            ,[#t]
            <span tabindex="0" role="link" selector="bulk_selector_sub_jobs_${key}">[@ww.text name='bulk.selection.jobs' /]</span>
        [/#if]
    </span>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSubtreeSelectionActions.init("${key}", ${enableProjectCheckbox?string});
        });
    </script>
[/#macro]

[#macro displaySubtreeOperationsHeader key class ]
    <span class="${class}">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>
    </span>
    <script type="text/javascript">
        AJS.$(function () {
            BulkSubtreeSelectionActions.init("${key}", false);
        });
    </script>
[/#macro]


[#macro displayBulkActionSelector bulkAction checkboxFieldValueType planCheckboxName repoCheckboxName="" enableProjectCheckbox=false]
    [@ww.hidden name="selectedBulkActionKey" /]

    [@displayOperationsHeader bulkAction.applicableForRepositories 'p' /]

    [#list sortedProjects as project]
        [#if action.isApplicable(bulkAction, project)]
            <div class="bulk-project-bar">
                [#if enableProjectCheckbox]
                    [#if checkboxFieldValueType == "id"]
                        [#local checkboxFieldValue = project.id! /]
                    [#else]
                        [#local checkboxFieldValue = project.key! /]
                    [/#if]
                    <div class="bulk-project-name">
                        [@ww.checkbox name='selectedProjects'
                            cssClass='bulk bulkProject bulkPlan bulk' + project.key + ' bulkProject' + project.key
                            id='checkbox_${project.key!}'
                            fieldValue=checkboxFieldValue
                            label='${project.name!}'
                            checked=action.isProjectSelected(project.key)?string /]
                    </div>
                [#else]
                    <span class="bulk-project-name">${project.name?html}</span>
                [/#if]
                [@displayProjectOperationsHeader project.key 'bulk-project-links' bulkAction.applicableForRepositories enableProjectCheckbox=enableProjectCheckbox /]
            </div>

            [#list action.getSortedTopLevelPlans(project) as plan]
                [#if bulkAction.isApplicable(plan)]
                    <div class="bulk-plan">
                        [#if checkboxFieldValueType == "id"]
                            [#local checkboxFieldValue = plan.id! /]
                        [#else]
                            [#local checkboxFieldValue = plan.key! /]
                        [/#if]

                        <div class="bulk-plan-left">
                            <div class="bulk-plan-name">
                                [@ww.checkbox name=planCheckboxName
                                    cssClass='bulk bulkPlan bulk' + project.key + ' bulkPlan' + project.key
                                    id='checkbox_${plan.key!}'
                                    fieldValue=checkboxFieldValue
                                    label='${plan.buildName?html}'
                                    checked="${action.isPlanSelected(plan.key)?string}" /]
                            </div>
                        </div>

                        [#if bulkAction.applicableForRepositories]
                            <div class="bulk-plan-right">
                                [#local repositories= bulkAction.getRepositoryDefinitions(plan)]
                                [#if repositories?has_content]
                                    <fieldset class="bulk-job">
                                        [#if repositories.size() > 1]
                                            [@displaySubtreeOperationsHeader plan.key 'bulk-job-links' /]
                                        [/#if]
                                        [#list repositories as repositoryDefinition]
                                            [#local checkboxFieldValue = repositoryDefinition.id! /]
                                            [@ww.checkbox name=repoCheckboxName
                                                cssClass='bulk bulkJob bulk' + project.key + ' bulk' + plan.key + ' bulkJob' + project.key
                                                id='checkbox_${repositoryDefinition.id!}'
                                                fieldValue=checkboxFieldValue
                                                label='${repositoryDefinition.name?html}'
                                                checked="${action.isRepositorySelected(repositoryDefinition.id)?string}" /]
                                        [/#list]
                                    </fieldset>
                                [/#if]
                            </div>
                        [/#if]
                    </div>
                [/#if]
            [/#list]
        [/#if]
    [/#list]
[/#macro]

[#macro displayLinkButton buttonId buttonLabel buttonUrl='' icon='' altText="" altTextKey="" cssClass="" primary=false disabled=false mutative=false]
    [#local title][@ww.text name=buttonLabel/][/#local]
    [#if altTextKey?has_content || altText?has_content]
        [#local altTextVal = fn.resolveName(altText, altTextKey) /]
    [#else]
        [#local altTextVal = title /]
    [/#if]
    [#local extraAttributes = {
        "title": altTextVal
    } /]
    [#if !disabled && buttonUrl?has_content]
        [#local extraAttributes = extraAttributes + {
            "href": buttonUrl?replace("&amp;", "&", "i") [#-- replace is required to prevent double escaping of ampersands when Soy escapes the output --]
        } /]
    [/#if]

    [#local extraClasses]
        [#if primary]aui-button-primary[/#if][#t]
        [#if cssClass?has_content] ${cssClass}[/#if][#t]
    [/#local]

${soy.render("aui.buttons.button", {
    "tagName": "a",
    "id": buttonId,
    "isDisabled": disabled,
    "text": title,
    "extraAttributes": extraAttributes,
    "extraClasses": extraClasses + mutative?string(" mutative", "")
})}
[/#macro]
