[#-- @ftlvariable name="" type="com.atlassian.bamboo.buildqueue.ViewRunningPlans" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.buildqueue.ViewRunningPlans" --]

<title>Builds running</title>
[@ww.form action="stopPlan" namespace="/build/admin"]

    [@ww.text name='build.stop.confirmation.warning' id='stopRunningBuilds']
        [@ww.param]${runningPlans.size()}[/@ww.param]
    [/@ww.text]
    [@ui.messageBox type="warning" title=stopRunningBuilds /]
    [#list runningPlans as plan]
    <p class="build-description">[#rt]
        <a href="${req.contextPath}/browse/${plan.planResultKey}">${plan.planResultKey}</a> ${plan.triggerReason.getNameForSentence()?html}[#t]
    </p>
    [/#list]
    [@ww.hidden name="planKey"/]
    [@ww.hidden name="returnUrl"/]
[/@ww.form]
