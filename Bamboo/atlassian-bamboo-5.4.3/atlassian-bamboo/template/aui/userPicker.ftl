[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "text user-picker ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text user-picker") }
[/#if]
[#if !(ctx.userAutocompleteAllowed!true)]
    [#assign useUserPicker = true /]
[#else]
    [#assign useUserPicker = (parameters.multiSelect!false) /]
[/#if]
[#if !useUserPicker]
    [#assign userPickerDataAttributes = {} /]
    [#assign bootstrapUser = '' /]
    [#if parameters.nameValue?has_content]
        [#assign tmpUser = (ctx.getBambooUser(parameters.nameValue))! /]
        [#if tmpUser?has_content]
            [#assign userPickerDataAttributes = userPickerDataAttributes + {
                "field-text": tmpUser.fullName!,
                "chosen": true
            } /]
            [#assign tmpAvatar = (ctx.getGravatarUrl(tmpUser.username, "16"))! /]
            [#if tmpAvatar?has_content]
                [#assign userPickerDataAttributes = userPickerDataAttributes + {
                    "icon": tmpAvatar
                } /]
            [/#if]
            [#assign bootstrapUser][#t/]
                {[#t/]
                    'avatarUrl': '${(tmpAvatar!)?js_string}',[#t/]
                    'fullName': '${(tmpUser.fullName!)?js_string}',[#t/]
                    'id': '${tmpUser.name?js_string}',[#t/]
                    'username': '${tmpUser.name?js_string}'[#if (action.viewContactDetailsEnabled)!false],[#t/]
                    'displayableEmail': '${tmpUser.email?js_string}'[/#if][#t/]
                }[#t/]
            [/#assign][#t/]
        [/#if]
    [/#if]
    ${tag.addParameter("dataAttributes", userPickerDataAttributes) }
[/#if]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
[#if useUserPicker]
    <a class="user-picker" href="${req.contextPath}/admin/user/userPickerSearch.action?fieldId=${parameters.id}&amp;multiSelect=${(parameters.multiSelect!false)?string}" onclick="var picker = window.open(this.href, 'EntitiesPicker', 'status=yes,resizable=yes,top=100,left=200,width=900,height=680,scrollbars=yes'); picker.focus(); return false;"><span class="aui-icon icon-users">User Picker</span></a>
[#else]
    <script>
        (function($) {
            new BAMBOO.UserSingleSelect({
                el: $('#${parameters.id}')[#if bootstrapUser?has_content],
                bootstrap: [${bootstrapUser}]
                [/#if]
            });
        }(jQuery));
    </script>
[/#if]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
