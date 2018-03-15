[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironment" --]

[#assign headerText]
    [@ww.text name="deployment.environment.update"]
        [@ww.param]
            [#if environment??]
                ${environment.name?html}
            [#else]
                ${id}
            [/#if]
        [/@ww.param]
    [/@ww.text]
[/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.environments.howtheywork"][@ww.text name="deployments.environments.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=headerText headerElement="h2"/]
[@ww.form action="saveEnvironment" namespace="/deploy/config" cancelUri="/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}"]
    [@ww.hidden name="id"/]

    [@ww.textfield labelKey='deployment.environment.name' name='name' required='true' /]
    [@ww.textfield labelKey='deployment.environment.description' name='description' required='false' /]

    [#if environment??]
        [#assign toolbar]<a href='[@s.url action="configureEnvironmentTriggers" namespace="/deploy/config" environmentId=environment.id/]'>[@s.text name="deployment.environment.deploy.configure.triggers"/]</a>[/#assign]
        [#if showTriggersEnabled]
            [@ui.bambooSection id="triggerList" titleKey="deployment.project.environment.overview.triggers.key" tools=toolbar]
                [#if environment.triggers?has_content]
                    <table class="aui">
                        <colgroup>
                            <col/>
                            <col width="30%"/>
                            <col width="220px"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th>[@s.text name="deployment.trigger.type"/]</th>
                                <th>[@s.text name="deployment.trigger.details"/]</th>
                                <th>[#if action.hasDeploymentProjectPlanMultipleBranches()][@s.text name="deployment.trigger.planBranch"/][/#if]</th>
                            </tr>
                        </thead>
                        <tbody>
                        [#list environment.triggers as trigger]
                            <tr>
                                <td>${trigger.getDescription()} [#if trigger.userDescription?has_content]<span class="userDescription">(${trigger.userDescription})</span>[/#if]</td>
                                <td>${trigger.getTriggerDetailsSummaryHtml(environment, action)}</td>
                                <td>[#if action.hasDeploymentProjectPlanMultipleBranches()]
                                        ${soy.render("bamboo.deployments:deployments-main", "bamboo.widget.deployment.version.branch", {
                                                     'planBranchName': action.getBranchName(trigger)!})}
                                [/#if]
                                </td>
                            </tr>
                        [/#list]
                        </tbody>
                    </table>
                [#else]
                    <p>[@s.text name="chain.triggers.noTriggersDefined"/]</p>
                [/#if]
            [/@ui.bambooSection]
        [/#if] [#--if showTriggers--]
    [/#if] [#--if environment--]

    [@ww.param name="buttons"]
        [@ww.text id="backButtonText" name="deployment.environment.update.back"/]
        [@ww.submit value=backButtonText name='save' primary=true /]
    [/@ww.param]
[/@ww.form]

</body>
</html>