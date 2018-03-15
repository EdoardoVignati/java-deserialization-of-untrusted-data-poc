[#import "/fragments/decorator/decorators.ftl" as decorators/]
[#import "/lib/menus.ftl" as menu/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general"] activeNavKey="authors" /]
[#include "/fragments/showAdminErrors.ftl"]

[#assign headerMainContent]
    <h1 id="authors-page-title">[@ww.text name="authors.title"/]</h1>
[/#assign]

${soy.render("bamboo.layout.base", {
    "headerMainContent": headerMainContent,
    "content": body,
    "navItems": menu.getNavItems(page.properties["meta.tab"], "system.authors", "", true)
})}
[#include "/fragments/decorator/footer.ftl"]