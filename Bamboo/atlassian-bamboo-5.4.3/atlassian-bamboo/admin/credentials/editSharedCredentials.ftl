[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@ww.form  action='updateSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>[@ww.text name="sharedCredentials.edit" /] - ${credentialsName?html} </h2>

    <div class="aui-message warning">
         [@ww.text name="sharedCredentials.edit.warning" /]
         <span class="aui-icon icon-warning"></span>
    </div>

    [@ww.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@ww.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    [@ww.checkbox labelKey='credentials.ssh.change' toggle='true' name='updateSshKey' /]

    [@ui.bambooSection id='credentials-configuration' dependsOn='updateSshKey' showOn=true]
        [@ww.textarea labelKey='credentials.ssh.key' name='sshKeyFile' required=true/]
        [@ww.password labelKey='credentials.ssh.passphrase' name='sshPassphrase' /]
    [/@ui.bambooSection]

[/@ww.form]