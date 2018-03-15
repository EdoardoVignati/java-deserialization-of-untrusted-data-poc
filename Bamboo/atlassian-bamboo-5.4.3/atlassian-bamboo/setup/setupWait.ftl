[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.FinishSetupAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.FinishSetupAction" --]
<html>
<head>
    <title>${waitMessage}</title>
    [#if waitStep??]
        <meta name="step" content="${waitStep}">
    [/#if]
</head>
<div>
    <h2 id="setupWaitMessage">${waitMessage}</h2>
    <div id="candyBar"></div>
</div>

<script type="text/javascript">
    BAMBOO.SetupWait.init({
        currentUrl: "${currentUrl?js_string}",
        [#if completedUrl?has_content]completedUrl: "${completedUrl?js_string}",[/#if]
        spinnerId: "candyBar"
    });
</script>
