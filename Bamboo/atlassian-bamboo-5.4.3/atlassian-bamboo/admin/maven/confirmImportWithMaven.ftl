[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCreatePlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ImportMavenPlanCreatePlanAction" --]
<html>
<head>
    [@ui.header pageKey='plan.create.maven.title' title=true /]
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
    [@ui.header pageKey="plan.create.maven.title" descriptionKey='importWithMaven.confirm.description' /]
    
    [@ww.form action='importMavenPlanCreatePlan' namespace='/build/admin/create'
              method="post" enctype="multipart/form-data"
              titleKey='importWithMaven.confirm.title'
              submitLabelKey='global.buttons.confirm'
               cancelUri='/start.action'
    ]
        [#-- Plan details --]
        [@ui.bambooSection]
            [#include "/fragments/project/selectCreateProject.ftl"]
            [#include "/fragments/chains/editChainKeyName.ftl"]
            [@ww.select labelKey='importWithMaven.executable.type' name='tmp.mavenExecutable' list=availableMavenBuilders.keySet() /]
        [/@ui.bambooSection]

        [#-- Repository information details --]
        [@ui.bambooSection titleKey='repository.title']

            [#-- Source repository --]
            [@ww.select labelKey='repository.type' name='selectedRepository' id='selectedRepository' toggle='true'
                list='repositories' listKey='key' listValue='name']
            [/@ww.select]

            [#list repositories as repository]
                [@ui.bambooSection dependsOn='selectedRepository' showOn='${repository.key}']
                    ${repository.getMinimalEditHtml(buildConfiguration)!}
                [/@ui.bambooSection]
            [/#list]


            [#-- Web repository viewer --]
            [@ww.select labelKey='webRepositoryViewer.type' id='selectedWebRepositoryViewer' name='selectedWebRepositoryViewer' toggle='true'
                            list='uiConfigBean.webRepositoryViewers' listKey='key' listValue='name']
            [/@ww.select]

            [#list uiConfigBean.webRepositoryViewers as viewer]
                [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn='${viewer.key}']
                    ${viewer.getEditHtml(buildConfiguration, mutablePlan)!}
                [/@ui.bambooSection]
            [/#list]

        [/@ui.bambooSection]

        [#-- Notification details --]
        [@ui.bambooSection titleKey='notification.title']
            [#if notificationSet.notificationRules?has_content]
                <table id="notificationTable" class="aui">
                    <colgroup>
                        <col width="40%">
                        <col>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>[@ww.text name='bulkAction.notification.eventHeading' /]</th>
                            <th>[@ww.text name='bulkAction.notification.recipientHeading' /]</th>
                        </tr>
                    </thead>
                    <tbody>
                    [#list notificationSet.sortedNotificationRules  as notification]
                        [#-- Setting the newRow group variable --]
                        [#if notification.notificationTypeForView?has_content]
                             [#if notification.notificationTypeForView.getViewHtml()?has_content]
                                   [#assign thisNotificationType=notification.notificationTypeForView.getViewHtml() /]
                             [#else]
                                   [#assign thisNotificationType=notification.notificationTypeForView.name /]
                             [/#if]
                        [#else]
                             [#assign thisNotificationType=notification.conditionKey! /]
                        [/#if]

                        [#if !lastNotificationType?has_content || lastNotificationType != thisNotificationType]
                            [#assign newRow = true /]
                        [#else]
                            [#assign newRow = false /]
                        [/#if]

                        [#assign lastNotificationType=thisNotificationType /]

                        <tr [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if] >
                            <td>
                                [#if newRow]${thisNotificationType}[/#if]
                            </td>
                            <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[/#if]>
                                [#if notification.notificationRecipient?has_content]
                                    [#if notification.notificationRecipient.getViewHtml()?has_content]
                                        ${notification.notificationRecipient.getViewHtml()}
                                    [#else]
                                        ${notification.notificationRecipient.description}
                                    [/#if]
                                [#else]
                                       ${notification.recipientType!}: ${notification.recipient!}
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                    </tbody>
                </table>
            [#else]
                <p>[@ww.text name='notification.empty' /]</p>
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="plan.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='tmp.createAsEnabled' descriptionKey='plan.create.enable.description'/]
        [/@ui.bambooSection]
        [#--More fields to edit the parsed plan details to go here...?--]
    [/@ww.form]

    <script type="text/javascript">
        AJS.$(function ($) {
            var mutateSelectedWebRepo = function () {
                    BAMBOO.DynamicFieldParameters.mutateSelectListContent($(this), $('#selectedWebRepositoryViewer'), $.parseJSON('${uiConfigBean.webRepositoryJson}'));
                },
                $selectedRepository = $('#selectedRepository').change(mutateSelectedWebRepo);

            mutateSelectedWebRepo.call($selectedRepository);
        });
    </script>
</body>
</html>
