[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.UserPickerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.UserPickerAction" --]
<meta name="decorator" content="atl.popup">
<h1> [@ww.text name="user.picker.title" /]</h1><br>

[#include "userPickerForm.ftl" /]

<div align="right">
<input type="button" value="Cancel" onclick="window.close()" />
</div>