[@ww.textfield labelKey='repository.svn.repository' name='repository.svn.repositoryUrl' cssClass="long-field" required='true' /]
[@ww.textfield labelKey='repository.svn.username' name='repository.svn.username' /]

[@ww.select
    labelKey='repository.svn.authentication'
    name='repository.svn.authType'
    toggle='true'
    list=repository.authenticationTypes
    listKey='name'
    listValue='label']
[/@ww.select]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='password']
    [#if buildConfiguration.getString('repository.svn.userPassword')?has_content]
        [@ww.checkbox labelKey='repository.password.change' toggle='true' name='temporary.svn.passwordChange' /]
        [@ui.bambooSection dependsOn='temporary.svn.passwordChange' showOn='true']
            [@ww.password labelKey='repository.svn.password' name="temporary.svn.password" required="false" /]
        [/@ui.bambooSection]
    [#else]
        [@ww.hidden name="temporary.svn.passwordChange" value="true" /]
        [@ww.password labelKey='repository.svn.password' name='temporary.svn.password' /]
    [/#if]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='ssh']
    [@ww.textfield labelKey='repository.svn.keyFile' name='repository.svn.keyFile' cssClass="long-field" /]
    [@ww.hidden name="temporary.svn.passphraseChange" value="true" /]
    [@ww.password labelKey='repository.svn.passphrase' name='temporary.svn.passphrase' /]
[/@ui.bambooSection]

[@ui.bambooSection dependsOn='repository.svn.authType' showOn='ssl-client-certificate']
    [@ww.textfield labelKey='repository.svn.keyFile' name='repository.svn.sslKeyFile' cssClass="long-field" /]
    [@ww.hidden name="temporary.svn.sslPassphraseChange" value="true" /]
    [@ww.password labelKey='repository.svn.passphrase' name='temporary.svn.sslPassphrase' /]
[/@ui.bambooSection]