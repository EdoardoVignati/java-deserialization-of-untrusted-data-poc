[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    <title>[@ww.text name='elastic.configure.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
<h1>[@ww.text name='elastic.configure.title' /]</h1>

<p>
    <img src="${req.contextPath}/images/jt/icn32_elastic_cloud.gif" style="float: left; margin-right: 5px" width="32" height="32"/>[@ww.text name='elastic.configure.blurb'][@ww.param][@help.href pageKey="elastic.intro.generic"/][/@ww.param][@ww.param][@help.href pageKey="elastic.intro.bamboo"/][/@ww.param][/@ww.text]
</p>

<p>[@ww.text name='elastic.configure.view.description' /]</p>

[#if actionErrors?has_content]
    [@ww.actionerror /]
[#else]
    [#if elasticConfig?? && elasticConfig.enabled]
        [#if showHint]
            [@ui.messageBox type="success" titleKey='elastic.configure.hint.first']
            <p>[@ww.text name='elastic.configure.hint']
                [@ww.param]${req.contextPath}/admin/elastic/manageElasticInstances.action[/@ww.param]
                [@ww.param]${req.contextPath}/admin/elastic/prepareElasticInstances.action[/@ww.param]
                [@ww.param][@help.href pageKey="elastic.intro.bamboo"/][/@ww.param]
            [/@ww.text]</p>
            [/@ui.messageBox]
        [/#if]

        [@ui.bambooPanel titleKey='elastic.configure.form.title']
            [@ww.label labelKey='elastic.configure.field.awsAccessKeyId' value='${elasticConfig.awsAccessKeyId}' /]
        [/@ui.bambooPanel]

        [@ui.bambooPanel titleKey="elastic.configure.server.title"]
            [@ww.label labelKey='elastic.configure.field.region' value='${elasticConfig.region.displayName}' /]
            [@ww.label labelKey='elastic.configure.field.maxConcurrentInstances' value='${elasticConfig.maxConcurrentInstances}' /]

            [#if elasticConfig.autoShutdownEnabled]
                [@ww.text name='elastic.configure.view.autoShutdown' id='autoShutdownMessage']
                    [@ww.param]${elasticConfig.autoShutdownDelay}[/@ww.param]
                [/@ww.text]
                [@ww.label labelKey='elastic.configure.field.autoShutdown' value='${autoShutdownMessage}' /]
            [#else]
                [@ww.label labelKey='elastic.configure.field.autoShutdown' escape='false']
                    [@ww.param name="value"][@ww.text name='elastic.configure.view.autoShutdown.disabled'/][/@ww.param]
                [/@ww.label]
            [/#if]
        [/@ui.bambooPanel]

        [#assign elasticConfigureInstanceDescription]
            [#if elasticConfig.uploadingOfAwsAccountDetailsEnabled]
                [@ww.text name='elastic.configure.view.upload'/]
                [@ww.text name='elastic.configure.view.files']
                    [@ww.param]${elasticConfig.awsPrivateKeyFile}[/@ww.param]
                    [@ww.param]${elasticConfig.awsCertFile}[/@ww.param]
                [/@ww.text]
            [#else]
                [@ww.text name='elastic.configure.view.noupload'/]
                [#if elasticConfig.awsPrivateKeyFile?has_content && elasticConfig.awsCertFile?has_content]
                    [@ww.text name='elastic.configure.view.files']
                        [@ww.param]${elasticConfig.awsPrivateKeyFile}[/@ww.param]
                        [@ww.param]${elasticConfig.awsCertFile}[/@ww.param]
                    [/@ww.text]
                [/#if]
            <p>[@ww.text name='elastic.configure.view.upload.disabled' /]</p>
            [/#if]
        [/#assign]

        [@ui.bambooPanel titleKey="elastic.configure.spot.instances.title" ]
            [#if elasticConfig.spotInstanceConfig.enabled]
                [@ww.text name='core.dateutils.minute.any' id="fieldSpotInstancesTimeoutMinutesDurationName"]
                    [@ww.param value=fieldSpotInstancesTimeoutMinutes/]
                [/@ww.text]
                [@ww.label labelKey='elastic.configure.spot.instances.fallback' value='${fieldSpotInstancesTimeoutMinutes} ${fieldSpotInstancesTimeoutMinutesDurationName}' /]
            <h3>[@ww.text name='elastic.configure.spot.instances.current.bids' /]</h3>
                [@ela.displaySpotPrices editMode=false confElasticCloudAction=action/]
            [#else]
            <p>[@ww.text name='elastic.configure.spot.instances.disabled'/]</p>
            [/#if]
        [/@ui.bambooPanel]

        [@ui.bambooPanel titleKey="elastic.configure.credentials.config.title" description=elasticConfigureInstanceDescription /]

        [@ui.bambooPanel titleKey="elastic.configure.virtual.private.cloud.title"]
            [#if elasticIpManagementEnabled]
            <p>[@ww.text name='elastic.configure.virtual.private.cloud.eip.management.enabled'/]</p>
                [#if ignoredEips?has_content]
                <p>[@ww.text name='elastic.configure.virtual.private.cloud.ignored.eips.text'/]:</p>
                <ul>
                    [#list ignoredEips as ignoredEip]
                        <li>${ignoredEip}</li>
                    [/#list]
                </ul>
                [/#if]
            [#else]
            <p>[@ww.text name='elastic.configure.virtual.private.cloud.eip.management.disabled'/]</p>
            [/#if]
        [/@ui.bambooPanel]

        [#assign elasticConfigureAutomaticInstanceManagementDescription]
            [#if elasticConfig.automaticInstanceManagementConfig.automaticInstanceManagementEnabled]
                [@ww.text name='elastic.configure.field.automaticInstanceManagement.params']
                    [@ww.param value=fieldInstanceIdleTimeThreshold /]
                    [@ww.param value=fieldMaxElasticInstancesToStartAtOnce /]
                    [@ww.param value=fieldTotalBuildInQueueThreshold /]
                    [@ww.param value=fieldElasticBuildsInQueueThreshold /]
                    [@ww.param value=fieldAverageTimeInQueueThreshold /]
                    [@ww.param value=fieldMaxNonBambooInstances /]
                [/@ww.text]
            [#else]
            <p>[@ww.text name='elastic.configure.view.automaticInstanceManagement.disabled'/]</p>
            [/#if]
        [/#assign]
        [@ui.bambooPanel titleKey="elastic.configure.automatic.instance.management.title"]${elasticConfigureAutomaticInstanceManagementDescription}[/@ui.bambooPanel]

        [@ww.form
        action='editElasticConfig'
        submitLabelKey='global.buttons.edit'
        showActionErrors='false'
        cssClass='top-label'
        ]
            [@ww.param name='buttons']
                [@cp.displayLinkButton buttonId="disableButton" buttonLabel="global.buttons.disable" buttonUrl="${req.contextPath}/admin/elastic/confirmDisableElasticConfig.action" /]
            [/@ww.param]
        [/@ww.form]
    [#else]
        [@ww.form action='enableElasticConfig' titleKey='elastic.configure.form.title' submitLabelKey='global.buttons.enable' showActionErrors='false' cssClass='top-label']
        <p>
            [#if elasticConfig??]
                        [@ww.text name='elastic.configure.disabled' /]
                    [#else]
                [@ww.text name='elastic.configure.nonexistent' /]
            [/#if]
        </p>
        [/@ww.form]
    [/#if]
[/#if]
</body>
</html>
