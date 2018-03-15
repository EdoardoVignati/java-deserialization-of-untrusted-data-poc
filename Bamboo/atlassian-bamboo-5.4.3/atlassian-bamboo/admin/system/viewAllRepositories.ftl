[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ViewAllRepositories" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ViewAllRepositories" --]
<html>
<head>
    <title>[@ww.text name='admin.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>

[@ui.messageBox type="warn" content="This is an experimental feature. Buyers beware." /]

[@ww.form action='copyRepositories' namespace='/admin/system'
titleKey='Merge repository'
description="This action allows you pick a repository to override the repository of multiple plans in one go"
submitLabelKey='Are you sure you want to do this? There is no validation!'
cancelUri='/admin/viewAllRepositories.action'
]

<p>${repoToPlans.size()} unique repositories found for enabled plans. Select the repository from the left column and the plans to apply them to on the right.</p>

<table class="grid">

[#list repoToPlans as repoPlan]
    <tr>
        <td>

            [#assign plans = repoPlan.value /]
            [#assign firstPlan = plans.iterator().next() /]
            [@ww.radio name='fromPlanId' template="radio.ftl" theme="simple" fieldValue='${firstPlan.id}'/]
            Repository used for ${plans.size()} plans
            [@ui.bambooInfoDisplay]
                [@ww.label labelKey='repository.title' value='${repoPlan.key.repository.name}' /]
                ${repoPlan.key.repository.getViewHtml(firstPlan)!""}
            [/@ui.bambooInfoDisplay]
        </td>
        <td>
            <ol class="standard">
                [#list plans as plan]
                    <li>
                        [@ww.checkbox name="toPlanIds" fieldValue="${plan.id}" theme="simple" /]
                        [#if plan.getType() == 'JOB']
                            Job:
                        [/#if]
                        [@ui.renderPlanConfigLink plan /]
                    </li>
                [/#list]
            </ol>
        </td>
    </tr>

[/#list] 
</table>

[/@ww.form]

</body>
</html>