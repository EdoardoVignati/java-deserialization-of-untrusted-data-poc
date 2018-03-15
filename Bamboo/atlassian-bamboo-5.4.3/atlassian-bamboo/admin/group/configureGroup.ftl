[#if mode == 'edit' ]
    [#assign targetAction = 'updateGroup']
    [#assign cancelUri = '/admin/group/viewGroups.action' /]
    <html><head><title>Update Group</title></head><body>
    [#assign pageHeading = 'h1' /]
[#else]
    [#assign targetAction = 'createGroup']
    [#assign cancelUri = '/admin/group/viewGroups.action' /]
    [#assign pageHeading = 'h2' /]
[/#if]

<${pageHeading}>[@ww.text name='group.admin.${mode}' /]</${pageHeading}>
[@ww.form action=targetAction
          submitLabelKey='global.buttons.update'
          titleKey=(pageHeading == 'h2')?string('', 'group.admin.${mode}.form.title')
          smallTitleKey=(pageHeading == 'h2')?string('group.admin.${mode}.form.title', '')
          cancelUri=cancelUri
          descriptionKey='group.admin.${mode}.description'
]
    [#if mode == 'edit']
        [@ww.label labelKey='group.groupName' name="groupName" /]
        [@ww.hidden name="groupName" /]
        [#if usernamesForCurrentGroup?has_content]
            [@ww.select labelKey='group.member.current' name='currentMembers'
                        list=usernamesForCurrentGroup multiple='true' /]
        [/#if]
    [#else]
        [@ww.textfield labelKey='group.groupName' name="groupName" required="true" /]
    [/#if]
    [@ww.textfield labelKey='group.member.add' name='membersInput' template='userPicker' /]

[/@ww.form]

[#if mode=='edit']
    </body></html>
[/#if]
        
