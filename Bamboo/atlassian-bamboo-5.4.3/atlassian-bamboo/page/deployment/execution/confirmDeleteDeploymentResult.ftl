[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.execution.actions.DeleteDeploymentResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.execution.actions.DeleteDeploymentResult" --]

<html>
<head>
    <meta name="bodyClass" content="aui-page-focused"/>
</head>
<body>

[@ww.form action="deleteDeploymentResult"
          namespace="/deploy"
          submitLabelKey="global.buttons.delete"
          cancelUri=cancelUrl
]
    [#if deploymentResult.operations.canDelete]
        [#if deploymentResultCurrentlyDeployed]
            [@ui.messageBox type="warning"]
                [@ww.text name="deployment.result.delete.currently.deployed.confirm.message"]
                    [@ww.param]${deploymentVersion.name?html}[/@ww.param]
                    [@ww.param value=environment.name /]
                [/@ww.text]
            <p>[@ww.text name="deployment.result.delete.confirm"/]</p>
            [/@ui.messageBox]
        [#else]
            [@ui.messageBox type="warning"]
                [@ww.text name="deployment.result.delete.confirm.message"]
                    [@ww.param]${deploymentVersion.name?html}[/@ww.param]
                    [@ww.param value=environment.name /]
                [/@ww.text]
                <p>[@ww.text name="deployment.result.delete.confirm"/]</p>
            [/@ui.messageBox]
        [/#if]
    [/#if]

    [@ww.hidden name="deploymentResultId"/]
    [@ww.hidden name="cancelUrl"/]
[/@ww.form]

</body>
</html>
