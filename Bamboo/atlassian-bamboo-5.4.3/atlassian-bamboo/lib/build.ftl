[#-- @ftlvariable name="chain" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="immutableChain" type="com.atlassian.bamboo.plan.cache.ImmutableChain" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]
[#-- @ftlvariable name="executableAgentMatrix" type="com.atlassian.bamboo.buildqueue.manager.ExecutableAgentsMatrix" --]
[#-- @ftlvariable name="elasticBambooEnabled" type="boolean" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/fragments/permissions/permissions.ftl" as permissions/]

[#-- ================================================================================ @bd.displayArtifactDefinitions --]
[#macro artifactSharingToggleContent shared ]
    [#if shared][#t]
        [@ww.text name='artifact.unshare'/][#t]
    [#else]
        [@ww.text name='artifact.share'/][#t]
    [/#if][#t]
[/#macro]

[#macro displayArtifactDefinitions artifactDefinitions showOperations=true planIsUsedInDeployments=false]
[#-- @ftlvariable name="artifactDefinitions" type="java.util.List<com.atlassian.bamboo.plan.artifact.ArtifactDefinition>" --]
    [#if artifactDefinitions?has_content]
    <table id="artifactDefinitions" class="aui tablesorter">
        <colgroup>
            [#if showOperations]
                <col width="30%"/>
                <col width="35%"/>
                <col width="25%"/>
                <col width="10%"/>
            [#else]
                <col width="35%"/>
                <col width="35%"/>
                <col width="30%"/>
            [/#if]
        </colgroup>
        <thead>
        <tr>
            <th>[@ww.text name='artifact.name'/]</th>
            <th>[@ww.text name='artifact.location'/]</th>
            <th>[@ww.text name='artifact.copyPattern'/]</th>
            [#if showOperations]
                <th>[@ww.text name='global.heading.operations'/]</th>
            [/#if]
        </tr>
        </thead>
        <tbody>
            [#list artifactDefinitions as artifact]
            <tr id="artifactDefinition-${artifact.id}">
                <td>
                    [#if artifact.sharedArtifact]
                        [@ui.icon type="artifact-shared"/]
                    [#else]
                        [@ui.icon type="artifact"/]
                    [/#if] <span class="artifactName">${artifact.name}</span>
                </td>
                <td>${artifact.location!}</td>
                <td>${artifact.copyPattern}</td>
                [#if showOperations]
                    [#assign artifactHasDependencies = ((artifact.sharedArtifact && planIsUsedInDeployments) || artifact.subscriptions?has_content) /]
                    <td>
                        <a id="toggleArtifactDefinitionSharing-${artifact.id}" class="toggleArtifactDefinitionSharing">[@artifactSharingToggleContent artifact.sharedArtifact /]</a>
                        |
                        <a id="editArtifactDefinition-${artifact.id}" class="editArtifactDefinition">[@ww.text name='global.buttons.edit'/]</a>
                        |
                        <a id="deleteArtifactDefinition-${artifact.id}" class="deleteArtifactDefinition[#if artifactHasDependencies] hasDependencies[/#if]">[@ww.text name='global.buttons.delete'/]</a>
                    </td>
                [/#if]
            </tr>
            [/#list]
        </tbody>
    </table>

        [#if showOperations]
        <script type="text/javascript">
            AJS.$(function ()
                  {
                      ArtifactDefinitionEdit.init({
                                                      html: {
                                                          artifactSharingToggleContentShared: '[@artifactSharingToggleContent true /]',
                                                          artifactSharingToggleContentUnshared: '[@artifactSharingToggleContent false /]'
                                                      },
                                                      i18n: {
                                                          artifact_definition_shareToggle_error: "[@ww.text name='artifact.definition.shareToggle.error'/]",
                                                          artifact_definition_shareToggle_error_header: "[@ww.text name='artifact.definition.shareToggle.error.header'/]",
                                                          global_buttons_close: "[@ww.text name='global.buttons.close'/]"
                                                      },
                                                      deletePackageItem: {
                                                          actionUrl: "[@ww.url action='confirmDeleteArtifactDefinition' namespace='/ajax' planKey=immutablePlan.key /]",
                                                          submitLabel: "[@ww.text name='global.buttons.delete'/]",
                                                          title: "[@ww.text name='artifact.definition.delete'/]"
                                                      },
                                                      editPackageItem: {
                                                          actionUrl: "[@ww.url action='editArtifactDefinition' namespace='/ajax' planKey=immutablePlan.key /]",
                                                          submitLabel: "[@ww.text name='global.buttons.update'/]",
                                                          title: "[@ww.text name='artifact.definition.edit'/]"
                                                      },
                                                      renameArtifactDefinitionToEnableSharing: {
                                                          actionUrl: "[@ww.url action='renameArtifactDefinitionToEnableSharing' namespace='/ajax' planKey=immutablePlan.key /]",
                                                          submitLabel: "[@ww.text name='artifact.definition.shareToggle.rename.saveAndShare'/]",
                                                          title: "[@ww.text name='artifact.definition.shareToggle.rename'/]"
                                                      },
                                                      toggleArtifactDefinitionSharing: {
                                                          actionUrl: "[@ww.url action='toggleArtifactDefinitionSharing' namespace='/ajax' /]",
                                                          submitLabel: "[@ww.text name='global.buttons.update'/]",
                                                          title: "[@ww.text name='artifact.definition.edit'/]"
                                                      },
                                                      confirmToggleArtifactDefinitionSharing: {
                                                          actionUrl: "[@ww.url action='confirmToggleSharedArtifact' namespace='/ajax' planKey=immutablePlan.key /]",
                                                          submitLabel: "[@ww.text name='artifact.unshare'/]",
                                                          title: "[@ww.text name='artifact.unshare.title'/]"
                                                      }
                                                  });
                  });
        </script>
        [/#if]

    [/#if]

[/#macro]

[#-- ================================================================================ @bd.displayArtifactDefinitions --]
[#macro displayArtifactSubscriptions artifactSubscriptions showOperations=true showSubstitutionVariables=false]

    [#if artifactSubscriptions?has_content]
        [#if showOperations]
        <script type="text/javascript">
            function editArtifactSubscriptionCallback(result)
            {
                var subscription = result.artifactSubscription;
                var cells = AJS.$("#artifactSubscription-" + subscription.id + " > td");
                AJS.$("> a", cells[0]).replaceWith("<a href='${req.contextPath}/build/admin/edit/defaultBuildArtifact.action?buildKey=" + subscription.producerJobKey + "'>" + subscription.name + "</a>");
                AJS.$(cells[1]).text(subscription.destination);
            }
            function deleteArtifactSubscriptionCallback(result)
            {
                var subscription = result.artifactSubscription;

                if (AJS.$("#artifactSubscriptions > tbody > tr").length == 1)
                {
                    AJS.$("#artifactSubscriptions").remove();
                }
                else
                {
                    AJS.$("#artifactSubscription-" + subscription.id).remove();
                }
            }
            AJS.$(function ()
                  {
                      AJS.$("#artifactSubscriptions").tablesorter({
                                                                      headers: {2: {sorter: false}},
                                                                      sortList: [
                                                                          [0, 0]
                                                                      ]
                                                                  });
                  });
        </script>

        [/#if]

    <table id="artifactSubscriptions" class="aui tablesorter artifact">
        <colgroup>
            <col width="15%"/>
            <col width="35%"/>
            <col width="10%"/>
        </colgroup>
        <thead>
        <tr>
            <th>[@ww.text name='artifact.subscription.name'/]</th>
            <th>[@ww.text name='artifact.subscription.destination'/]</th>
            [#if showOperations]
                <th>[@ww.text name='global.heading.operations'/]</th>
            [/#if]
            [#if showSubstitutionVariables]
                <th>[@ww.text name='artifact.subscription.variableName'/]</th>
            [/#if]
        </tr>
        </thead>
        <tbody>
            [#list artifactSubscriptions as subscription]
            <tr id="artifactSubscription-${subscription.id}">
                <td>[@ui.icon type="artifact-shared"/]
                    <a id="producerJob-${subscription.id}" href="[@ww.url action='defaultBuildArtifact' namespace='/build/admin/edit' buildKey=subscription.artifactDefinition.producerJob.key /]">${subscription.artifactDefinition.name}</a>
                </td>
                <td class="artifact">
                    [#if subscription.destinationDirectory?has_content]
                    ${subscription.destinationDirectory}
                    [#else]
                        <span class="subGrey">[@ww.text name="artifact.subscription.destination.default"/]</span>
                    [/#if]
                </td>
                [#if showOperations]
                    <td>
                        <a id="editArtifactSubscription-${subscription.id}" title="[@ww.text name='artifact.subscription.edit.form'/]">[@ww.text name='global.buttons.edit'/]</a>
                        |
                        <a id="deleteArtifactSubscription-${subscription.id}" title="[@ww.text name='artifact.subscription.delete.form'/]">[@ww.text name='global.buttons.delete'/]</a>

                        [@dj.simpleDialogForm
                        triggerSelector="#editArtifactSubscription-${subscription.id}"
                        actionUrl="/ajax/editArtifactSubscription.action?planKey=${planKey}&subscriptionId=${subscription.id}&artifactDefinitionId=${subscription.artifactDefinition.id}"
                        width=800 height=400
                        submitLabelKey="global.buttons.update"
                        submitMode="ajax"
                        submitCallback="editArtifactSubscriptionCallback"
                        /]
                        [@dj.simpleDialogForm
                        triggerSelector="#deleteArtifactSubscription-${subscription.id}"
                        actionUrl="/ajax/confirmDeleteArtifactSubscription.action?planKey=${planKey}&subscriptionId=${subscription.id}"
                        width=800 height=400
                        submitLabelKey="global.buttons.delete"
                        submitMode="ajax"
                        submitCallback="deleteArtifactSubscriptionCallback"
                        /]
                    </td>
                [/#if]
                [#if showSubstitutionVariables]
                    <td>${subscription.variableName?html}</td>
                [/#if]
            </tr>
            [/#list]
        </tbody>
    </table>
    [/#if]

[/#macro]

[#-- ======================================================================================== @build.showJdk --]
[#macro showJdk ]
    [@ww.label labelKey='builder.common.jdk' name='plan.buildDefinition.builder.buildJdk' /]
    [#if !builder.jdkValid]
        [@ui.messageBox type="warning"]
            [@ww.text name='builder.common.jdk.invalid' ]
                [@ww.param]${builder.buildJdk!}[/@ww.param]
            [/@ww.text]
            [#if fn.hasGlobalAdminPermission() ]
                [@ww.text name='builder.common.jdk.invalid.admin' ]
                    [@ww.param]
                    <a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action?capabilityType=jdk&jdkLabel=${builder.buildJdk!}">[/@ww.param]
                    [@ww.param]</a>[/@ww.param]
                [/@ww.text]
            [/#if]
        [/@ui.messageBox]
    [/#if]
[/#macro]
[#-- ======================================================================================== @build.configureRequirement --]
[#macro configureBuildRequirement requirementSetDecorator plan showForm=true showOperations=true]

    [#if (plan.requirementSet.requirements)?has_content]
        [#assign decoratedObjects = requirementSetDecorator.decoratedObjects /]
        [#assign taskDecoratedObjects = requirementSetDecorator.decoratedObjectsByRequirement /]

    <p>
        [@ww.text name='requirement.description' ][@ww.param name="value" value="${decoratedObjects.size()}"/][/@ww.text]
            [@ww.action name="describeAgentAvailability" namespace="/ajax" executeResult="true" /]
    </p>

    <table id="requirements" class="aui">
        <thead>
        <tr>
            <th colspan="4">[@ww.text name='requirement.current' /]</th>
            <th>[@ww.text name='requirement.source' /]</th>
            <th class="matchingAgents">[@ww.text name="requirement.executableAgents.matching"/]</th>
            [#if elasticBambooEnabled ]
                <th class="matchingAgents">[@ww.text name="requirement.executableImages.matching"/]</th>
            [/#if]
            [#if showOperations]
                <th></th>
            [/#if]
        </tr>
        </thead>
        <tbody>
            [#list taskDecoratedObjects.keySet() as requirement]
                [#assign tasks = taskDecoratedObjects.get(requirement)]
                [#assign matchingAgentsForRequirement = (executableAgentMatrix.getBuildAgents(requirement.key))!('') /]
                [#if elasticBambooEnabled]
                    [#assign matchingImageForRequirement = (executableAgentMatrix.getImageFromMatrix(requirement.key))!('') /]
                [/#if]
                [#assign counter=1 /]
                [#list tasks as taskKey]
                <tr [#if !matchingAgentsForRequirement?has_content && !matchingImageForRequirement?has_content ] class="noAgents" [/#if]>
                    [#if counter == 1]
                        <td class="labelCell">
                            [#if fn.hasGlobalAdminPermission()]
                                <a href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=requirement.key /]">${requirement.label?html}</a>
                            [#else]
                            ${requirement.label?html}
                            [/#if]
                        </td>
                        <td class="labelPrefixCell">
                            [@ww.text name='agent.capability.type.${requirement.capabilityGroup.typeKey}.title' /]
                        </td>
                    <td class="valueCell" title="[@ww.text name='requirement.matchType.${requirement.matchType}.description' /]">
                        [@ww.text name='requirement.matchType.${requirement.matchType}' /][#rt]
                        [#if requirement.matchValue?has_content]
                        </td>
                            <td class="valueCell2">
                                <span>${requirement.matchValue!?html}</span>
                            </td>
                        [#else]
                            [#lt]
                            </td>
                            <td class="valueCell2"></td>
                        [/#if]
                    [#else]
                        <td colspan="4"></td>
                    [/#if]
                    <td>
                        [#if taskKey?has_content]
                            [#assign taskId=requirementSetDecorator.getTaskNumber(taskKey) /]
                            [#assign taskName=requirementSetDecorator.getPrettyLabel(taskKey) /]
                            <a href="${req.contextPath}/build/admin/edit/editBuildTasks.action?planKey=${plan.key}&amp;taskId=${taskId}">
                                [@ww.text name='requirement.source.task'][@ww.param]${taskName}[/@ww.param][/@ww.text]
                            </a>
                        [/#if]
                    </td>
                    [#if counter == 1]
                        <td class="matchingAgents">
                            [#if matchingAgentsForRequirement?has_content]
                            ${matchingAgentsForRequirement.size()}
                            [#else]
                                0
                            [/#if]
                        </td>
                        [#if elasticBambooEnabled ]
                            <td class="matchingAgents">
                                [#assign matchingImageForRequirement = (executableAgentMatrix.getImageFromMatrix(requirement.key))!('') /]
                                [#if matchingImageForRequirement?has_content]
                                ${matchingImageForRequirement.size()}
                                [#else]
                                    0
                                [/#if]
                            </td>
                        [/#if]
                        [#if showOperations]
                            <td class="operations">
                                [@agt.showRequirementOperations requirement=requirement build=plan returnUrl='/build/admin/edit/defaultBuildRequirement.action?buildKey=${plan.key}' /]
                            </td>
                        [/#if]
                    [#else]
                        <td [#if elasticBambooEnabled]colspan="2"[/#if]></td>
                        [#if showOperations]
                            <td></td>
                        [/#if]
                    [/#if]
                    [#assign counter = counter+1/]
                </tr>
                [/#list]
            [/#list]
        </tbody>
    </table>
    [#else]
    <p>[@ww.text name='requirement.empty' /]</p>
    [/#if]

    [#if showForm]
        [@ui.bambooSection titleKey='requirement.add' descriptionKey='requirement.add.description']
            [@ww.hidden name='buildKey' value=plan.key /]

            [@ww.select labelKey='requirement.add.requirement' name='existingRequirement'
            list=capabilityKeys.decoratedObjects listKey='key' listValue='label' groupBy='capabilityGroup.typeLabel'
            headerKey='' headerValue='${action.getText("requirement.add.new")}'  toggle='true']
            [/@ww.select]

            [@ui.bambooSection dependsOn='existingRequirement' showOn='']
                [@ww.textfield labelKey='requirement.key' name='requirementKey' /]
            [/@ui.bambooSection]

            [@ww.select name='requirementMatchType' toggle='true'
            list=matchTypeOptions listKey='name' listValue='label' ]
            [/@ww.select]

            [@ui.bambooSection dependsOn='requirementMatchType' showOn='equal']
                [@ww.textfield name='requirementMatchValue' /]
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='requirementMatchType' showOn='match']
                [@ww.textfield name='regexMatchValue' descriptionKey='requirement.add.regex.description'/]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/#if]

[/#macro]

[#macro describeAgentAvailability executableAgentMatrix plan elasticBambooEnabled]
<span id="agentAvailabilityDescription">
    [#if executableAgentMatrix.buildAgents?has_content]
        [#if plan.key??]
            <a href="${req.contextPath}/agent/viewAgents.action?planKey=${plan.key}&amp;returnUrl=/browse/${plan.key}/config" id='executableAgentsText'>
                [@ww.text name='requirement.executableAgents.descriptionValue' ]
                    [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                [/@ww.text]
            </a> [#t]
            [@ww.text name='requirement.executableAgents.descriptionText']
                [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
            [/@ww.text][#t]
            [#if !executableAgentMatrix.onlineEnabledBuildAgents?has_content]
                <span class="errorText">
                    [@ww.text name='requirement.onlineEnabledExecutableAgents.empty']
                        [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                    [/@ww.text][#t]
                </span>
            [/#if]
            [@dj.tooltip target="executableAgentsText" addMarker=true url="${req.contextPath}/ajax/viewAgentsMatchingRequirements.action?planKey=${plan.key}" /]
        [#else]
            [@ww.text name='requirement.executableAgents.description' ]
                [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
            [/@ww.text][#t]
        [/#if]
    [#else]
        <span [#if !elasticBambooEnabled || !executableAgentMatrix.imageMatches?has_content ]class="errorText"[/#if]>[@ww.text name='requirement.executableAgents.empty.job' /]</span>
    [/#if]
    [#if elasticBambooEnabled]
        [#assign iconHtml]
            [#if fn.hasAdminPermission() ]
                <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action">
                    [@ui.icon type="elastic" text="Manage Elastic Instances" /]
                </a>
            [#else]
                [@ui.icon type="elastic" text="Manage Elastic Instances" /]
            [/#if]
        [/#assign]
        [#if executableAgentMatrix.imageMatches?has_content ]
            [#if plan.key??]
                [@ww.text name="requirement.executableImages.descriptionText" ]
                    [@ww.param]${iconHtml}[/@ww.param]
                [/@ww.text] [#t]
                <a href="${req.contextPath}/agent/viewAgents.action?planKey=${plan.key}&amp;returnUrl=/browse/${plan.key}/config#elasticImages" id='executableImageText'>
                    [@ww.text name="requirement.executableImages.descriptionValue" ]
                        [@ww.param name="value" value="${executableAgentMatrix.imageMatches.size()}"/]
                    [/@ww.text]
                </a>
                [@dj.tooltip target="executableImageText" addMarker=true url="${req.contextPath}/ajax/viewImagesMatchingRequirements.action?planKey=${plan.key}" /]
            [#else]
                [@ww.text name='requirement.executableImages.description' ]
                    [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                [/@ww.text][#t]
            [/#if]
        [#else]
            <span [#if !executableAgentMatrix.buildAgents?has_content]class="errorText"[/#if]>
                [@ww.text name="requirement.noExecutableImages.description" ]
                        [@ww.param]${iconHtml}[/@ww.param]
                [/@ww.text]
            </span>
        [/#if]
    [/#if]
</span>
[/#macro]

[#-- ====================================================================================== @bd.notificationWarnings --]
[#macro notificationWarnings cssClass=""]
    [#if featureManager.mailServerConfigurationSupported]
    <div id="bd_notificationWarnings" [#if cssClass?has_content]class="${cssClass}"[/#if]>
        [@cp.displayNotificationWarnings messageKey='notification.both.notConfigured' addServerKey='notification.both.add' cssClass='info' id='bd_notificationWarnings_notification_both_notConfigured' hidden=true/]
        [@cp.displayNotificationWarnings messageKey='notification.mail.notConfigured' addServerKey='notification.mail.add' cssClass='info' id='bd_notificationWarnings_notification_mail_notConfigured' hidden=true/]
        [@cp.displayNotificationWarnings messageKey='notification.im.notConfigured' addServerKey='notification.im.add' cssClass='info' id='bd_notificationWarnings_notification_im_notConfigured' hidden=true/]

        <script type="text/javascript">

            var notificationWarningsController = function ()
            {
                var mailServerConfigured = ${mailServerConfigured?string};
                var imServerConfigured = ${jabberServerConfigured?string};

                var updateDisplay = function ()
                {
                    var container = AJS.$("#bd_notificationWarnings");
                    AJS.$("div.aui-message", container).hide();
                    if (!mailServerConfigured && !imServerConfigured)
                    {
                        AJS.$("#bd_notificationWarnings_notification_both_notConfigured", container).show();
                    }
                    else if (!mailServerConfigured)
                    {
                        AJS.$("#bd_notificationWarnings_notification_mail_notConfigured", container).show();
                    }
                    else if (!imServerConfigured)
                    {
                        AJS.$("#bd_notificationWarnings_notification_im_notConfigured", container).show();
                    }
                };

                var mailServerConfiguredCallback = function ()
                {
                    mailServerConfigured = true;
                    updateDisplay();
                };

                var imServerConfiguredCallback = function ()
                {
                    imServerConfigured = true;
                    updateDisplay();
                };

                return {
                    updateDisplay: updateDisplay,
                    mailServerConfiguredCallback: mailServerConfiguredCallback,
                    imServerConfiguredCallback: imServerConfiguredCallback
                };
            }();

            AJS.$(document).ready(notificationWarningsController.updateDisplay);

        </script>

        [#if !mailServerConfigured]
            [@dj.simpleDialogForm
            triggerSelector=".addMailServerInline"
            actionUrl="/ajax/configureMailServerInline.action?returnUrl=${currentUrl}"
            width=860 height=540
            submitLabelKey="global.buttons.update"
            submitMode="ajax"
            submitCallback="notificationWarningsController.mailServerConfiguredCallback"
            /]
        [/#if]

        [#if !jabberServerConfigured]
            [@dj.simpleDialogForm
            triggerSelector=".addInstantMessagingServerInline"
            actionUrl="/ajax/configureInstantMessagingServerInline.action?returnUrl=${currentUrl}"
            width=800 height=415
            submitLabelKey="global.buttons.update"
            submitMode="ajax"
            submitCallback="notificationWarningsController.imServerConfiguredCallback"
            /]
        [/#if]

    </div>
    [/#if]
[/#macro]

[#-- ======================================================================================== @build.existingNotificationsTable --]

[#macro existingNotificationsTable notificationSet=immutableChain.notificationSet showDesc=true showColumnSpecificHeading=true showOperationsColumn=true editUrl='' deleteUrl='']
    [#if (notificationSet.notificationRules)?has_content]
        [@displayNotificationRulesTable notificationSet.sortedNotificationRules showColumnSpecificHeading showOpertationsColumn editUrl deleteUrl/]
    [#else]
    <p>[@ww.text name='notification.empty' /]</p>
    [/#if]
[/#macro]

[#-- ======================================================================================== @build.displayNotificationRulesTable --]

[#macro displayNotificationRulesTable notificationRules showColumnSpecificHeading=true showOperationsColumn=true editUrl='' deleteUrl='']
<table id="notificationTable" class="aui">
    <colgroup>
        <col width="40%">
        <col>
        <col width="70px">
    </colgroup>
    <thead>
    <tr>
        [#if showColumnSpecificHeading]
            <th colspan="3">[@ww.text name='notification.current' /]</th>
        [#else]
            <th>[@ww.text name='bulkAction.notification.eventHeading' /]</th>
            <th>[@ww.text name='bulkAction.notification.recipientHeading' /]</th>
            [#if showOperationsColumn]<th>[@ww.text name="global.heading.actions"/]</th>[/#if]
        [/#if]
    </tr>
    </thead>
    <tbody>
        [#list notificationRules as notification]
        [#-- Setting the newRow group variable --]
            [#if notification.notificationTypeForView?has_content]
                [#if notification.notificationTypeForView.getViewHtml()?has_content]
                    [#assign thisNotificationType=notification.notificationTypeForView.getViewHtml() /]
                [#else]
                    [#assign thisNotificationType=notification.notificationTypeForView.name /]
                [/#if]
            [#else]
                [#assign thisNotificationType=notification.conditionKey /]
            [/#if]

            [#if !lastNotificationType?has_content || lastNotificationType != thisNotificationType]
                [#assign newRow = true /]
            [#else]
                [#assign newRow = false /]
            [/#if]

            [#assign lastNotificationType=thisNotificationType /]

        <tr [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if] >
            <td [#if !newRow]class="subsequent-notification-in-group"[/#if]>
                [#if newRow]${thisNotificationType}[/#if]
            </td>
            <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if][#if !showOperationsColumn] colspan="2"[/#if]>
                [#if notification.notificationRecipient?has_content]
                    [#if notification.notificationRecipient.getViewHtml()?has_content]
                    ${notification.notificationRecipient.getViewHtml()}
                    [#else]
                    ${notification.notificationRecipient.description}
                    [/#if]
                [#else]
                ${notification.recipientType}: ${notification.recipient}
                [/#if]
            </td>
            [#if showOperationsColumn]
                <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if]>
                    [#if editUrl?has_content]
                        <a id="editNotification:${notification.getId()}" href="${editUrl}&amp;notificationId=${notification.getId()}&amp;edit=true" class="edit-notification">[@ui.icon type='edit'/]</a>
                    [/#if]
                    [#if deleteUrl?has_content]
                        <a id="deleteNotification:${notification.getId()}" class="mutative" href="${deleteUrl}&amp;notificationId=${notification.getId()}">[@ui.icon type='remove' useIconFont=true/]</a>
                    [/#if]
                </td>
            [/#if]
        </tr>
        [/#list]
    </tbody>
</table>
[/#macro]

[#-- ======================================================================================== @build.configureBuildNotificationsForm --]

[#macro configureBuildNotificationsForm i18nPrefix="build.notification" showActionErrors=true groupEvents=false]
    [#if edit?has_content && edit=="true"]
        [#assign titleKey="${i18nPrefix}.edit.title" /]
    [#else]
        [#assign titleKey="${i18nPrefix}.add.title" /]
    [/#if]

    [@ui.bambooSection titleKey='${titleKey}' cssClass="add-notification-section"]
        [@commonNotificationFormContent showActionErrors groupEvents/]
        [#if edit?has_content]
            [@ww.hidden name='edit' /]
        [/#if]
    [/@ui.bambooSection]
[/#macro]

[#-- ======================================================================================== @build.configureSystemNotificationsForm --]

[#macro configureSystemNotificationsForm showActionErrors=true edit=false]
    [#if edit]
        [#assign titleKey="system.notification.edit.title" /]
    [#else]
        [#assign titleKey="system.notification.add.title" /]
    [/#if]

    [@ui.bambooSection titleKey=titleKey]
        [@commonNotificationFormContent showActionErrors/]
    [/@ui.bambooSection]
[/#macro]

[#-- ======================================================================================== @build.commonNotificationFormContent --]

[#macro commonNotificationFormContent showActionErrors=true groupEvents=false]
    [#if showActionErrors]
        [@ww.actionerror /]
    [/#if]

    [#if groupEvents]
        [@ww.select labelKey='notification.condition' name='conditionKey' toggle='true'
        listValue='name' listKey='key'
        optionDescription='description'
        list=allNotificationEventTypes groupBy="scope.displayName" /]
    [#else]
        [@ww.select labelKey='notification.condition' name='conditionKey' toggle='true'
        listValue='name' listKey='key'
        optionDescription='description'
        list=allNotificationEventTypes /]
    [/#if]

    [#list allNotificationEventTypes as condition]
        [@ui.bambooSection dependsOn='conditionKey' showOn='${condition.key}']
        ${condition.getEditHtml()}
        [/@ui.bambooSection]
    [/#list]

    [@ww.select labelKey='notification.recipients.types' name='notificationRecipientType'
    list=allNotificationRecipientTypes listKey='key' listValue='description' toggle='true'/]

    [#list allNotificationRecipientTypes as recipient]
        [@ui.bambooSection dependsOn='notificationRecipientType' showOn='${recipient.key}']
        ${recipient.getEditHtml()}
        [/@ui.bambooSection]
    [/#list]
[/#macro]
[#-- ====================================================================================== @build.configurePermissions --]

[#macro configurePermissions action cancelUri='' backLabelKey='']

<div class="aui-group permissionForm">
    <div class="aui-item formArea">
        [@ww.form action='${action}' submitLabelKey='global.buttons.update' id='permissions' cancelUri='${cancelUri}' backLabelKey='${backLabelKey}' cssClass='top-label']

                [#if buildKey??]
            [@ww.hidden name='buildKey' /]
        [#elseif immutablePlan??]
            [@ww.hidden name='buildKey' value='${immutablePlan.key}' /]
        [/#if]

                [#if buildIds?has_content]
            [#list buildIds as buildId]
                [@ww.hidden name='buildIds' value='${buildId}' /]
            [/#list]
        [/#if]

                [#if immutablePlan??]
            [@permissions.permissionsEditor immutablePlan.id /]
        [#else]
            [@permissions.permissionsEditor /]
        [/#if]
            [/@ww.form]
    </div>
    <div class="aui-item helpTextArea">
        <h3 class="helpTextHeading">[@ww.text name='build.permissions.type.heading' /]</h3>
        <ul>
            <li>
                <strong>[@ww.text name='build.permissions.type.view.heading' /]</strong> - [@ww.text name='build.permissions.type.view.description' /]
            </li>
            <li>
                <strong>[@ww.text name='build.permissions.type.edit.heading' /]</strong> - [@ww.text name='build.permissions.type.edit.description' /]
            </li>
            <li>
                <strong>[@ww.text name='build.permissions.type.build.heading' /]</strong> - [@ww.text name='build.permissions.type.build.description' /]
            </li>
            <li>
                <strong>[@ww.text name='build.permissions.type.clone.heading' /]</strong> - [@ww.text name='build.permissions.type.clone.description' /]
            </li>
            <li>
                <strong>[@ww.text name='build.permissions.type.admin.heading' /]</strong> - [@ww.text name='build.permissions.type.admin.description' /]
            </li>
        </ul>
        <div class="helpTextNote">
            <h4 class="helpTextHeading">[@ww.text name='build.permission.noteGlobalPermission.heading' /]</h4>
            <ul>
                <li>[@ww.text name='build.permission.noteGlobalPermission.description' /]</li>
            </ul>
        </div>
    </div>
</div>

[/#macro]

[#-- ======================================================================================== @build.liveActivity --]

[#macro liveActivity expandable=true]
    [@ww.url id='getBuildsUrl' namespace='/build/admin/ajax' action='getBuilds' /]
    [@ww.url id='getChangesUrl' value='/rest/api/latest/result/' /]
    [@ww.url id='unknownJiraType' value='/images/icons/jira_type_unknown.gif' /]
    [@ww.text id='queueEmptyText' name='job.liveactivity.noactivity'/]
    [@ww.text id='cancelBuildText' name='agent.build.cancel' /]
    [@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]
    [@ww.text id='noAdditionalInfoText' name='plan.liveactivity.build.noadditionalinfo' /]

<div id="liveActivity"[#if !expandable] class="no-expand"[/#if]>
    <p>${queueEmptyText}</p>
</div>
<script type="text/x-template" title="buildListItem-template">
    [@buildListItem buildResultKey="{buildResultKey}" cssClass="{cssClass}" triggerReason="{triggerReason}" buildingOn="{buildingOn}" planKey="{planKey}" buildMessage="{buildMessage}" /]
</script>
<script type="text/x-template" title="buildingOn-template">
    [@buildingOn agentId="{agentId}" agentType="{agentType}" agentName="{agentName}" /]
</script>
<script type="text/x-template" title="buildMessage-template">
    [@message type="{type}"]{text}[/@message]
</script>
<script type="text/x-template" title="jiraIssue-template">
    <li>
        <a title="View this issue" href="{url}?page=com.atlassian.jira.plugin.ext.bamboo%3Abamboo-build-results-tabpanel"><img alt="{issueType}" src="{issueIconUrl}" class="issueTypeImg"/></a>

        <h3><a href="{url}">{key}</a></h3>

        <p class="jiraIssueDetails">{details}</p>
    </li>
</script>
<script type="text/x-template" title="codeChange-changesetLink-template">
    <a href="{commitUrl}" class="revision-id">{changesetId}</a>
</script>
<script type="text/x-template" title="codeChange-changesetDisplay-template">
    <span class="revision-id">{changesetId}</span>
</script>
<script type="text/x-template" title="codeChange-template">
    <li>
        {changesetInfo}
        <img alt="{author}" src="[@ww.url value='/images/icons/businessman.gif' /]" class="profileImage"/>

        <h3><a href="${req.contextPath}/browse/{authorOrUser}/{author}">{displayName}</a></h3>

        <p>{comment}</p>
    </li>
</script>
<script type="text/javascript">
    AJS.$(function ($)
          {
              LiveActivity.init({
                                    planKey: "${immutableBuild.planKey}",
                                    container: $("#liveActivity"),
                                    getBuildsUrl: "${getBuildsUrl}",
                                    getChangesUrl: "${getChangesUrl}",
                                    queueEmptyText: "${queueEmptyText?js_string}",
                                    cancellingBuildText: "${cancellingBuildText?js_string}",
                                    noAdditionalInfoText: "${noAdditionalInfoText?js_string}",
                                    defaultIssueIconUrl: "${unknownJiraType?js_string}",
                                    defaultIssueType: "Unknown Issue Type",
                                    templates: {
                                        buildListItemTemplate: "buildListItem-template",
                                        buildingOnTemplate: "buildingOn-template",
                                        buildMessageTemplate: "buildMessage-template",
                                        jiraIssueTemplate: "jiraIssue-template",
                                        codeChangeTemplate: "codeChange-template",
                                        codeChangeChangesetLinkTemplate: "codeChange-changesetLink-template",
                                        codeChangeChangesetDisplayTemplate: "codeChange-changesetDisplay-template"[#if !expandable],
                                            toggleDetailsButton: null[/#if]
                                    }
                                });
          });
</script>
[/#macro]

[#-- ======================================================================================== @build.message --]

[#macro message type="informative"]
<div class="message ${type}">[#nested]</div>
[/#macro]

[#-- ======================================================================================== @build.buildListItem --]

[#macro buildListItem buildResultKey planKey cssClass triggerReason buildingOn="" buildMessage=""][#rt]
<li id="b${buildResultKey}" class="${cssClass}">
    <span class="build-description">[#rt]
        <strong><a href="${req.contextPath}/browse/${buildResultKey}">${buildResultKey}</a></strong> ${triggerReason}${buildingOn}[#t]
    </span>[#lt]
    <a id="stopBuild_${buildResultKey}" href="[@ww.url namespace='/build/admin/ajax' action='stopPlan' /]?planResultKey=${buildResultKey}" class="mutative build-stop">[@ui.icon type="build-stop" text=cancelBuildText /]</a>
${buildMessage}
    <div class="additional-information">
        <div class="issueSummary"><h2 class="jiraIssuesHeader">JIRA Issues</h2></div>
        <div class="changesSummary"><h2 class="codeChangesHeader">[@ww.text name='buildResult.changes.title' /]</h2>
        </div>
    </div>
</li>
[/#macro][#lt]

[#-- ======================================================================================== @build.buildingOn --]

[#macro buildingOn agentId agentType agentName][#rt]
<span class="agent-info"> - building on <strong><a href="[@ww.url namespace='/agent' action='viewAgent' /]?agentId=${agentId}" class="${agentType}">${agentName}</a></strong></span>
[/#macro][#lt]
