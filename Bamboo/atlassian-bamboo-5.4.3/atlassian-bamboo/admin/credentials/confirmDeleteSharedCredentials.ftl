<title>[@ww.text name="sharedCredentials.delete" /]</title>
[@ww.form action="deleteSharedCredentials" namespace="/admin"
submitLabelKey="global.buttons.delete"
id="confirmDelete"]
    [@s.hidden name="returnUrl" /]
    [@s.hidden name="credentialsId" /]
    [@ui.messageBox type="warning" titleKey="sharedCredentials.delete.confirm.title" ]
        [@s.text name="sharedCredentials.delete.confirm.description" /]
    [/@ui.messageBox]
    <br/>
    [#assign repoList]
        [@printRepos repositoryType="sharedCredentials.delete.global" repositoryMap=globalRepositoryDefinitionsMap
            action="configureGlobalRepositories" namespace="/admin" /]
        [@printRepos repositoryType="sharedCredentials.delete.plan" repositoryMap=planRepositoryDefinitionsMap
            action="editChainRepository" namespace="/chain/admin/config" useBuildKey=true /]
        [@printRepos repositoryType="sharedCredentials.delete.branch" repositoryMap=planBranchRepositoryDefinitionsMap
            action="editChainBranchRepository" namespace="/branch/admin/config" usePlanKey=true /]
    [/#assign]

    [#if repoList != ""]
        <ul>
            ${repoList}
        </ul>
    [#else]
        [@s.text name="sharedCredentials.delete.none" /]
    [/#if]

[/@ww.form]

[#macro printRepos repositoryType repositoryMap action namespace useBuildKey=false usePlanKey=false]
    [#if !repositoryMap.isEmpty()]
        [#list repositoryMap?keys as r]
            <li>
                [#if useBuildKey]
                    [@s.url id='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id buildKey=repositoryMap.get(r)!"" /]
                [#elseif usePlanKey]
                    [@s.url id='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id planKey=repositoryMap.get(r)!"" /]
                [#else]
                    [@s.url id='editRepositoryUrl' action=action namespace=namespace repositoryId=r.id /]
                [/#if]
                <a href="${editRepositoryUrl}">${r.name}</a> [@s.text name=repositoryType /]
            </li>
        [/#list]
    [/#if]
[/#macro]