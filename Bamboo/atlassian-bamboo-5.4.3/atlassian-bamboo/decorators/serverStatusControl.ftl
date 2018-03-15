[#if fn.hasGlobalAdminPermission()]
    <div id="server-lifecycle-state" class="hidden">${ctx.serverLifecycleState}</div> <!-- for functional tests -->
    [@ui.messageBox id="upm-server-running-warning" type="warning" hidden=ctx.serverLifecycleState == "PAUSED"]
        <p id="server-running-message-title" class="title">[@ww.text name=warningTitle][@ww.param]<strong>[/@ww.param][@ww.param]</strong>[/@ww.param][/@ww.text]</p>
        <p id="server-running-message">[@ww.text name=warningMessage][@ww.param]<strong>[/@ww.param][@ww.param]</strong>[/@ww.param][/@ww.text]</p>
        <a id="upm-pause-server-button" class="aui-button"[#if ctx.serverLifecycleState != "RUNNING"] aria-disabled="true"[/#if]>[@ww.text name="serverstate.pause"/]</a>
    [/@ui.messageBox]
    <script type="text/javascript">
        AJS.$(function($) {
            var $upmPauseButton = $("#upm-pause-server-button").click(function(event) {
                BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.pause();
            });

            BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.onServerStatusUpdated(function(event, oldState, newState, info) {

                var $warning = $("#upm-server-running-warning");
                if (newState.state == BAMBOO.ADMIN.STATUS_PAUSED || newState.state == BAMBOO.ADMIN.STATUS_ERROR) {
                    $warning.hide();
                } else {
                    $warning.show();
                }
                $upmPauseButton.attr("aria-disabled", (newState.state != BAMBOO.ADMIN.STATUS_RUNNING));
            });

            BAMBOO.ADMIN.SERVERSTATE.serverStateUpdater.onServerStatusAction(function(event, action) {
                $upmPauseButton.removeAttr("aria-disabled");
            });
        });
    </script>
[/#if]
    ${body}