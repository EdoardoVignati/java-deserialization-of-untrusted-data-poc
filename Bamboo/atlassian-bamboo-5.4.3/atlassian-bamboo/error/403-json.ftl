[#-- Avoid double space if os_username is not set --]
{"status-code":"403","message":"Attempt to log in user ${(req.getParameter("os_username") + " ")!?html}failed. The maximum number of failed login attempts has been reached. Please log into the web application through the web interface to reset the number of failed login attempts."}
