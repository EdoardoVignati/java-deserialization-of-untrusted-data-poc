<section class="notifications">
    [#assign serverStatusInfo = ctx.serverStatusInfo /]
    [#assign serverPausedOrPausing = serverStatusInfo.serverLifecycleState == "PAUSED" || serverStatusInfo.serverLifecycleState == "PAUSING" /]
    [#assign showSystemState = serverPausedOrPausing || serverStatusInfo.reindexInProgress /]

    [@ui.messageBox id="system-state-banner" type="warning" hidden=!showSystemState]
        <span id="system-state-banner-info"></span>
        [#if fn.hasAdminPermission()]
            <span class="aui-button"></span>
        [/#if]
    [/@ui.messageBox]
    <script type="text/javascript">
        if (BAMBOO && BAMBOO.ADMIN && BAMBOO.ADMIN.SERVERSTATE) {
            BAMBOO.ADMIN.SERVERSTATE.serverState.init({
                control: "#system-state-banner",
                statusInfo: "#system-state-banner-info",
                button: ".aui-button",
                serverRunningCallback: function() {
                    var $pause = AJS.$("#pause-server-button");

                    if ($pause && $pause.length) {
                        $pause.removeClass("disabled");
                    }
                }
            });
        }
    </script>
</section>