[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ChangeForgottenPassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ChangeForgottenPassword" --]
<html>
<head>
	<title>Bamboo Profile[#if user?exists]: [@ui.displayUserFullName user=user /][/#if]</title>
</head>
<body>
    <h1>[@ww.text name='user.password.reset' /]</h1>
     [#if actionErrors?has_content]
         [@ui.messageBox type='error']
            [#list formattedActionErrors as error]
		        ${error}
	        [/#list]
            <p>
                [@ww.text name='user.password.reset.startover']
                    [@ww.param][@ww.url action='forgotPassword!default' namespace='' /][/@ww.param]
                [/@ww.text]
            </p>
         [/@ui.messageBox]
    [#else]
        <p>[@ww.text name='user.password.change.description' /]</p>
        [@ww.form action="changeForgottenPassword" namespace="/profile" submitLabelKey='user.password.change.button' cancelUri='/profile/userProfile.action' titleKey='user.password.change.title' ]
            [@ww.hidden name="username" /]
            [@ww.hidden name="token" /]
            [@ww.password labelKey='user.password.change.new' name="newPassword" showPassword="true" required="true" /]
            [@ww.password labelKey='user.password.change.new.confirm' name="confirmedPassword" showPassword="true"
            required="true" /]
        [/@ww.form]
    [/#if]
</body>
</html>