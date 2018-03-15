[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AddPermissionAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AddPermissionAction" --]

[@ww.form action="createPermissionPrincipal" namespace="/ajax"
cssClass="bambooAuiDialogForm"
submitLabelKey='global.buttons.add'
cancelUri="${returnUrl}"]

    [@ww.hidden name='principalType' toggle='true' /]

    [@ui.bambooSection dependsOn='principalType' showOn='User']
        [@ww.textfield labelKey='build.permission.form.add.title' name='newUser' template='userPicker' multiSelect=false /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='principalType' showOn='Group']
        [@ww.textfield labelKey='build.permission.form.add.title' name='newGroup' /]
    [/@ui.bambooSection]

    [@ww.hidden name='entityId' /]
    [@ww.hidden name='returnUrl' /]
[/@ww.form]
