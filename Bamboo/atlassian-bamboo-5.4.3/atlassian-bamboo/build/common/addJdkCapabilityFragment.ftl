[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedLocalCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedLocalCapability" --]
[@ww.form action="addSharedJdkCapability" namespace="/ajax"
        descriptionKey='builder.inline.addCapability.description'
        submitLabelKey="global.buttons.add"]
    [@ww.hidden name="returnUrl" /]

    [@ww.textfield labelKey='agent.capability.type.jdk.key' name='jdkLabel' /]
    [@ww.textfield labelKey='agent.capability.type.jdk.value' name='jdkPath' /]

    [@ww.hidden name='capabilityType' value='jdk' /]
[/@ww.form]