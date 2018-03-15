[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.elastic.ViewOfflineElasticAgentDetailsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.elastic.ViewOfflineElasticAgentDetailsAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as eln]
<html>
<head>
    <title>
    [@ww.text name='elastic.agent.history.heading' /]
    - [@ww.text name='agent.view.heading.' + agent.type.identifier /]
    - ${agent.name?html}
    </title>

</head>

<body>
    [@ww.url value='/agent/viewAgents.action' id='agentsListUrl' /]
    [@eln.agentHistoryHeader agent=agent /]
    <p>
        [@ww.text name='elastic.agent.history.description' /]
    </p>
    [@agt.agentDetails headerKey='elastic.agent.history.details' agentId=agent.id showOptions="none" showStatus='no' refresh=false /]

    [@ui.clear /]

    [@ui.bambooPanel titleKey='elastic.agent.history.build.title' content=true]
        [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true" ]       
        [/@ww.action]
    [/@ui.bambooPanel]
</body>
</html>