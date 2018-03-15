[#import "/fragments/decorator/decorators.ftl" as decorators/]
[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general"] bodyClass="aui-page-focused aui-page-focused-medium" /]

${soy.render("bamboo.layout.base", {
    "content": body
})}
[#include "/fragments/decorator/footer.ftl"]