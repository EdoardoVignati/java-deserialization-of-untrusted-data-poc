[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.DeleteDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.DeleteDeploymentVersion" --]

<html>
<head>
    [@ui.header pageKey="deployment.version.delete.title" title=true/]
    <meta name="bodyClass" content="aui-page-focused"/>
</head>
<body>

[@ww.form action="deleteDeploymentVersion"
          namespace="/deploy"
          submitLabelKey="global.buttons.delete"
          cancelUri=cancelUrl
]
    [@ui.messageBox type="warning"][@ww.text name='deployment.version.delete.confirm'][@ww.param]${deploymentVersion.name?html}[/@ww.param][/@ww.text][/@ui.messageBox]

    [@ww.hidden name="versionId"/]
    [@ww.hidden name="cancelUrl"/]
[/@ww.form]

</body>
</html>

