[@ww.textfield labelKey='repository.cvs.root' name='repository.cvs.cvsRoot' required='true' cssClass="long-field" /]

[@ww.select
    labelKey='repository.cvs.authentication'
    name='repository.cvs.authType'
    toggle='true'
    list=repository.authenticationTypes
    listKey='name'
    listValue='label']
[/@ww.select]

[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='password']
    [@ww.hidden name="temporary.cvs.passwordChange" value="true" /]
    [@ww.password labelKey='repository.cvs.password' name='temporary.cvs.password' /]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='ssh']
    [@ww.textfield labelKey='repository.cvs.keyFile' name='repository.cvs.keyFile' cssClass="long-field" /]
    [@ww.hidden name="temporary.cvs.passphraseChange" value="true" /]
    [@ww.password labelKey='repository.cvs.passphrase' name='temporary.cvs.passphrase'  /]
[/@ui.bambooSection]

[@ww.textfield labelKey='repository.cvs.module' name='repository.cvs.module' required='true' /]

[@ww.select labelKey='repository.cvs.module.versionType' name='repository.cvs.selectedVersionType'
            listKey='name' listValue='label' toggle='true'
            list=repository.versionTypes required='true' helpKey='cvs.module.version'  /]

[@ui.bambooSection dependsOn='repository.cvs.selectedVersionType' showOn='branch']
    [@ww.textfield labelKey='repository.cvs.module.branch' name='repository.cvs.branchName' /]
[/@ui.bambooSection]

[@ww.hidden name="repository.cvs.quietPeriod" value="0" /]
