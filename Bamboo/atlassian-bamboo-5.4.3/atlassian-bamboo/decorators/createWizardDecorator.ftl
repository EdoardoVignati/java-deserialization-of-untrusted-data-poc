[#import "/fragments/decorator/decorators.ftl" as decorators/]

[@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.configuration"] bodyClass="aui-page-focused aui-page-focused-xlarge" activeNavKey='create' /]
[#include "/fragments/showAdminErrors.ftl"]
[#assign step = page.properties["meta.tab"]!/]
[#assign prefix = page.properties["meta.prefix"]!"plan"/]
[#assign headerMainContent]
    <h1>[@ww.text name="plan.create.new.title" /]</h1>
[/#assign]

${soy.render("bamboo.layout.focused", {
    "headerMainContent": headerMainContent,
    "progressTrackerSteps": [
        {
            "text": action.getText("${prefix}.create.step.one.description"),
            "isCurrent": (step == "1")
        },
        {
            "text": action.getText("${prefix}.create.step.two.description"),
            "isCurrent": (step == "2")
        }
    ],
    "content": body
})}
[#include "/fragments/decorator/footer.ftl"]