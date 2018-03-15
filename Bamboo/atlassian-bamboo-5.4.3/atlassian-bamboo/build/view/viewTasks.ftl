[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]

[@ww.text id="i18n_globalButtonsCollapse" name="global.buttons.collapse"/]
[@ww.text id="i18n_globalButtonsExpand" name="global.buttons.expand"/]

[#macro viewTaskItem taskDefinition isCollapsed=true]
    <li class="task [#if isCollapsed]collapsed[#else ]expanded[/#if]">
        <div class="summary">
            [#if isCollapsed]
                <a tabindex="0" class="toggle">[@ui.icon type="expand" text=i18n_globalButtonsExpand/]</a>
            [#else]
                <a tabindex="0" class="toggle">[@ui.icon type="collapse" text=i18n_globalButtonsCollapse/]</a>
            [/#if]
            <h3 class="task-title">${taskDefinition.name?html}</h3>
            <div class="task-description">${taskDefinition.userDescription?html}</div>
        </div>
        <div class="details">
        ${action.getTaskDefinitionViewHtml(taskDefinition)}
        </div>
    </li>
[/#macro]

[#assign viewTaskListToolbar]
<li><a id="collapseAllTaskDetails">[@ww.text name="global.buttons.collapse.all"/]</a></li>
<li><a id="expandAllTaskDetails">[@ww.text name="global.buttons.expand.all"/]</a></li>
[/#assign]

[@ui.bambooInfoDisplay id="viewTaskList" titleKey="tasks.title" headerWeight="h2" tools=viewTaskListToolbar toolsContainer="ul"]
    [#if taskDefinitions?has_content || finalisingTaskDefinitions?has_content]
        [#assign isInitiallyCollapsed=(taskDefinitions?size + finalisingTaskDefinitions?size > 1) /]
        <ul id="bamboo-task-list">
        [#list taskDefinitions as taskDefinition]
            [@viewTaskItem taskDefinition=taskDefinition isCollapsed=isInitiallyCollapsed /]
        [/#list]
        [#if finalisingTaskDefinitions?has_content]
            <li class="final-tasks-bar">
                <strong>[@ww.text name="tasks.final.title" /]</strong>
                <span>[@ww.text name="tasks.final.description"/]</span>
            </li>
            [#list finalisingTaskDefinitions as taskDefinition]
                [@viewTaskItem taskDefinition=taskDefinition isCollapsed=isInitiallyCollapsed /]
            [/#list]
        [/#if]
        </ul>
        <script type="text/javascript">
            BAMBOO.ViewInfoList.init({
                elementSelector: ".task",
                target: "#viewTaskList",
                collapseAll: "#collapseAllTaskDetails",
                expandAll: "#expandAllTaskDetails",
                i18n: {
                    collapse: "${i18n_globalButtonsCollapse?js_string}",
                    expand: "${i18n_globalButtonsExpand?js_string}"
                }
            });
        </script>
    [#else]
        <p>[@ww.text name="tasks.view.noTasksDefinedForJob" /]</p>
    [/#if]
[/@ui.bambooInfoDisplay]

