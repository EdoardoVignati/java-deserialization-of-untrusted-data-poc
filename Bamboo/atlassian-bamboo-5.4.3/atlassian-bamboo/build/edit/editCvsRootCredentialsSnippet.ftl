[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[@ww.textfield labelKey='repository.cvs.root' name='repository.cvs.cvsRoot' required='true' /]

[@ww.select
    labelKey='repository.cvs.authentication'
    name='repository.cvs.authType'
    toggle='true'
    list=bulkAction.repository.authenticationTypes
    listKey='name'
    listValue='label']
[/@ww.select]

[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='password']
    [@ww.hidden name="temporary.cvs.passwordChange" value="true" /]
    [@ww.password labelKey='repository.cvs.password' name='temporary.cvs.password' /]
[/@ui.bambooSection]
[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='ssh']
    [@ww.textfield labelKey='repository.cvs.keyFile' name='repository.cvs.keyFile' /]
    [@ww.hidden name="temporary.cvs.passphraseChange" value="true" /]
    [@ww.password labelKey='repository.cvs.passphrase' name='temporary.cvs.passphrase' /]
 [/@ui.bambooSection]