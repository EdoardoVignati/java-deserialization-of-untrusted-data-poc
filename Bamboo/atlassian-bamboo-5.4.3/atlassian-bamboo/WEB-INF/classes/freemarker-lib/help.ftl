[#-- =============================================================================================== @help.url --]
[#--Example Usage: [@help.url pageKey="help.home"]Help[/@help.url] --]
[#macro url pageKey title="" cssClass=""]
    [#assign docRoot][@ww.text name="help.prefix"/][/#assign]
    [#assign path][@ww.text name="${pageKey}"/][/#assign]

<a href="${docRoot}${path}" [#t]
    [#if title?has_content]
        title="${title}" [#t]
    [#elseif action.doesHelpLinkHaveMatchingTitle(pageKey)]
        title="[@ww.text name='${pageKey}.title'/]" [#t]
    [/#if]
    [#if cssClass?has_content]
        class="${cssClass}" [#t]
    [/#if]
rel="help">[#nested]</a> [#t]
[/#macro]

[#-- =============================================================================================== @help.staticUrl --]
[#--Example Usage: [@help.url pageKey="help.home"]Help[/@help.url] --]
[#macro staticUrl pageKey title="" cssClass=""]
    [#assign path][@ww.text name="${pageKey}"/][/#assign]

<a href="${path}" [#t]
    [#if title?has_content]
            title="${title}" [#t]
    [#elseif action.doesHelpLinkHaveMatchingTitle(pageKey)]
            title="[@ww.text name='${pageKey}.title'/]" [#t]
    [/#if]
    [#if cssClass?has_content]
            class="${cssClass}" [#t]
    [/#if]
        rel="help">[#nested]</a> [#t]
[/#macro]

[#-- =============================================================================================== @help.href --]
[#--Example Usage: <a href="[@help.href pageKey="help.home"/]"> --]
[#macro href pageKey title="" cssClass=""]
[#assign docRoot][@ww.text name="help.prefix"/][/#assign]
[#assign path][@ww.text name="${pageKey}"/][/#assign]
${docRoot}${path}"[#t]
[/#macro]

[#-- =============================================================================================== @help.icon --]
[#--Example Usage: [@help.icon pageKey="help.home" title="Bamboo Documentation" altText="Bamboo Documentation"/]  --]
[#macro icon pageKey title="" altText="" cssClass=""]
   [#assign path][@ww.text name="${pageKey}"/][/#assign]

   [@url pageKey="${pageKey}" title="${title}" cssClass=cssClass]
   <span class="aui-icon aui-icon-help[#if cssClass?has_content] ${cssClass}[/#if]"
       [#if altText?has_content]
            title="${altText}" [#t]
       [#elseif action.doesHelpLinkHaveMatchingTitle(pageKey)]
            title="[@ww.text name='${pageKey}.title'/]" [#t]
       [/#if]
   ></span>[#t]
   [/@url]
[/#macro]

[#macro iconDialog id contentKey cssClass=""]
    [#assign dialogContent][@ww.text name="${contentKey}"/][/#assign]
    [#assign helpDialogId]helpDialog-${id}[/#assign]

    <a href="#" id="${helpDialogId}" class="icon-help-dialog[#if cssClass?has_content] ${cssClass}[/#if]" rel="help">
        <span class="aui-icon aui-icon-small aui-iconfont-help" data-unicode="UTF+E003" original-title="">${dialogContent}</span>
    </a>
    <script>
        (function ($) {
            new Bamboo.Widget.HelpDialog({
                el: $('#${helpDialogId}')
            })
        }(AJS.$));
    </script>
[/#macro]