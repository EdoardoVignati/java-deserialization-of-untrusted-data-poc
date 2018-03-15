[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.DeleteRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.DeleteRepository" --]
<meta name="decorator" content="none"/>
[@ww.form   action="deleteRepository"
            namespace="/chain/admin/config"
            submitLabelKey="global.buttons.delete"
            cancelUri="/build/admin/edit/editRepositories.action?planKey=${planKey}"]

    [#assign relevantJobs=relevantJobsUsingRepository /]
    [#if !relevantJobs.isEmpty()]

        <div class="repository-delete">
            <p>
                [@ww.text name="repository.delete.confirmation.text"]
                    [@ww.param name="taskCount" value="${action.getTasksCount(relevantJobs)}"/]
                [/@ww.text]
            </p>
            [#if availableRepositories.size() > 1]
                [@ww.select labelKey='repository.delete.replacement' name='replaceRepository' list='availableRepositories' listKey='key' listValue='name'/]
            [/#if]
            <h2>[@ww.text name="repository.delete.confirmation.title" /]</h2>
            
            <ul id="repository-delete-navigator">
                [#list relevantJobs.keySet() as job]
                    <li>
                        <h4 [#if (job.suspendedFromBuilding)!false]class="disabled"[/#if]>
                            <span>[@ui.icon "job"/]${job.buildName}</span>
                        </h4>
                        <ul>
                            [#list relevantJobs.get(job) as task]
                                <li [#if (job.suspendedFromBuilding)!false]class="disabled"[/#if]>
                                    <a href="${req.contextPath}/build/admin/edit/editBuildTasks.action?buildKey=${job.key}&taskId=${task.id}">${action.getTaskName(task)}</a>
                                </li>
                            [/#list]
                        </ul>
                    </li>
                [/#list]
            </ul>
        </div>
    [#else]
        [@ui.messageBox type="warning" titleKey="repository.delete.confirm" /]
    [/#if]

    [@ww.hidden name="createRepositoryKey"/]
    [@ww.hidden name="repositoryId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]