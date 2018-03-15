[#macro taskSelector availableTasks selectionUrl]
    [#if availableTasks?has_content]
    <ol class="task-type-list">
        [#list availableTasks as taskType]
            [#assign taskTypeClass][#rt]
                [#list taskType.categories as category] task-type-category-${category.name()}[/#list][#t]
            [/#assign][#lt]
            <li[#if taskTypeClass?has_content] class="${taskTypeClass}"[/#if]>
                <span class="task-type-icon-holder" [#if taskType.getIconUrl()??] style="background-image: url(${taskType.getIconUrl()})" [/#if]></span>

                <h3 class="task-type-title">
                    <a href="${selectionUrl}&amp;createTaskKey=${taskType.completeKey}">${taskType.name?html}</a>
                </h3>
                [#if taskType.description??]
                    <div class="task-type-description">${taskType.description?html}</div>
                [/#if]
            </li>
        [/#list]
    </ol>
    [/#if]
[/#macro]

[#macro editTasksCommon taskSelectorUrl agentAvailabilityDescriptionUrl editTaskUrl deleteTaskUrl moveTaskUrl moveFinalBarUrl]
    [#if !featureManager.onDemandInstance]
        [@ww.text id='tasksGetMoreOnPac' name='tasks.types.getMoreOnPac']
            [@ww.param][@ww.url value="/plugins/servlet/upm/marketplace/featured?category=Bamboo%20Tasks"/][/@ww.param]
            [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.extending"/]
            [/@ww.param]
        [/@ww.text]
    [/#if]
    [#assign filterForm]
    <form id="filter-task-type"><input type="search" placeholder="[@ww.text name='global.buttons.search' /]"/>
    </form>[/#assign]
    <div id="panel-editor-setup" class="task-config[#if !existingTasks?has_content && !finalisingTasks?has_content] no-items[/#if]">
        <p id="no-items-message">[@ww.text name="tasks.config.noTasksDefined" /]</p>

        <div id="panel-editor-list">
            <h2 class="assistive">[@ww.text name="tasks.title" /]</h2>
            <ul>
                [#list existingTasks as taskDef]
                    [@taskListItem id=taskDef.id name=taskDef.name!?html  editTaskUrl=editTaskUrl deleteTaskUrl=deleteTaskUrl  description=taskDef.userDescription!?html enabled=taskDef.enabled valid=taskDef.valid!true /]
                [/#list]
                <li class="final-tasks-bar">
                    <h3>[@ww.text name="tasks.final.title" /]</h3>

                    <div>[@ww.text name="tasks.final.description" /]</div>
                </li>
                [#list finalisingTasks as taskDef]
                    [@taskListItem id=taskDef.id name=taskDef.name!?html  editTaskUrl=editTaskUrl deleteTaskUrl=deleteTaskUrl  description=taskDef.userDescription!?html enabled=taskDef.enabled final=true valid=taskDef.valid!true/]
                [/#list]
                <li id="final-tasks-prompt">[@ww.text name="tasks.final.dragtomakefinal" /]</li>
            </ul>
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="${taskSelectorUrl}" id="addTask" class="toolbar-trigger">[@ww.text name="tasks.add" /]</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="panel-editor-config"></div>
    </div>
    <script type="text/x-template" title="taskListItem-template">
        [@taskListItem id="{id}" name="{name}" editTaskUrl=editTaskUrl deleteTaskUrl=deleteTaskUrl description="{description}" enabled=true /]
    </script>
    <script type="text/x-template" title="lozengeDisabled-template">
        [@ui.lozenge colour="default-subtle" textKey="tasks.disabled"/]
    </script>
    <script type="text/x-template" title="icon-template">
        [@ui.icon type="{type}" /]
    </script>
    <script type="text/javascript">
        BAMBOO.TASKS.tasksConfig.init({
              addTaskTrigger: "#addTask",
              taskSetupContainer: "#panel-editor-setup",
              taskConfigContainer: "#panel-editor-config",
              taskList: "#panel-editor-list > ul",
                  [#if taskId?has_content]defaultTaskToSelect: ${taskId},[/#if]
              taskTypeCategories: ${availableCategoryJson},
              taskTypesDialog: {
                  filterForm: "${filterForm?js_string}"
              },
              templates: {
                  taskListItem: "taskListItem-template",
                  lozengeDisabled: "lozengeDisabled-template",
                  iconTemplate: "icon-template"[#if tasksGetMoreOnPac??],
                      getMoreOnPac: "${tasksGetMoreOnPac?js_string}"[/#if]
              },
              agentAvailabilityDescriptionContainer: "#agentAvailabilityDescription",
              agentAvailabilityDescriptionUrl: "${agentAvailabilityDescriptionUrl!""}",
              moveTaskUrl: "${moveTaskUrl}",
              moveFinalBarUrl: "${moveFinalBarUrl}"
          });
    </script>
[/#macro]

[#macro taskListItem id name editTaskUrl deleteTaskUrl description="" enabled=true final=false valid=true]
    <li class="item[#if final] final[/#if][#if !valid] invalid[/#if]" data-item-id="${id}" id="item-${id}">
        <a href="${editTaskUrl}&amp;taskId=${id}">
            <h3 class="item-title">${name}</h3>
            [#if description?has_content]
                <div class="item-description">${description}</div>
            [/#if]
        </a>
        [#if enabled?string == "false"][@ui.lozenge colour="default-subtle" textKey="tasks.disabled"/][/#if]
        <a href="${deleteTaskUrl}&amp;taskId=${id}" class="delete" title="[@ww.text name='tasks.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>
    </li>
[/#macro]

[#macro invalidTaskPlugin showDeleteButton deleteUrl]
    <div class="invalidPlugin">
        <h2>[@ww.text name="tasks.edit.error.missingPlugin.title"/]</h2>
        [#if showDeleteButton]
            <div class="aui-toolbar inline delete">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="${deleteUrl}" class="toolbar-trigger" title="[@ww.text name='tasks.delete' /]">[@ww.text name='global.buttons.delete' /]</a>
                    </li>
                </ul>
            </div>
        [/#if]
        [@ui.messageBox type="error" titleKey="tasks.edit.error.missingPlugin.message.title"]
            [#if taskDefinition?has_content]
                [@ww.text name="tasks.edit.error.missingPlugin.message"]
                    [@ww.param]<a class="delete" href="${deleteUrl}" title="[@ww.text name='tasks.delete' /]">[/@ww.param]
                    [@ww.param]</a>[/@ww.param]
                    [@ww.param]${taskDefinition.pluginKey}[/@ww.param]
                [/@ww.text]
            [#else]
                [@ww.text name="tasks.edit.error.missingPlugin.message"]
                    [@ww.param]<a class="delete" href="${deleteUrl}" title="[@ww.text name='tasks.delete' /]">[/@ww.param]
                    [@ww.param]</a>[/@ww.param]
                    [@ww.param]${createTaskKey}[/@ww.param]
                [/@ww.text]
            [/#if]
        [/@ui.messageBox]
    </div>

[/#macro]