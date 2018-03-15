[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.deployment"] /]
[#include "/fragments/showAdminErrors.ftl"]
${soy.render("bamboo.deployments:deployments-main", "bamboo.layout.deployment", {
    "content": body,
    "pageHelpPanels": helpPanels
})}
[#include "/fragments/decorator/footer.ftl"]