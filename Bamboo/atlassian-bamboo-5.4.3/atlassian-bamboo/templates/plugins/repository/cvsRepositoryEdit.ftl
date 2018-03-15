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
     [#if buildConfiguration.getString('repository.cvs.password')?has_content]
        [@ww.checkbox labelKey='repository.password.change' toggle='true' name='temporary.cvs.passwordChange' /]
        [@ui.bambooSection dependsOn='temporary.cvs.passwordChange' showOn='true']
            [@ww.password labelKey='repository.cvs.password' name="temporary.cvs.password" required="false" /]
        [/@ui.bambooSection]
    [#else]
        [@ww.hidden name="temporary.cvs.passwordChange" value="true" /]
        [@ww.password labelKey='repository.cvs.password' name='temporary.cvs.password' /]
    [/#if]
[/@ui.bambooSection]
[@ui.bambooSection dependsOn='repository.cvs.authType' showOn='ssh']
    [@ww.textfield labelKey='repository.cvs.keyFile' name='repository.cvs.keyFile' cssClass="long-field" /]
    [#if buildConfiguration.getString('repository.cvs.passphrase')?has_content]
        [@ww.checkbox labelKey='repository.passphrase.change' toggle='true' name='temporary.cvs.passphraseChange' /]
        [@ui.bambooSection dependsOn='temporary.cvs.passphraseChange' showOn='true']
             [@ww.password labelKey='repository.cvs.passphrase' name='temporary.cvs.passphrase' cssClass="long-field" /]
        [/@ui.bambooSection]
    [#else]
        [@ww.hidden name="temporary.cvs.passphraseChange" value="true" /]
        [@ww.password labelKey='repository.cvs.passphrase' name='temporary.cvs.passphrase'  /]
    [/#if]
 [/@ui.bambooSection]

[@ww.textfield labelKey='repository.cvs.quiet' name='repository.cvs.quietPeriod' required='true' helpKey='cvs.quiet.period'/]
[@ww.textfield labelKey='repository.cvs.module' name='repository.cvs.module' required='true' /]

[@ww.select labelKey='repository.cvs.module.versionType' name='repository.cvs.selectedVersionType'
            listKey='name' listValue='label' toggle='true'
            list=repository.versionTypes required='true' helpKey='cvs.module.version' /]

[@ui.bambooSection dependsOn='repository.cvs.selectedVersionType' showOn='branch']
    [@ww.textfield labelKey='repository.cvs.module.branch' name='repository.cvs.branchName' /]
[/@ui.bambooSection]

