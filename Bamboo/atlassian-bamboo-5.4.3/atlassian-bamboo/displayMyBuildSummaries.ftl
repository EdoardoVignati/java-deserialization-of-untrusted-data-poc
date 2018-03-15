[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
<div id="my-summary">
    <div id="my-details">
        [#if user??]
            [@ui.displayUserGravatar userName=user.name size='48' class="avatar" alt="${user.fullName?html}"/]
            <h2>[@ui.displayUserFullName user=user/]</h2>
        [/#if]
    </div>

    <ul class="overall-summary">
        [#list ctx.getWebPanels("dashboard.mybamboo.top") as webpanel]
            <li>${webpanel}</li>
        [/#list]
    </ul>
</div>

<div class="aui-group" id="my-bamboo">
    <div class="aui-item">
        [#list ctx.getWebPanels("dashboard.mybamboo.left") as webpanel]
            [#if webpanel?trim?has_content]
                <div>${webpanel}</div>
            [/#if]
        [/#list]
    </div>
    <div class="aui-item">
        [#list ctx.getWebPanels("dashboard.mybamboo.right") as webpanel]
            [#if webpanel?trim?has_content]
                <div>${webpanel}</div>
            [/#if]
        [/#list]
    </div>
</div>