[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewInstancesForConfigurationAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewInstancesForConfigurationAction" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    [@ui.header pageKey="elastic.image.configuration.activeInstances" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>

    <h1>
 	   <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfigurations.action" id="elasticConfigurationsLink" title="[@ww.text name='elastic.image.configuration.list.heading' /]">[#t]
 	       [@ww.text name='elastic.image.configuration.list.heading' /]</a>&nbsp;&gt;&nbsp;[#t]
       <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${elasticImageConfiguration.id}">${elasticImageConfiguration.configurationName?html}</a>&nbsp;&gt;&nbsp;[#t]
            [@ww.text name='elastic.image.configuration.activeInstances'/]
 	</h1>

    <p>[@ww.text name='elastic.image.configuration.activeInstances.description']
            [@ww.param]${elasticImageConfiguration.configurationName?html}[/@ww.param]
            [@ww.param]${req.contextPath}/admin/elastic/manageElasticInstances.action[/@ww.param]
        [/@ww.text]</p>

    [@ww.actionerror /]
    <div class="buttons">
    <a href="[@ww.url action='prepareElasticInstances' namespace='/admin/elastic' elasticImageConfigurationId="${elasticImageConfiguration.id}"/]">[@ww.text name='elastic.manage.createAgents' /]</a>
    [#if anyElasticInstancesShutdownable]
        | <a id="shutdownAllElasticInstances" href="[@ww.url action='shutdownElasticInstancesForConfiguration.action' namespace='/admin/elastic/image/configuration' configurationId="${elasticImageConfiguration.id}" /]">[@ww.text name='elastic.manage.shutdown.all' /]</a>
    [/#if]
</div>

[#if elasticInstances?has_content]
    [@ela.listElasticInstances elasticInstances /]
[/#if]