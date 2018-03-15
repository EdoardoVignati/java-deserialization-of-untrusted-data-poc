[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='elastic.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@ui.header pageKey='elastic.manage.create.title' descriptionKey="elastic.manage.create.description" /]

    [#assign startElasticInstanceFormDesc]
        [@ww.text name="elastic.manage.create.form.description" ]
            [@ww.param value='${runningElasticInstances.size()}' /]
            [@ww.param value='${requestedElasticInstances.size()}' /]
        [/@ww.text]
    [/#assign]

    [@ww.form action="createElasticInstances.action"
              namespace="/admin/elastic/"
              id="createElasticInstancesForm"
              cancelUri='/admin/elastic/manageElasticInstances.action'             
              titleKey='elastic.manage.create.form.title'
              showActionErrors='false'
              description=startElasticInstanceFormDesc]

    [#if !baseUrlMatchesRequestUrl]
        [@ui.messageBox type="warning"]
            [@ww.text name="elastic.manage.create.warningBaseUrlMismatch" ]
                [@ww.param]${baseUrl}[/@ww.param]
                [@ww.param]${req.contextPath}/admin/configure!default.action[/@ww.param]
            [/@ww.text]
        [/@ui.messageBox]
    [/#if]

    [@ww.actionerror /]

    [#if agentCreationPossible]
        [@ww.textfield labelKey='elastic.manage.create.number' name="numAgentsToCreate" required="true" /]
        [@ww.param name='submitLabelKey']${action.getText('global.buttons.submit')}[/@ww.param]
        [@ww.select title='elastic.manage.create.configuration.description' name='elasticImageConfigurationId' labelKey='elastic.manage.create.configuration' list=elasticImageConfigurations listKey='id' listValue='configurationName' toggle='false'/]
    [#elseif !elasticImageConfigurations?has_content]
        [@ui.messageBox type="error"]
            [@ww.text name='elastic.manage.create.warningNoConfigurations']
                [@ww.param][@ww.url action='viewElasticImageConfigurations' namespace='/admin/elastic/image/configuration'/][/@ww.param]
            [/@ww.text]
        [/@ui.messageBox]
    [/#if]

    [/@ww.form]
</body>
</html>