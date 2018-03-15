[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.credentials.ConfigureSharedCredentials" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.ConfigureSharedCredentials" --]

<html>
<head>
    [@ui.header pageKey="sharedCredentials.title" title=true/]
</head>

<body>
[@ui.header pageKey="sharedCredentials.heading" descriptionKey="sharedCredentials.description"/]
[@ui.bambooPanel]
    [@ww.url  id='addSharedCredentials' value='/admin/credentials/addSharedCredentials.action' returnUrl=currentUrl/]

    [#if credentials?has_content]
        <div>
            <table class="aui">
                <thead>
                <tr>
                    <th>
                        [@ww.text name='sharedCredentials.title' /]
                    </th>
                    <th class="operations">
                        [@ww.text name="global.heading.actions"/]
                    </th>
                </tr>
                </thead>
                <tbody>
                    [#list credentials as item]
                        [@credentialsListItem id=item.id name=item.name!?html /]
                    [/#list]
                </tbody>
            </table>
        </div>
    [#else]
        <p>There are currently no shared credentials defined</p>
    [/#if]

    [@cp.displayLinkButton buttonId='createSharedCredentials' buttonLabel="Add shared credentials" buttonUrl=addSharedCredentials cssClass='update-credentials' /]

    [@dj.simpleDialogForm
        triggerSelector=".update-credentials"
        width=600 height=500
        submitCallback="reloadThePage"
    /]
    [@dj.simpleDialogForm
        triggerSelector=".delete"
        width=560 height=400
        headerKey="sharedCredentials.delete"
        submitCallback="reloadThePage"
    /]
[/@ui.bambooPanel]

</body>
</html>


[#macro credentialsListItem id name]
<tr id="item-${id}">
	<td class="labelPrefixCell">
        ${name}
    </td>
    <td class="operations">    
    	<a class="update-credentials" href="[@ww.url action="editSharedCredentials" namespace="/admin" /]?credentialsId=${id}">[@ww.text name="global.buttons.edit" /]</a> |
    	<a href="[@ww.url action="confirmDeleteSharedCredentials" namespace="/admin"/]?credentialsId=${id}&returnUrl=${currentUrl}" class="delete" title="[@ww.text name='credentials.delete' /]">[@ww.text name="global.buttons.delete" /]</a>
    </td>
</tr>
[/#macro]




