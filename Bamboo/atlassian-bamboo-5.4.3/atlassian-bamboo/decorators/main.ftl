[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/showAdminErrors.ftl"]
${soy.render("bamboo.layout.base", {
    "content": body
})}
[#include "/fragments/decorator/footer.ftl"]