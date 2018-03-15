[#if fn.hasAdminPermission()]
    [#assign adminCrumb = page.getProperty("meta.adminCrumb")!'' /]
    [#assign location = 'system.admin' /]
    [#assign webSections = ctx.getWebSectionsForLocationNoAction(location, req) /]
    <nav id="admin-menu" class="aui-navgroup aui-navgroup-vertical">
        <div class="aui-navgroup-inner">
            [#list webSections as section]
                [@navSection section /]
            [/#list]
        </div>
    </nav>
[/#if]

[#macro navSection section]
    [@navHeading section.webLabel.displayableLabel /]
    [@navList ctx.getWebItemsForSectionNoAction(location + '/' + section.key, req) /]
[/#macro]
[#macro navHeading text]
    <div class="aui-nav-heading"><strong>${text}</strong></div>
[/#macro]
[#macro navList items]
    <ul class="aui-nav">
        [#list items as item]
            [#if item.link.id?has_content]
                [#local linkId = item.link.id /]
            [#elseif item.key?has_content]
                [#local linkId = item.key /]
            [/#if]
            <li[#if (item.link.id?has_content && adminCrumb == item.link.id) || item.link.getDisplayableUrl(req)?ends_with(ctx.getCurrentUrl(req))] class="aui-nav-selected"[/#if]>[#rt]
                <a id="${linkId!}" href="${item.link.getDisplayableUrl(req)}">${item.webLabel.displayableLabel!item.webLabelcompleteKey}</a>[#t]
            </li>[#lt]
        [/#list]
    </ul>
[/#macro]