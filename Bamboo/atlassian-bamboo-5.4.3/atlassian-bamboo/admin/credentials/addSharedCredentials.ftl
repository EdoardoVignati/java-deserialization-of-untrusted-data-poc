[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@ww.form  action='createSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>[@ww.text name="sharedCredentials.add" /]</h2>

    [@ww.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@ww.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    [@ui.bambooSection id='credentials-configuration']
        [@ww.textarea labelKey='credentials.ssh.key' name='sshKeyFile' required=true/]
        [@ww.password labelKey='credentials.ssh.passphrase' name='sshPassphrase' /]
    [/@ui.bambooSection]
    
[/@ww.form]