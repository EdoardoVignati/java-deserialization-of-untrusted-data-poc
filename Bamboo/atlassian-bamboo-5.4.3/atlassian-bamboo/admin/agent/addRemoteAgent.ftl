[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.AddRemoteAgent" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.AddRemoteAgent" --]
[#assign ver = webwork.bean("com.atlassian.bamboo.util.BuildUtils")]
<html>
<head>
    <title>[@ww.text name='agent.remote.add' /]</title>
    <meta name="decorator" content="adminpage">
    <style type="text/css">
        #remoteAgentHelp em{
            color: green;
        }
    </style>
</head>

<body>

    <!-- Agent installation -->
    <h1>[@ww.text name='agent.remote.add.heading' /]</h1>

    [@ww.text name='agent.remote.add.description'/]

    <p class="fullyCentered"><a href="${req.contextPath}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-${ver.getCurrentVersion()}.jar"><img src="${req.contextPath}/images/download_remote_agent_button.png" alt="Download"/></a></p>

    <h1>[@ww.text name='agent.remote.run.heading' /]</h1>

    <div id="remoteAgentHelp">
    [@ww.text name='agent.remote.run.description']
        [@ww.param]atlassian-bamboo-agent-installer[/@ww.param]
        [@ww.param]${ver.getCurrentVersion()}[/@ww.param]
        [@ww.param]${baseUrl}[/@ww.param]
        [@ww.param][@help.href pageKey="agent.remote.installation"/][/@ww.param]
    [/@ww.text]
    [#if baseUrl?starts_with("https:")]
        [@ww.text name='agent.remote.run.sslwarning']
            [@ww.param]atlassian-bamboo-agent-installer[/@ww.param]
            [@ww.param]${ver.getCurrentVersion()}[/@ww.param]
            [@ww.param]${baseUrl}[/@ww.param]
        [/@ww.text]
    [/#if]

    <h3>[@ww.text name='agent.remote.run.legacy.title' /]</h3>
    <p>
    [@ww.text name='agent.remote.run.legacy.description']
        [@ww.param]${ver.getCurrentVersion()}[/@ww.param]
        [@ww.param][@help.href pageKey="agent.remote.installation.jaronly"/][/@ww.param]
    [/@ww.text]
    </p>
    </div>

</body>
</html>