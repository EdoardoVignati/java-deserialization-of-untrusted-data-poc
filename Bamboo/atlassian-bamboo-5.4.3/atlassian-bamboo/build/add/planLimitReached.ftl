<title>[@ww.text name="build.plan.limit.reached.heading"/]</title>

[@ui.messageBox type="error" titleKey="build.plan.limit.reached.heading"]
    [@ww.text name="build.plan.limit.reached.message"]
           [@ww.param value="${uiConfigBean.allowedNumberOfPlans}" /]
    [/@ww.text]
    [#if fn.hasGlobalPermission('ADMINISTRATION') ]
    <br/> [@ww.text name="build.plan.limit.reached.message.admin"]
           [@ww.param value="${uiConfigBean.currentPlanCount}"/]
           [@ww.param]${req.contextPath}/admin/updateLicense!default.action[/@ww.param]
    [/@ww.text]
    [/#if]
[/@ui.messageBox]