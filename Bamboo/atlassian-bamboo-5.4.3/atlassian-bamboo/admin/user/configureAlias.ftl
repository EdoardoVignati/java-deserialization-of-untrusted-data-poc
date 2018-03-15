[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureAlias" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureAlias" --]
[@ww.form action="addAlias" namespace='/ajax'
        descriptionKey='user.repositoryAlias.add.description'
        submitLabelKey="global.buttons.add"]
    [@ww.hidden name="returnUrl" /]

    [@ww.textfield labelKey='user.repositoryAlias.add.label' name="newAuthorName" /]

[/@ww.form]
