[#include "/fragments/decorator/htmlHeader.ftl"]
[#import "/lib/menus.ftl" as menu/]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<section id="content" role="main">
    [#include "/fragments/showAdminErrors.ftl"]
    <div class="aui-panel">
        [@ww.url value='/agent/viewAgents.action' id='agentsListUrl' /]
        [@agt.header /]
        [@agt.agentDetails headerKey='agent.details' agentId=agent.id showOptions="short" /]
        [@menu.displayTabbedContent location="agent.subMenu" selectedTab=page.properties["meta.tab"]]
            ${body}
        [/@menu.displayTabbedContent]
    </div>
</section>
[#include "/fragments/decorator/footer.ftl"]