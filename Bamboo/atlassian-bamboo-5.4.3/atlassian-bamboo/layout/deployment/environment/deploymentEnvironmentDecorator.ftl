[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.deployment"] /]
[#include "/fragments/showAdminErrors.ftl"]

[#assign selectedTab=(page.properties["meta.tab"])!'history']

${soy.render("bamboo.deployments:deployment-environment-layout", "bamboo.layout.deploymentEnvironment", {
    "environment": environment,
    "deploymentProject": deploymentProject,
    "content": body,
    "latestDeploymentResult": latestDeploymentResult!,
    "currentUrl": currentUrl
})}

[#include "/fragments/decorator/footer.ftl"]