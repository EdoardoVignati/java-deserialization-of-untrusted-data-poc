[#if fn.hasAdminPermission() && ec2ConfigurationWarningRequired]
    [@ui.messageBox type="warning" icon=false]
        [@ww.text name="ec2.configuration.agent"]
            [@ww.param]http://confluence.atlassian.com/display/BAMBOO/About+Elastic+Bamboo[/@ww.param]
            [@ww.param][@ww.url action='viewElasticConfig' namespace='/admin/elastic' /][/@ww.param]
        [/@ww.text]
  	[/@ui.messageBox]
[/#if]

