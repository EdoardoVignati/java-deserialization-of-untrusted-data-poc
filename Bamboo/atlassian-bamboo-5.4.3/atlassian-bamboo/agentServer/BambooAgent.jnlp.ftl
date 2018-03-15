<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE jnlp PUBLIC "-//Sun Microsystems, Inc//DTD JNLP Descriptor 6.0//EN" "http://java.sun.com/dtd/JNLP-6.0.dtd">

<jnlp codebase="${baseUrl}/agentServer/">

  <information>
    <title>Bamboo Agent</title>
    <vendor>Atlassian Software Systems Pty Ltd</vendor>
  </information>

  <security>
    <all-permissions/>
  </security>

  <resources>
    <j2se version="1.4+"/>
    <jar href="atlassian-bamboo-agent-installer.jar" main="true"/>
  </resources>

  <application-desc>
    <argument>${mainClass}</argument>
  </application-desc>

</jnlp>