<div id="error-messages-container" class="hidden"></div>

<div id="issue-controls-container" class="hidden">
    <dl>
        <dt>[@ww.text name='transition.issue.dialog.issue'/]:</dt>
        <dd>
            <div id="issue-details">
            </div>
        </dd>
    </dl>

    <dl>
        <dt>[@ww.text name='transition.issue.dialog.status'/]:</dt>
        <dd>
            <div id="issue-status">
            </div>
        </dd>
    </dl>

    <dl class="issue-transitions">
        <dt>[@ww.text name='transition.issue.dialog.transitionIssue'/]:</dt>
        <dd>
            [#--[@cp.displayLinkButton buttonId="transition-button" buttonLabel="Review Completed"/]--]
            <button id="transition-button"/>
            <select id="transition-select" />
            <span id="transition-issue-resolution">
                <span class="message" style="">[@ww.text name='transition.issue.dialog.chooseResolution'/]:</span>
                [#--[@cp.displayLinkButton buttonId="resolution-button" buttonLabel="Fixed"/]--]
                <button id="resolution-button"/>
                <select id="resolution-select" />
            </span>
        </dd>
    </dl>
</div>

<div id="login-dance-message-container" class="hidden"></div>

<div id="loading-spinner" >[@ui.icon type="loading" /]</div>

<script type="text/x-template" title="issueDetails-template">
    <a href="{url}" title="{title}'"><img src="{iconUrl}"/>{key}</a>
    <span> &#150; {title}</span>
</script>

<script type="text/x-template" title="issueStatus-template">
    <img src="{iconUrl}"/><span>{name}</span>
</script>

<script type="text/x-template" title="authenticationRequired-template">
    [@cp.oauthAuthenticationRequest "{authenticationUrl}"/]
</script>
