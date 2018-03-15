[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.RepositorySettingsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.RepositorySettingsAction" --]
<html>
<head>
    <title>[@ww.text name='repositorySettings.title' /]</title>
</head>

<body>
[@ui.header pageKey='repositorySettings.heading' descriptionKey='repositorySettings.description' /]

[@ww.actionerror /]
[@ui.actionwarning /]
[@ww.actionmessage /]


[@dj.tabContainer headingKeys=["manageCaches.heading", "automaticCommits.heading", "subversion.working.copies.heading"] selectedTab='${selectedTab!}']
    [@dj.contentPane labelKey="manageCaches.heading"]
        [@manageCachesTab/]
    [/@dj.contentPane]
    [@dj.contentPane labelKey="automaticCommits.heading"]
        [@automaticCommitsTab/]
    [/@dj.contentPane]
    [@dj.contentPane labelKey="subversion.working.copies.heading"]
        [@subversionWorkingCopyTab/]
    [/@dj.contentPane]
[/@dj.tabContainer]

</body>
</html>


[#macro manageCachesTab]
<p>[@ww.text name='manageCaches.description' /]</p>
    [#list cacheProviders as cacheProvider]
        [#assign provider=cacheProvider.key /]
    <h2>${cacheProvider.name}</h2>
    <p>[@ww.text name=cacheProvider.handlerDescription /]</p>
        [@ww.form action="repositorySettings!delete.action" id=provider theme="simple"]
            [@ww.hidden name='providerId' value=provider /]
        <p>
                <span>
                    [@ww.text name='global.selection.select' /]:
                    <span tabindex="0" role="link" selector="${provider}_all">[@ww.text name='global.selection.all' /]</span>,
                    <span tabindex="0" role="link" selector="${provider}_none">[@ww.text name='global.selection.none' /]</span>,
                    <span tabindex="0" role="link" selector="${provider}_unused">[@ww.text name='manageCaches.status.unused' /]</span>
                </span>
                <span class="form-actions-bar">
                    [@ww.text name='global.selection.action' /]:
                    <span class="aui-buttons">
                        [@ww.submit value=action.getText("manageCaches.delete.selected.button") theme="simple" name="deleteSelectedButton" id="deleteCacheButton" cssClass="requireConfirmation aui-button" titleKey="manageCaches.delete.selected.description"/]
                        [@ww.submit value=action.getText("manageCaches.delete.unused.button") theme="simple" name="deleteUnusedButton" id="deleteUnusedCachesButton" cssClass="requireConfirmation aui-button" titleKey="manageCaches.delete.unused.description"/]
                    </span>
                </span>
            <script type="text/javascript">
                AJS.$(function ()
                      {
                          ConfigurableSelectionActions.init("${provider}");
                      });
            </script>
        </p>
        <table id="summary" class="aui">
            <colgroup>
                <col width="5"/>
                <col/>
                <col width="95"/>
                <col width="95"/>
            </colgroup>
            <thead>
            <tr>
                <th>&nbsp;</th>
                <th>[@ww.text name='manageCaches.table.heading.location' /]</th>
                <th>[@ww.text name='manageCaches.table.heading.exists' /]</th>
                <th>[@ww.text name='manageCaches.table.heading.operations' /]</th>
            </tr>
            </thead>
            <tbody>
                [#list cacheProvider.cacheDescriptions as cacheDescription]
                <tr>
                    [#assign unused=cacheDescription.usingPlans.empty /]
                    <td>
                        <input name="selectedCaches" type="checkbox" value="${cacheDescription.key}" class="selectorScope_${provider} selector_unused_${unused?string}"/>
                    </td>
                    <td data-cache-key="${cacheDescription.key}">
                    ${cacheDescription.location}
                        <div class="subGrey">${cacheDescription.description}</div>
                        [#if unused]
                            <p><em>[@ww.text name='manageCaches.status.unused' /]</em></p>
                        [#else]
                            <ul>
                                [#list cacheDescription.usingPlans as plan]
                                    <li>
                                        [@ui.renderPlanConfigLink plan=plan /]
                                    </li>
                                [/#list]
                            </ul>
                        [/#if]
                    </td>
                    <td>[@ui.displayYesOrNo displayBool=cacheDescription.exists/]</td>
                    <td>
                        <a id="delete:${cacheDescription.location}" data-delete-cache-key="${cacheDescription.key}" class="mutative delete" href="[@ww.url action='repositorySettings!delete' namespace='/admin' providerId=provider singleCacheSelected=true selectedCaches=cacheDescription.key /]">[@ww.text name='global.buttons.delete' /]</a>
                    </td>
                </tr>
                [/#list]
            </tbody>
        </table>
        [/@ww.form]
    [/#list]
[/#macro]

[#macro automaticCommitsTab]
<p>[@ww.text name='automaticCommits.description' /]</p>
    [@ww.form action="repositorySettings!updateAutomaticCommits.action" id="automaticCommitsSettings" submitLabelKey="global.buttons.submit"]
        [@ww.textfield id='automaticCommitsName' labelKey='automaticCommits.name' name='userName' /]
        [@ww.textfield id='automaticCommitsEmail' labelKey='automaticCommits.email' name='email'/]
        [@ww.textarea id='automaticCommitsMessage' labelKey='automaticCommits.message' name='commitMessage' rows='5' cssClass="long-field" spellcheck="true"/]
    [/@ww.form]
[/#macro]

[#macro subversionWorkingCopyTab]
<p>[@ww.text name='subversion.working.copies.description' /]</p>
    [@ww.form action="repositorySettings!doUpdateSubversionPreferences.action" id="subversionWorkingCopySettings" submitLabelKey="global.buttons.update"]
        [@ww.radio labelKey='subversion.working.copy.format'
        name='subversionWorkingCopyFormat'
        listKey='name' listValue='label'
        list=validSubversionWorkingCopyFormats /]
    <p>[@ww.text name="subversion.auth.description"/]</p>
        [@ww.checkbox name="useNtlmAuth" labelKey="subversion.ntlmauth"/]
    [/@ww.form]
[/#macro]