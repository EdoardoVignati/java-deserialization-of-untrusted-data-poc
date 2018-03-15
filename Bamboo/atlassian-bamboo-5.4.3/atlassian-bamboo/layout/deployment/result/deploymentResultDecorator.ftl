[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.deployment"] /]
[#include "/fragments/showAdminErrors.ftl"]

${soy.render("bamboo.deployments:deployment-result-layout", "bamboo.layout.deploymentResult", {
"environment": environment,
"deploymentProject": deploymentProject,
"deploymentResult": deploymentResult,
"content": body
})}

[#include "/fragments/decorator/footer.ftl"]