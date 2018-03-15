[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.UserPickerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.UserPickerAction" --]
<meta name="decorator" content="atl.popup">

<h1>[#if multiSelect]
        [@ww.text name="user.picker.title" /]
    [#else]
        [@ww.text name="user.picker.title.single" /]
    [/#if]
</h1>

[#include "userPickerForm.ftl" /]

[#if paginationSupport.page?has_content]
<form action="#" name="selectorform">
<table id="existingUsers" class="aui">
    <thead>
        <tr>
            [#if multiSelect]
            <th>Check All
                <input type="checkbox" name="all" onclick="setCheckboxes()" value="0">
            </th>
            [/#if]
            <th>[@ww.text name="user.username"/]</th>
            [#if viewContactDetails]
                <th>[@ww.text name="user.email"/]</th>
            [/#if]
            <th>[@ww.text name="user.fullName"/]</th>
        </tr>
    </thead>
    [#foreach userInfo in paginationSupport.page ]
    <tr class="clickable">
        [#if multiSelect]
        <td  name="${userInfo.name?html}">
            <input type="checkbox" value="${userInfo.name?html}" id="${userInfo.name?html}" name="userSelect" />
        </td>
        [/#if]
        <td name="${userInfo.name?html}">
            ${userInfo.name?html}
        </td>
        [#if viewContactDetails]
            <td name="${userInfo.name?html}">
            ${userInfo.email!?html}
            </td>
        [/#if]
        <td name="${userInfo.name?html}">
            [@ui.displayUserFullName user=userInfo /]
        </td>
    </tr>
    [/#foreach]
</table>
</form>

[@cp.entityPagination actionUrl='?usernameTerm=${usernameTerm!}&fullnameTerm=${fullnameTerm!}&emailTerm=${emailTerm!}&fieldId=${fieldId}&' paginationSupport=paginationSupport /]
<div class="user-picker-ops">
    [#if multiSelect]
    <input type="button" value="Select User(s)"
                       onclick="opener.addUsers(getEntityNames(), '${fieldId?js_string}', ${multiSelect?string}); window.close()"/>
    [/#if]
	<a onclick="window.close()">[@ww.text name="global.buttons.cancel"/]</a>
</div>


[#else]
   [@ww.text name='user.picker.search.empty' /]
    <div class="user-picker-ops">
		<a onclick="window.close()">[@ww.text name="global.buttons.cancel"/]</a>
    </div>
[/#if]

<script type="text/javascript">
    function saveSingleUserAndClose(e)
    {
        var dom = e.target;
        var username = dom.getAttribute("name");
        opener.addUsers(username, '${fieldId?js_string}', ${multiSelect?string});
        window.close();
    }

    [#if !multiSelect]
        AJS.$("#existingUsers .clickable").click(saveSingleUserAndClose);
    [#else]
        AJS.$("#existingUsers .clickable").click(toggleContainingCheckbox);
    [/#if]

</script>


