<div id="ajaxErrorHolder" class="hidden">
    [@ui.messageBox type="warning"]
            [@ww.text name='error.dashboard.refresh.noResponse']
                [@ww.param]${req.contextPath}[/@ww.param]
            [/@ww.text]
            <span class="ajaxErrorMessage"></span>
    [/@ui.messageBox]
</div>