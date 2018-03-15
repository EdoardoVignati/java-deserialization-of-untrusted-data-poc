[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.AvailableVariablesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.AvailableVariablesAction" --]
<html>
<head>
	<title>[@ww.text name='plan.variables.available.title'][@ww.param]${immutablePlan.name}[/@ww.param][/@ww.text]</title>
    <meta name="decorator" content="atl.popup">
</head>
<body>
    <h1>Variables for <a href="${baseUrl}/browse/${immutablePlan.key}" target="_blank">${immutablePlan.name}</a></h1>
    <p>[@ww.text name="plan.variables.available.description"/]</p>
    <h2>[@ww.text name='plan.variables.available.runtime' /]</h2>
    <p class="variableDescription">[@ww.text name='plan.variables.available.runtime.description' /]</p>
    <table class="aui">
        <colgroup>
            <col width="40%"/>
            <col/>
        </colgroup>
        <thead>
            <th>[@ww.text name="global.heading.variable.name"/]</th>
            <th>[@ww.text name="plan.variables.available.runtime.column.description"/]</th>
        </thead>
        <tbody>
            <tr>
                <td>$&#123;bamboo.buildPlanName&#125;</td>
                <td>[@ww.text name="plan.variables.description.job.name"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.buildKey&#125;</td>
                <td>[@ww.text name="plan.variables.description.job.key"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.buildNumber&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.number"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.buildResultKey&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.result.key"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.buildTimeStamp&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.date"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.buildResultsUrl&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.url"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.repository.revision.number&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.revision"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.repository.previous.revision.number&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.previous.revision"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.build.working.directory&#125;</td>
                <td>[@ww.text name="plan.variables.description.build.directory"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.shortJobName&#125;</td>
                <td>[@ww.text name="plan.variables.description.job.shortName"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.shortJobKey&#125;</td>
                <td>[@ww.text name="plan.variables.description.job.shortKey"/]</td>
            </tr>
        </tbody>
    </table>
    [#if variables?has_content]
        <h2>[@ww.text name='build.editParameterisedManualBuild.variables.plan' /]</h2>
        [@displayVariables vars=variables prefix="plan"/]
    [/#if]
    [#if globalVariables?has_content]
        <h2>[@ww.text name='build.editParameterisedManualBuild.variables.global' /]</h2>
        [@displayVariables vars=globalVariables prefix="global"/]
    [/#if]
    <h2>[@ww.text name='plan.variables.available.jira' /]</h2>
    <p class="variableDescription">[@ww.text name='plan.variables.available.jira.description' /]</p>
    <table class="aui">
        <colgroup>
            <col width="40%"/>
            <col/>
        </colgroup>
        <thead>
            <th>[@ww.text name="global.heading.variable.name"/]</th>
            <th>[@ww.text name="plan.variables.available.runtime.column.description"/]</th>
        </thead>
        <tbody>
            <tr>
                <td>$&#123;bamboo.jira.baseUrl&#125;</td>
                <td>[@ww.text name="plan.variables.description.jira.url"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.jira.projectKey&#125;</td>
                <td>[@ww.text name="plan.variables.description.jira.key"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.jira.projectName&#125;</td>
                <td>[@ww.text name="plan.variables.description.jira.name"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.jira.version&#125;</td>
                <td>[@ww.text name="plan.variables.description.jira.version"/]</td>
            </tr>
            <tr>
                <td>$&#123;bamboo.jira.userName&#125;</td>
                <td>[@ww.text name="plan.variables.description.jira.username"/]</td>
            </tr>
        </tbody>
    </table>
</body>
</html>

[#macro displayVariables vars prefix=""]
    <p class="variableDescription">[@ww.text name='plan.variables.available.${prefix}.description'/]</p>
    <table id="${prefix}buildParameters" class="aui">
        <colgroup>
            <col width="40%">
            <col>
        </colgroup>
        <thead>
        <th>[@ww.text name="global.heading.variable.name"/]</th>
        <th>[@ww.text name="global.heading.value"/]</th>
        </thead>
        <tbody>
            [#list vars as entry ]
            <tr>
                [#assign key=entry.key?html /]
                [#assign value=entry.value!?html /]
                <td>$&#123;bamboo.${key}&#125</td>
                <td>[@ww.text name="variable_${key}" /]</td>
            </tr>
            [/#list]
        </tbody>
    </table>
[/#macro]