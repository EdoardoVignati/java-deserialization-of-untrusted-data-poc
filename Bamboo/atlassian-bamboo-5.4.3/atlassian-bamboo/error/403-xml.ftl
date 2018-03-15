[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<status>
    <status-code>403</status-code>
[#-- Avoid double space if os_username is not set --]
    <message>Attempt to log in user ${(req.getParameter("os_username") + " ")!?xml}failed. The maximum number of failed login attempts has been reached. Please log into the web application through the web interface to reset the number of failed login attempts.</message>
</status>