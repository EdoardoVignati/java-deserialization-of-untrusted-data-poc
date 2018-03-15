[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.DeleteDeploymentProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.DeleteDeploymentProject" --]

<html>
<head>
[@ui.header pageKey="deployment.project.delete.title" title=true/]
    <meta name="bodyClass" content="aui-page-focused"/>
</head>
<body>

[@ui.header pageKey="deployment.project.delete.title" /]

[@ww.form action="deleteDeploymentProject"
namespace="/deploy/config"
submitLabelKey="global.buttons.confirm"
cancelUri=cancelUrl
]
    [@ui.messageBox type="warning" title=i18n.getText('deployment.project.delete.confirm', [deploymentProject.name]) /]

    [@ww.hidden name="id"/]
    [@ww.hidden name="cancelUrl"/]
[/@ww.form]

</body>
</html>

