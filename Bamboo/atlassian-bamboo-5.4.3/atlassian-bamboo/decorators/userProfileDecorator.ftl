[#import "/lib/menus.ftl" as menu/]
[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/showAdminErrors.ftl"]

[#assign headerMainContent]
    <h1>[@ww.text name="user.profile"/] [@ui.displayUserFullName user=ctx.getUser(req) /]</h1>
[/#assign]

${soy.render("bamboo.layout.base", {
    "headerMainContent": headerMainContent,
    "content": body,
    "navItems": menu.getNavItems(page.properties["meta.tab"], "system.user", "", true)
})}
[#include "/fragments/decorator/footer.ftl"]