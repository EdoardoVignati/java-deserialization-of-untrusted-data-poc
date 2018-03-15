[#macro displaySubscribersAndProducersByStage subscribedJobs dependenciesDeletionMessage headerWeight='h2']
    [#if subscribedJobs.size() > 0]
    <div id="artifact-delete-dependencies">
        <${headerWeight}>[@ww.text name="artifact.consumed.title"/]</${headerWeight}>
        <p>${dependenciesDeletionMessage}</p>
        <ul id="artifact-delete-navigator">
            [#list subscribedJobs.keySet() as stage]
                <li>
                    <h4>${stage.name?html}</h4>
                    <ul>
                        [#list subscribedJobs.get(stage) as job]
                            <li id="job-${job.key}" class="[#if (job.suspendedFromBuilding)!false] disabled[/#if]">
                                <a id="navJob_${job.key}" href="${req.contextPath}/build/admin/edit/defaultBuildArtifact.action?buildKey=${job.key}">[@ui.icon "job"/]${job.buildName}</a>
                            </li>
                        [/#list]
                    </ul>
                </li>
            [/#list]
        </ul>
    </div>
    [/#if]
[/#macro]

[#macro displayRelatedDeploymentProjects deploymentProjects messageKey showHeader=true headerWeight='h2']
    [#if deploymentProjects?has_content]
        [#if showHeader]<${headerWeight}>[@ww.text name="artifact.consumed.deployment.title"/]</${headerWeight}>[/#if]
        <p>[@ww.text name=messageKey/]</p>
        <ul id="deployment-unlink-navigator">
            [#list deploymentProjects as deploymentProject]
                <li>
                    <h4>${deploymentProject.name}</h4>
                </li>
            [/#list]
        </ul>
    [/#if]
[/#macro]