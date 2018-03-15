[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]

<html>
<head>
	[@ui.header pageKey='buildResult.artifacts.title' object='${immutableBuild.name} ${buildResultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="artifacts"/>
</head>

<body>
    [@dj.simpleDialogForm
        triggerSelector="#removeBuildArtifacts"
        actionUrl="/ajax/confirmRemoveAllArtifacts.action?planKey=${planKey}&buildNumber=${buildNumber}"
        width=400 height=200
        submitLabelKey="global.common.yes"
    /]

    [#if fn.hasPlanPermission('ADMINISTRATION', immutableBuild)]
        [#if anyJobArtifact]
            <div class="aui-toolbar inline toolbar">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a id="removeBuildArtifacts" class="toolbar-trigger"
                           title="[@ww.text name='artifact.removeAllJob' /]">[@ww.text name='artifact.removeAllJob' /]</a>
                    </li>
                </ul>
            </div>
        [/#if]
    [/#if]

    [@ui.header pageKey='chain.artifacts.header' /]

    [#assign hasAdminPermission = fn.hasPlanPermission('ADMINISTRATION', immutablePlan)/]
    [@ui.bambooPanel titleKey='buildResult.artifacts.build.title' ]
        [#assign artifacts = artifactLinks /]
        [#if artifacts?has_content]
            <p>[@ww.text name='buildResult.artifacts.description' /]</p>
            <table id="artifacts" class="aui artifact">
                <colgroup>
                    <col width="85%"/>
                    <col width="15%"/>
                </colgroup>
                <thead>
                    <tr>
                        <th>[@ww.text name='artifact.name'/]</th>
                        <th>[@ww.text name='artifact.size'/]</th>
                    </tr>
                </thead>
                <tbody>
                    [#list artifacts as artifact]
                        <tr id="artifact-${artifact.id}">
                            <td>
                                [#if artifact.sharedArtifact]
                                    [@ui.icon type="artifact-shared"/]
                                [#else]
                                    [@ui.icon type="artifact"/]
                                [/#if]
                                [#assign artifactUrl=action.getArtifactLinkUrl(artifact)!/]
                                [#if artifactUrl?has_content]
                                    <a href="${artifactUrl}">${artifact.label?html}</a>
                                [#else]
                                    <span class="grey">${artifact.label?html}</span>
                                [/#if]
                            </td>
                            <td>
                                [#if artifact.exists]
                                    [#if artifact.sizeDescription??]
                                        <span class="subGrey">${artifact.sizeDescription}</span>
                                    [/#if]
                                [#else]
                                    <span class="subGrey">[@ww.text name='buildResult.artifacts.not.exists' /]</span>
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                </tbody>
            </table>
        [#else]
            [#if resultsSummary.active]
                <p>[@ww.text name='buildResult.artifacts.description.running' /]</p>
            [#else]
                <p>[@ww.text name='buildResult.artifacts.empty' /]</p>
            [/#if]
        [/#if]
        [#if !resultsSummary.active && fn.hasPlanPermission('WRITE', immutableBuild)]
            [#if anyJobArtifact]
                <p><strong>[@ww.text name='artifact.server.path' /]</strong></p>
                <pre class="artifact-location">${artifactPath}</pre>
            [/#if]
            [#if anySharedArtifact]
                <p><strong>[@ww.text name='artifact.shared.server.path' /]</strong></p>
                <pre class="artifact-location">${sharedArtifactPath}</pre>
            [/#if]
        [/#if]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='buildResult.artifacts.consumed.title' ]
        [#assign artifacts = consumedSubscriptions /]
        [#if artifacts.keySet().size() > 0]
            <p>[@ww.text name='buildResult.artifacts.consumed.description' /]</p>
            <table id="consumedSubscriptions" class="aui artifact">
                <colgroup>
                    <col width="20%"/>
                    <col width="45%"/>
                    <col width="15%"/>
                    <col width="20%"/>
                </colgroup>
                <thead>
                    <tr>
                        <th>[@ww.text name='artifact.name'/]</th>
                        <th>[@ww.text name='artifact.subscription.destination'/]</th>
                        <th>[@ww.text name='artifact.size'/]</th>
                        <th>[@ww.text name='artifact.job'/]</th>
                    </tr>
                </thead>
                <tbody>
                    [#list artifacts.keySet() as jobSummary]
                        [#assign jobSummarySubscriptions = artifacts.get(jobSummary)]
                        [#list jobSummarySubscriptions as subscription]
                            <tr id="subscription-${subscription.id}">
                                <td>
                                    [#assign artifactUrl=action.getArtifactLinkUrl(subscription.artifactLink)!/]
                                    [#if artifactUrl?has_content ]
                                        [@ui.icon type="artifact-shared"/] <a id="subscriptionName-${subscription.id}" href="${artifactUrl}">${subscription.artifactLink.label}</a>
                                    [#else]
                                        [@ui.icon type="artifact-shared"/] <span class="grey">${subscription.artifactLink.label}</span>
                                    [/#if]
                                </td>
                                <td>
                                    [#if subscription.destinationDirectory?has_content]
                                        ${subscription.destinationDirectory}
                                    [#else]
                                        <span class="subGrey">[@ww.text name="artifact.subscription.destination.default"/]</span>
                                    [/#if]
                                </td>
                                <td>
                                    [#if subscription.artifactLink.exists]
                                        [#if subscription.artifactLink.sizeDescription??]
                                            <span class="subGrey">${subscription.artifactLink.sizeDescription}</span>
                                        [/#if]
                                    [#else]
                                        <span class="subGrey">[@ww.text name='buildResult.artifacts.not.exists' /]</span>
                                    [/#if]
                                </td>
                                <td>
                                    [#if subscription.artifactLink.producerJobResult??]
                                        <a id="producerJob-${subscription.consumerResultSummary.planResultKey}" href="${req.contextPath}/browse/${subscription.artifactLink.producerJobResult.planResultKey}/artifact">${subscription.artifactLink.producerJobResult.immutablePlan.buildName}</a>
                                        <span class="subGrey">${subscription.artifactLink.producerJobResult.immutablePlan.stage.name}</span>
                                        [#else]
                                            <span class="grey">[@ww.text name="artifact.deletedJob"/]</span>
                                    [/#if]
                                </td>
                            </tr>
                        [/#list]
                    [/#list]
                </tbody>
            </table>
        [#else]
            <p>[@ww.text name='buildResult.artifacts.consumed.empty' /]</p>
        [/#if]
    [/@ui.bambooPanel]

    [@ui.renderWebPanels 'job.result.artifacts'/]
</body>
</html>
