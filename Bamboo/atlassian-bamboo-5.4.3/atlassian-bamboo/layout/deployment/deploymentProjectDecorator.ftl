[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.deployment"] /]
[#include "/fragments/showAdminErrors.ftl"]

[#function getNavItems selectedTab]
    [#local navItems = [] /]
    [#local label][@ww.text name="deployment.project.summary.nav"/][/#local]
    [#local navItems = navItems + [{
    "content": label,
    "linkId": "environments-nav-item",
    "href": req.contextPath + "/deploy/viewDeploymentProjectEnvironments.action?id=" + deploymentProject.id,
    "isSelected": (selectedTab == "environments")
    }] /]
    [#local label][@ww.text name="deployment.project.versions"/][/#local]
    [#local navItems = navItems + [{
    "content": label,
    "linkId": "versions-nav-item",
    "href": req.contextPath + "/deploy/viewDeploymentProjectVersions.action?id=" + deploymentProject.id,
    "isSelected": (selectedTab == "versions")
    }] /]
    [#local label][@ww.text name="deployment.project.details"/][/#local]
    [#return navItems /]
[/#function]

${soy.render("bamboo.deployments:deployment-project-layout", "bamboo.layout.deploymentProject", {
"deploymentProject": deploymentProject,
"content": body,
"navItems": getNavItems((page.properties["meta.tab"])!'environments')
})}

[#include "/fragments/decorator/footer.ftl"]