[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.AbstractViewCapabilitiesByType" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.AbstractViewCapabilitiesByType" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='${capabilityTypeString}.admin.heading' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='${capabilityTypeString}.admin.heading' /]</h1>

    <p>[#rt]
        [@ww.text name='${capabilityTypeString}.admin.description']
            [@ww.param]
                [@ww.url action="configureSharedLocalCapabilities" namespace="/admin/agent" returnUrl=currentUrl capabilityType=capabilityTypeString /]#addCapability[#t]
            [/@ww.param]
            [@ww.param]${capabilityTypeString?html}addSystem[/@ww.param]
        [/@ww.text]
    </p>[#lt]

    <div class="capabilitiesParent">
        <ul>
            [#assign lastCapability = '' /]
            [#list systemCapabilityKeys?sort as capabilityKey]
                    <li>
                        [#assign  capabilityTitle=action.getNormalisedCapabilityLabel(capabilityKey)/]
                        <a href="[@ww.url action="viewCapabilitySnippet" namespace="/ajax" capabilityKey=capabilityKey parentUrl='${currentUrl}'/]" title="${capabilityTitle}">[#rt]
                        ${action.getCapabilityLabel(capabilityKey)?html} [#t]
                        [#assign  extraInfo = action.getCapabilityExtraInfo(capabilityKey)! /]
                        [#if extraInfo?has_content]
                            <span>(${extraInfo})</span>[#t]
                        [/#if]
                        </a>[#lt]
                    </li>
            [/#list]
        </ul>
    </div>

    <script type="text/javascript">
        AJS.$(function(){
            AJS.$(".capabilitiesParent").tabs();
        });
    </script>
</body>
</html>
