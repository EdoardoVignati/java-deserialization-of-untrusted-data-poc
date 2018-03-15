[#include "/fragments/decorator/htmlHeader.ftl"]

${soy.render("bamboo.layout.dashboard", {
             "instanceName": instanceName?html,
             "content": "${body}"
})}

[#include "/fragments/decorator/footer.ftl"]
