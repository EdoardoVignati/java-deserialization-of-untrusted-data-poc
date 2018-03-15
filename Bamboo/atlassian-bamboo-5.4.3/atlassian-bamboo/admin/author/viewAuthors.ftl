[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.author.ViewAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.author.ViewAuthors" --]
<html>
<head>
[@ui.header pageKey="config.authorManagement.title" title=true /]
    <meta name="decorator" content="adminpage">
</head>

<body>
<div class="toolbar">
    <div class="aui-toolbar inline">
        <ul class="toolbar-group">
        [#if fn.hasRestrictedAdminPermission()]
            <li class="toolbar-item">
                <a class="toolbar-trigger unlinkAuthors" href="${req.contextPath}/admin/ajax/confirmUnlinkAllAuthors.action" title="[@ww.text name='config.authorManagement.unlinkAll'/]">[@ww.text name="config.authorManagement.unlinkAll"/]</a>
                [@dj.simpleDialogForm
                    triggerSelector=".unlinkAuthors"
                    width=500 height=280
                    submitMode="ajax"
                    submitCallback="redirectAfterReturningFromDialog"
                /]
            </li>
            <li class="toolbar-item">
                <a class="toolbar-trigger mutative" href="${req.contextPath}/admin/author/relinkAuthors.action">[@ww.text name="config.authorManagement.autoLink"/]</a>
            </li>
        [/#if]
        </ul>
    </div>
</div>

[@ui.header pageKey="config.authorManagement.title"/]


[@ui.bambooSection]
<div class="inlineSearchForm">
    [@ww.form action='viewAuthors' namespace='/admin/author' submitLabelKey='Search' theme="simple" cssClass="aui"]
        <fieldset class="inline">
            <label for="searchOption">[@ww.text name="config.authorManagement.search.label"/]</label>
            [@ww.select list=searchOptions id="searchOption" name="searchOption"/]
            [@ww.textfield name="searchString" /]
            <input type='submit' value='[@ww.text name="global.buttons.search"/]'/>
        </fieldset>
    [/@ww.form]
    <div class="inlineSearchDescription">[@ww.text name="config.authorManagement.search.description"/]</div>
</div>
[/@ui.bambooSection]

<table class="aui">
    <thead>
    <tr>
        <th>[@ww.text name="config.authorManagement.authorName"/]</th>
        <th>[@ww.text name="user.email"/]</th>
        <th>[@ww.text name="config.authorManagement.linkedUser"/]</th>
        <th>[@ww.text name="global.heading.operations"/]</th>
    </tr>
    </thead>
[#if pager.getPage()??]
    <tfoot>
    <tr>
        <td colspan="7">[@cp.pagination /]</td>
    </tr>
    </tfoot>
    [#list pager.page.list as author]
        <tr>
            <td>
                ${author.name?html}
            </td>
            <td>
                [#if author.email?has_content]
                    ${author.email!?html}[#t]
                [/#if]
            </td>
            <td>
                [#if author.linkedUserName?has_content]
                    ${author.linkedUserName}
                [/#if]
            </td>
            <td class="operations">
                [#if !author.linkedUserName?has_content]
                    <a class="addUserLink" title="[@ww.text name='config.authorManagement.linkWithUser'/]" href="${req.contextPath}/admin/ajax/selectUserForAuthor.action?authorId=${author.id}">[@ww.text name="config.authorManagement.linkWithUser"/]</a>
                [#else]
                    <a class="mutative" href="${req.contextPath}/admin/author/unlinkUser.action?authorId=${author.id}">[@ww.text name="config.authorManagement.unlinkUser"/]</a>
                [/#if]
            </td>
        </tr>
    [/#list]
[/#if]
</table>

[@dj.simpleDialogForm
    triggerSelector=".addUserLink"
    width=500 height=280
    submitMode="ajax"
    submitCallback="redirectAfterReturningFromDialog"
/]

</body>
</html>