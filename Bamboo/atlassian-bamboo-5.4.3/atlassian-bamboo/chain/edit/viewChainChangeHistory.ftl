[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainAuditLog" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainAuditLog" --]

<html>
<head>
    [@ui.header pageKey='chain.auditLog.title' object='${immutablePlan.name}' title=true /]
    <meta name="tab" content="auditLog"/>
</head>
<body>
    [#if filterStart > 0 || filterEnd >0]
        [#assign descriptionText]
            [@ww.text name='auditlog.configuration.recent']
                [@ww.param]${filterStartDate?datetime}[/@ww.param]
                [@ww.param]${filterEndDate?datetime}[/@ww.param]
            [/@ww.text]
        [/#assign]
        [@ui.header pageKey="chain.auditLog.title" description=descriptionText /]
        <p><a href="[@ww.url action='viewChainAuditLog' namespace='/chain/admin/config' planKey=planKey /]">[@ww.text name='auditlog.switch.view'][@ww.param]${immutablePlan.name}[/@ww.param][/@ww.text]</a></p>
    [#else]
        [@ui.header pageKey="chain.auditLog.title" descriptionKey="auditlog.configuration.changes" /]
        [#if pager.getPage()??]
            <p>
                <a href="[@ww.url action='deleteChainAuditLog' namespace='/chain/admin/config' planKey=planKey/]" class="requireConfirmation mutative" title="[@ww.text name='auditlog.delete.confirmation'/]">
                    [@ww.text name='auditlog.delete'][@ww.param]${immutablePlan.name}[/@ww.param][/@ww.text]
                </a>
            </p>
        [/#if]
    [/#if]
    [@cp.configChangeHistory pager=pager showChangedEntityDetails=true jobMap=jobMap/]

</body>
</html>