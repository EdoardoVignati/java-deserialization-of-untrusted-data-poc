<nav class="global" role="navigation">
    <div class="primary">
        <h1 id="logo"><a href="${req.contextPath}/start.action" rel="nofollow">[@ww.text name='bamboo.name' /]</a></h1>
    </div>
    <div class="secondary">
        <ul>
        [#if ctx?? && ctx.getUser(req)??]
            <li id="userInfo" class="aui-dd-parent" data-username="${ctx.getUser(req).name?html}">
                <span class="aui-dd-trigger"><span>[@ui.displayUserFullName user=ctx.getUser(req) /]</span>[@ui.icon type="drop" /]</span>
                <ul class="aui-dropdown hidden">
                    [#if ctx.featureManager.userProfileEnabled]
                        <li id="profileLink" class="dropdown-item">
                            <a id="profile" class="item-link" href="${req.contextPath}/profile/userProfile.action">[@ww.text name='bamboo.banner.profile' /]</a>
                        </li>
                    [/#if]
                    <li id="helpLink" class="dropdown-item">
                        <a id="help" class="item-link" href="http://confluence.atlassian.com/display/BAMBOO" rel="help">[@ww.text name='bamboo.banner.help' /]</a>
                    </li>
                    <li id="logoutLink" class="dropdown-item">
                        <a id="log-out" class="item-link" href="${req.contextPath}/userLogout.action">[@ww.text name='bamboo.banner.logout' /]</a>
                    </li>
                </ul>
            </li>
        [#elseif ctx??]
            <li id="loginLink">
                <a id="login" href="${req.contextPath}/userlogin!default.action?os_destination=${ctx.getCurrentUrl(req)?url}">[@ww.text name='bamboo.banner.login' /]</a>
            </li>
            [#if ctx.isEnableSignup() ]
                <li id="signupLink">
                    <a id="signup" href="${req.contextPath}/signupUser!default.action">[@ww.text name='bamboo.banner.signup' /]</a>
                </li>
            [/#if]
        [/#if]
        </ul>
    </div>
</nav> <!-- END nav.global -->
