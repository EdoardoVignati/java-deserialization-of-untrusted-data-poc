[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewOfflineElasticAgentDetailsAdminAction" --]
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

    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ww.url namespace='/admin/elastic' action='viewElasticAgentHistory' id='elasticHistoryUrl' /]
    [@eln.agentHistoryHeader agent=agent historyUrl=elasticHistoryUrl /]
    <p>
        [@ww.text name='elastic.agent.history.description' /]
    </p>

    [@agt.agentDetails headerKey='elastic.agent.history.details' agentId=agent.id showOptions="none" showStatus='no' refresh=false /]

    [@ui.clear /]

    [@ui.bambooPanel titleKey='elastic.agent.history.build.title' content=true]

        <p>
            [@ww.text name='elastic.agent.history.utilisation' ]
                [@ww.param]<strong>${action.utilisation?string("0.##%")}</strong>[/@ww.param]
            [/@ww.text]
        </p>

        [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true" ]
        [/@ww.action]
    [/@ui.bambooPanel]
</body>
</html>