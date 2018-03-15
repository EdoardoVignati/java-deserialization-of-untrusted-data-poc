[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[@ww.url id="artifactsTabUrl" value='/browse/${chainResult.planResultKey}/artifact' /]
[#assign sharedArtifactsFound = action.hasSharedArtifacts(chainResult)/]
[#assign limit=10/]
[#if sharedArtifactsFound]
<div id="shared-artifacts">
    <h2>[@ww.text name='artifact.shared.title'/]</h2>
    <table class="aui">
        <colgroup>
            <col>
            <col width="100px">
        </colgroup>
        <thead>
        <tr>
            <th>[@ww.text name="chain.artifacts.table.header"/]</th>
            <th>[@ww.text name="chain.artifacts.size"/]</th>
        </tr>
        </thead>
        <tbody>
            [#assign count = 0]
            [#list chainResult.stageResults as stageResult]
                [#list stageResult.getSortedBuildResults() as buildResult]
                    [#assign artifactLinks = action.getSharedArtifactLinks(buildResult)!/]
                    [#list artifactLinks as artifact]
                        [#if count lt limit]
                        <tr>
                            <td>
                            [@ui.icon type="artifact-shared" /]
                                [#assign artifactUrl=action.getArtifactLinkUrl(artifact)!/]
                                [#if artifactUrl?has_content]
                                    <a id="artifact-${artifact.label?html}" href="${artifactUrl}">${artifact.label?html}</a>
                                [#else]
                                    <span id="artifact-${artifact.label?html}">${artifact.label?html}</span>
                                [/#if]
                            </td>
                            <td>
                                [#if artifact.exists]
                                    [#if artifact.sizeDescription??]
                                        <span class="filesize">${artifact.sizeDescription}</span>
                                    [/#if]
                                [#else]
                                        <span class="filesize">[@ww.text name='buildResult.artifacts.not.exists' /]</span>
                                [/#if]
                            </td>
                        </tr>
                        [/#if]
                        [#assign count = count + 1]
                    [/#list]
                [/#list]
            [/#list]
        </tbody>
    </table>
    [#if count gt limit]
        <p>
            <a href="${artifactsTabUrl}">[@ww.text name='artifact.shared.showinglimit'][@ww.param value=count-limit/][/@ww.text]</a>
        </p>
    [/#if]
</div>
[/#if]