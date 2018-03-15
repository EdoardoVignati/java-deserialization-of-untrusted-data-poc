[#--NB: Do not use references to BambooActionSupport.class in this file, you must use ctx (FreemarkerContext) instead--]
<header id="header" role="banner">
[#include "/fragments/decorator/systemstatebanner.ftl"]
[#if ctx.featureManager.rotpEnabled]
    [#assign headerBeforeContent = soy.render("com.atlassian.plugins.atlassian-nav-links-plugin:rotp-menu", "navlinks.templates.appswitcher.switcher", {}) /]
    [#assign headerExtraClasses = '' /]
    [@ww.text id='bambooName' name='bamboo.name' /]
    ${soy.render("aui.page.header", {
        "headerLogoText": bambooName,
        "headerLink": (req.contextPath + "/"),
        "logo": "bamboo",
        "primaryNavContent": primaryHeaderItems(activeNavKey!),
        "secondaryNavContent": secondaryHeaderItems(activeNavKey!),
        "headerBeforeContent": headerBeforeContent,
        "extraClasses": headerExtraClasses
    })}
    [#include "../../fragments/showAdminErrors.ftl"]
[#else]
    [#if ctx.pluggableTopNavigation??]
        ${ctx.pluggableTopNavigation.getHtml(req)}
    [#else]
        [#include "/fragments/decorator/bambooBanner.ftl"]
        [#assign topCrumb = page.getProperty("meta.topCrumb")!('') /]
        <nav class="local" role="navigation">
            <div class="primary">
                <ul id="main-nav">
                    <li[#if topCrumb == 'home'] class="selected"[/#if]><a id="home" href="${req.contextPath}/start.action" accesskey="H">[@ww.text name='menu.home' /]</a></li>
                    [#if ctx?? && ctx.hasBuilds()]
                        <li[#if topCrumb == 'authors'] class="selected"[/#if]><a id="authors" href="${req.contextPath}/authors/gotoAuthorReport.action" accesskey="U">[@ww.text name='menu.authors' /]</a></li>
                        <li[#if topCrumb == 'reports'] class="selected"[/#if]><a id="reports" href="${req.contextPath}/reports/viewReport.action" accesskey="R">[@ww.text name='menu.reports' /]</a></li>
                    [/#if]
                    [#if fn.hasAdminPermission()]
                        <li[#if topCrumb == 'admin'] class="selected"[/#if]><a id="admin" accesskey="A" href="${req.contextPath}/admin/administer.action">[@ww.text name='menu.administration' /]</a></li>
                    [/#if]
                </ul>
            </div>
            [#if fn.hasGlobalPermission('CREATE') && !ctx.ec2ConfigurationWarningRequired]
                <div class="secondary">
                    <ul>
                        <li[#if topCrumb == 'create'] class="selected"[/#if]>
                            <a id="createNewPlan" accesskey="C" href="${req.contextPath}/build/admin/create/addPlan.action">[#rt]
                                [@ui.icon type="plan-create" showTitle=false /][#t]
                                [@ww.text name='menu.create' /][#t]
                            </a>[#lt]
                        </li>
                    </ul>
                </div>
            [/#if]
        </nav> <!-- END nav.local -->
    [/#if]
[/#if]

[@defineConvertMutativeLinksFunction/]
</header><!-- END #header -->

[#function headerItems headerSection activeKey=""]
    [#local output]
        [#list ctx.getWebItemsForSectionNoAction(headerSection, req) as webItem]
            [#local dropdownWebSections = ctx.getWebSectionsForLocationNoAction(webItem.section + '/' + webItem.key, req) /]
            [#local triggerText = (webItem.webLabel.displayableLabel)!"" /]
            [#local triggerContents = '' /]
            [#local triggerClass = '' /]
            [#local styleClass = (webItem.styleClass)! /]
            [#if styleClass?starts_with('aui-icon')]
                [#local triggerContents]<span class="aui-icon aui-icon-small ${styleClass}">${triggerText?html}</span>[/#local]
                [#local triggerText = '' /]
            [#else]
                [#local triggerClass = styleClass /]
            [/#if]
            <li[#if activeKey == webItem.key] class="selected"[/#if]>[#t]
                [#if dropdownWebSections?size gt 0]
                    ${soy.render("aui.dropdown2.dropdown2", {
                        "trigger": {
                            "id": (webItem.link.getRenderedId(ctx.getWebFragmentsContextMapNoAction(req)))!"",
                            "content": triggerContents!'',
                            "text": triggerText!'',
                            "extraClasses": triggerClass!'',
                            "title" : webItem.webLabel.getDisplayableLabel(req, ctx.getWebFragmentsContextMapNoAction(req)),
                            "showIcon": false
                        },
                        "menu": {
                            "id": webItem.pluginKey + '-' + webItem.key,
                            "content": renderDropdownSections(dropdownWebSections),
                            "extraClasses": "aui-style-default"
                        }
                    })}[#t]
                [#else]
                    ${renderWebItem(webItem)}[#t]
                [/#if]
            </li>[#t]
        [/#list]
    [/#local]
    [#return output /]
[/#function]

[#function primaryHeaderItems activeKey=""]
    [#local output]
        [#if fn.hasGlobalPermission('CREATE') && !ctx.ec2ConfigurationWarningRequired]
            [#local dropdownWebSections = ctx.getWebSectionsForLocationNoAction('header.global.primary/create.menu', req) /]
            [#if dropdownWebSections?size gt 0]
                <li[#if activeKey == 'create'] class="selected"[/#if]>[#t]
                    ${soy.render("aui.dropdown2.dropdown2", {
                        "trigger": {
                            "id": "createPlanLink",
                            "text": action.getText('menu.create'),
                            "tagName": "button",
                            "extraClasses": "aui-button aui-button-primary aui-style",
                            "extraAttributes": {
                                "accesskey": "c"
                            }
                        },
                        "menu": {
                            "id": ('bamboo.global.header' + '-' + 'create.menu'),
                            "content": renderDropdownSections(dropdownWebSections),
                            "extraClasses": "aui-style-default"
                        }
                    })}[#t]
                </li>[#t]
            [/#if]
        [/#if]
    [/#local]
    [#return renderHeaderItemContainer(headerItems("header.global.primary", activeKey) + output) /]
[/#function]

[#function secondaryHeaderItems activeKey=""]
    [#local output]
        [#if ctx.getUser(req)??]
            [#local user = ctx.getUser(req) /]
            [#local dropdownWebSections = ctx.getWebSectionsForLocationNoAction('header.global.secondary/user.menu', req) /]
            [#local triggerContents]
                <div class="aui-avatar aui-avatar-small">
                    <div class="aui-avatar-inner">
                        [@ui.displayUserGravatar userName=user.name size='24' alt=user.fullName /]
                    </div>
                </div>
            [/#local]
            [#if dropdownWebSections?size gt 0]
                <li[#if activeKey == 'user.menu'] class="selected"[/#if] id="userInfo" data-username="${user.name}">[#t]
                    ${soy.render("aui.dropdown2.dropdown2", {
                        "trigger": {
                            "content": triggerContents,
                            "title" : "${user.fullName}"
                        },
                        "menu": {
                            "id": ('bamboo.global.header' + '-' + 'user.menu'),
                            "content": renderDropdownSections(dropdownWebSections),
                            "extraClasses": "aui-style-default"
                        }
                    })}[#t]
                </li>[#t]
            [/#if]
        [/#if]
    [/#local]
    [#return renderHeaderItemContainer(headerItems("header.global.secondary", activeKey) + output) /]
[/#function]

[#function renderWebItem webItem]
    [#local id = webItem.link.getRenderedId(ctx.getWebFragmentsContextMapNoAction(req))! /]
    [#local accesskey = webItem.link.getAccessKey(ctx.getWebFragmentsContextMapNoAction(req))! /]
    [#local relAttrValue = webItem.params.get("rel")! /]
    [#local output][#rt]
        <a href="${webItem.link.getDisplayableUrl(req, ctx.getWebFragmentsContextMapNoAction(req))}"[#if id?has_content] id="${id}"[/#if][#if accesskey?has_content] accesskey="${accesskey}"[/#if] [#if relAttrValue?has_content] rel="${relAttrValue}"[/#if]>${webItem.webLabel.displayableLabel}</a>[#t]
    [/#local][#lt]
    [#return output /]
[/#function]

[#function renderDropdownSections sections]
    [#local output]
        [#list sections as section]
            [#local dropdownLabel = (section.webLabel.displayableLabel)! /]
            [#local dropdownWebItems = ctx.getWebItemsForSectionNoAction(section.location + '/' + section.key, req) /]
            [#if dropdownWebItems?size gt 0]
                <div class="aui-dropdown2-section">[#t]
                    [#if dropdownLabel?has_content]<strong>${dropdownLabel}</strong>[/#if][#t]
                    <ul class="aui-list-truncate">[#t]
                        [#list dropdownWebItems as item]
                            <li>${renderWebItem(item)}</li>[#t]
                        [/#list]
                    </ul>[#t]
                </div>[#t]
            [/#if]
        [/#list]
    [/#local]
    [#return output /]
[/#function]

[#function renderHeaderItemContainer input]
    [#return '<ul class="aui-nav">' + input + '</ul>' /]
[/#function]

[#macro defineConvertMutativeLinksFunction]
    [#if !ctx.functionalTest]
        [#return]
    [/#if]
<script>
    [#-- this has to be a HTMLUnit compatible code:  --]
    function convertMutativeLinks() {
        function postInsteadOfGet() {
            var
[#--        event will either be an argument to this method or stored in window.event, depending on the browser: --]
                    event = arguments[0] || window.event,
                    form = document.createElement('form') ;
            form.method='post';
            form.action=this.href;

            var xsrfToken=document.createElement('input');
            xsrfToken.name='atl_token';
            xsrfToken.value='${ctx.xsrfToken!?js_string!}';

            form.appendChild(xsrfToken);

            document.body.appendChild(form);

            event.preventDefault && event.preventDefault();
            form.submit();
            return false;
        }

        function hasClassPredicate(classNameToSeek) {
            var regexp = new RegExp("\\b"+classNameToSeek+"\\b");
            return function(element) {
                var classNamesOfElement = element.getAttribute("class");
                return regexp.test(classNamesOfElement);
            }
        }

        var allLinks = document.getElementsByTagName('a'),
                isMutative = hasClassPredicate("mutative"),
                isMutativeFuncTest = hasClassPredicate("usePostMethod");

        Array.filter(allLinks, isMutative).forEach(function(link) {
            link.onclick = postInsteadOfGet;
        });
        Array.filter(allLinks, isMutativeFuncTest).forEach(function(link) {
            link.onclick = postInsteadOfGet;
        });
    }

    //we have to let people use normal browser with functional tests, this should detect our HTMLUnit
    if (navigator && navigator.userAgent && (navigator.userAgent.indexOf("Windows 98")!=-1)) {
        //sadly, there are no DOMready events in HTML unit
        if (window.addEventListener) {
            window.addEventListener('load', convertMutativeLinks, false);
        } else if (window.attachEvent) {
            window.attachEvent('onload', convertMutativeLinks ); //IE, HTMLUnit
        }
    }
</script>
[/#macro]
