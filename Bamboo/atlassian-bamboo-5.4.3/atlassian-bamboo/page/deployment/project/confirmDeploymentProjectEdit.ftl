[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectDetails" --]

[#if id gt 0]
    [#assign postfix="update"/]
[#else]
    [#assign postfix="create"/]
[/#if]

<html>
<head>
[@ui.header pageKey="deployment.project.${postfix}" title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>


<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.howtheywork"][@ww.text name="deployments.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey="deployment.project.${postfix}" /]

[#if id gt 0]
    [#assign cancelUri="/deploy/config/configureDeploymentProject.action?id=" + id /]
[#else]
    [#assign cancelUri="/deploy/viewAllDeploymentProjects.action" /]
[/#if]
[#assign deploymentProjectNameId = 'deploymentProjectName' /]

[@ww.form action="saveConfirmedDeploymentProjectDetails" namespace="/deploy/config" submitLabelKey="deployment.project.${postfix}.button" cancelUri=cancelUri]

    [@ww.hidden name="id" /]
    [@ww.hidden name="masterPlanKey"/]
    [@ww.hidden name="branchKey"/]
    [@ww.hidden name="planKey" /]
    [@ww.hidden name="name" /]
    [@ww.hidden name="description" /]

    [#if artifactValidationErrors.keySet()?has_content]
        <p>
        [@ui.messageBox type="warning"]
            [@ww.text name='deployment.project.edit.plan.artifact.different'/]
        [/@ui.messageBox]

        <table id="artifactValidationErrors" class="aui">
            <thead>
                <tr>
                    <th>[@ww.text name='deployment.project.edit.plan.artifact.name'/]</th>
                    <th>[@ww.text name='deployment.project.edit.plan.used.in.environment'/]</th>
                    <th>[@ww.text name='deployment.project.edit.plan.changes'/]</th>
                </tr>
            </thead>
            <tbody>
                [#list artifactValidationErrors.keySet() as name]
                <tr>
                    <td>${name}</td>
                    <td>
                        [#--<ul>--]
                            [#list artifactValidationErrors.get(name).environments as environment]
                                <p>${environment.name}</p>
                            [/#list]
                        [#--</ul>--]
                    </td>
                    <td>
                        [#--<ul>--]
                            [#list artifactValidationErrors.get(name).errorMessages as errorMessage]
                                <p>${errorMessage}</p>
                            [/#list]
                        [#--</ul>--]
                    </td>
                </tr>
                [/#list]
            </tbody>
        </table>
    [/#if]

    [#if triggerValidationErrors?has_content]
        <p>
        [@ui.messageBox type='warning']
            [@ww.text name='deployment.project.edit.plan.branch.different'/]
        [/@ui.messageBox]
        <table id="triggerValidationErrors" class="aui">
            <thead>
                <tr>
                    <th>[@ww.text name='deployment.project.edit.plan.environment'/]</th>
                    <th>[@ww.text name='deployment.project.edit.plan.trigger'/]</th>
                    <th>[@ww.text name='deployment.project.edit.plan.changes'/]</th>
                </tr>
            </thead>
            <tbody>
                [#list triggerValidationErrors as error]
                <tr>
                    <td>${error.environment.name}</td>
                    <td>${error.buildStrategy.name}</td>
                    <td>${error.errorMessage}</td>
                </tr>
                [/#list]
            </tbody>
        </table>
    [/#if]
[/@ww.form]



</body>
</html>