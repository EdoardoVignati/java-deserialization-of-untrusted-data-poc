[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]

<html>
<head>
	<title>[@ww.text name='builds.delete.confirm.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='builds.delete.confirm.heading' /]</h1>

    [@ww.form titleKey='builds.delete.confirm.form.title' id='deleteBuildsForm' action='deleteBuilds' submitLabelKey='global.buttons.confirm' cancelUri='/admin/deleteBuilds!default.action' cssClass="top-label"]
           [@ui.messageBox type="warning" titleKey='builds.delete.warning' /]

        [#if selectedProjects??]
            <p>[@ww.text name='builds.delete.confirm.projects' /]</p>
            <ol>
                [#list projectsToConfirm as project]
                    [#if project??]
                        <li>${project.name} <em>(${project.key})</em></li>
                    [/#if]
                [/#list]
            </ol>
        [/#if]
        [#if selectedBuilds??]
            <p>[@ww.text name='builds.delete.confirm.plans' /]</p>
            <ol>
                [#list buildsToConfirm as build]
                    [#if build??]
                        <li>${build.name} <em>(${build.key})</em>
                               [#assign jobs = action.getJobsToConfirm(build) /]
                                [#if jobs?has_content ]
                                    <ol>
                                    [#list jobs.toArray()?sort_by("name") as job]
                                        [#if job??]
                                            <li>${job.buildName} <em>(${job.key})</em></li>
                                        [/#if]
                                    [/#list]
                                    </ol>
                                [/#if]
                        </li>
                    [/#if]
                [/#list]
            </ol>
        [/#if]
        [#if selectedBuilds??]
            [#list selectedBuilds as selectedBuild]
                [@ww.hidden name='selectedBuilds' value=selectedBuild /]
            [/#list]
        [/#if]
        [#if selectedProjects??]
            [#list selectedProjects as selectedProject]
                [@ww.hidden name='selectedProjects' value=selectedProject /]
            [/#list]
        [/#if]
    [/@ww.form]
</body>
</html>
