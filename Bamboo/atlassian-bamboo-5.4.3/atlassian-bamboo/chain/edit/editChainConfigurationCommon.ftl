[#macro editChainConfigurationPage plan selectedTab titleKey descriptionKey='' description='' tools='' toolsContainer='div']
<html>
<head>
    [@ui.header pageKey='chain.configuration.edit.title.long' object=plan.name title=true /]
    <meta name="tab" content="${selectedTab}" />
</head>
<body>
[#if tools?has_content]
    <${toolsContainer} class="floating-toolbar">
        ${tools}
    </${toolsContainer}>
[/#if]
[@ui.header pageKey=titleKey descriptionKey=descriptionKey description=description/]
[#nested /]
</body>
</html>
[/#macro]