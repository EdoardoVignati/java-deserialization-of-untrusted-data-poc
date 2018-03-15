[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.DeleteEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.DeleteEnvironment" --]

<html>
<head>
    [@ui.header pageKey="deployment.environment.delete.title" title=true/]
    <meta name="bodyClass" content="aui-page-focused"/>
</head>
<body>

[@ui.header pageKey="deployment.environment.delete.title" /]

[@ww.form action="deleteEnvironment"
          namespace="/deploy"
          submitLabelKey="global.buttons.confirm"
          cancelUri=cancelUrl
]
    [@ui.messageBox type="warning" title=i18n.getText('deployment.environment.delete.confirm', [environment.name]) /]

    [@ww.hidden name="id"/]
    [@ww.hidden name="cancelUrl"/]
[/@ww.form]

</body>
</html>

