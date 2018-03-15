[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.deployment"] /]
[#include "/fragments/showAdminErrors.ftl"]

[#assign statusLabel]
    [@ww.text name="deployment.version.status"/]
[/#assign]
[#assign commitsLabel]
    [@ww.text name="deployment.version.commits"/]
[/#assign]
[#assign issuesLabel]
    [@ww.text name="deployment.version.issues"/]
[/#assign]
[#assign variablesLabel]
    [@ww.text name="deployment.version.variables"/]
[/#assign]

[#assign selectedTab = page.properties["meta.tab"]!"status"/]

[#assign commitsUrl]
${req.contextPath}/deploy/viewDeploymentVersionCommits.action?versionId=${deploymentVersion.id}&deploymentProjectId=${deploymentProject.id}[#if compareWithVersionId?has_content]&compareWithVersionId=${compareWithVersionId}[/#if]
[/#assign]

[#assign issuesUrl]
${req.contextPath}/deploy/viewDeploymentVersionJiraIssues.action?versionId=${deploymentVersion.id}&deploymentProjectId=${deploymentProject.id}&pageSize=25[#if compareWithVersionId?has_content]&compareWithVersionId=${compareWithVersionId}[/#if]
[/#assign]

${soy.render("bamboo.deployments:deployment-project-layout", "bamboo.layout.deploymentVersion", {
    "deploymentVersion": deploymentVersion,
    "deploymentProject": deploymentProject,
    "content": body,
    "navItems": [{  "content": statusLabel,
                    "linkId": "status-nav-item",
                    "href": req.contextPath + '/deploy/viewDeploymentVersion.action?versionId=' + deploymentVersion.id + '&deploymentProjectId=' + deploymentProject.id,
                    "isSelected": (selectedTab == "status")
                 },
                 {
                    "content": commitsLabel,
                    "linkId": "commits-nav-item",
                    "href" : commitsUrl,
                    "isSelected": (selectedTab == "commits"),
                    "badge" : {"text": "${commitCount!}"}
                 },
                 {
                    "content": issuesLabel,
                    "linkId": "issues-nav-item",
                    "href" : issuesUrl,
                    "isSelected": (selectedTab == "issues"),
                    "badge" : {"text": "${issueCount!}"}
                 },
                 {
                    "content": variablesLabel,
                    "linkId": "variables-nav-item",
                    "href" : req.contextPath + '/deploy/viewDeploymentVersionVariables.action?versionId=' + deploymentVersion.id + '&deploymentProjectId=' + deploymentProject.id,
                    "isSelected": (selectedTab == "variables")
                 }]
})}

<script type="text/javascript">
    new BAMBOO.DEPLOYMENT.DeploymentVersion({
        versionId: ${deploymentVersion.id}
    });
</script>

[#include "/fragments/decorator/footer.ftl"]