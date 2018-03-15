[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewRemoteAgentAuthentications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewRemoteAgentAuthentications" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]


[#-- Description at the top--]
[#if  authenticationCount > 0]
    [@ww.text name="agent.remote.authentication.description" /]
[#else]
    [@ww.text name="agent.remote.authentication.description.none"/]
[/#if]

[#--The Data Table--]
[#if fn.hasAdminPermission() &&  authenticationCount > 0]
    [@ww.form action="configureAgentAuthentications!default.action" namespace="/admin/agent" id="remoteAgentAuthenticationConfiguration" theme="simple"]

    [#-- Operations --]
    <p>
        <span>
            [@ww.text name='global.selection.select' /]:
            <span tabindex="0" role="link" data-selector-id="remoteAgentAuthentications" data-selector-type="ALL">[@ww.text name='global.selection.all' /]</span>,
            <span tabindex="0" role="link" data-selector-id="remoteAgentAuthentications" data-selector-type="NONE">[@ww.text name='global.selection.none' /]</span>,
            <span tabindex="0" role="link" data-selector-id="remoteAgentAuthentications" data-selector-type="WAITING_FOR_APPROVAL">[@ww.text name='agent.remote.authentication.status.waitingForApproval' /]</span>,
            <span tabindex="0" role="link" data-selector-id="remoteAgentAuthentications" data-selector-type="APPROVED">[@ww.text name='agent.remote.authentication.status.approved' /]</span>
        </span>

        <span class="form-actions-bar">
            [@ww.text name='global.selection.action' /]:
            <span class="aui-buttons">
                [@ww.submit value=action.getText("agent.remote.authentication.action.approve") theme="simple" name="approve" id="approveAgentAuthenticationButton" titleKey="agent.remote.authentication.action.approve.description" cssClass="aui-button" /]
                [@ww.submit value=action.getText("agent.remote.authentication.action.revokeApproval") theme="simple" name="revokeApproval" id="revokeApprovalFromAgentAuthenticationButton" titleKey="agent.remote.authentication.action.revokeApproval.description" cssClass="aui-button" /]
            </span>
        </span>
    </p>
    <table id="remote-agent-authentications" class="aui">
        <colgroup>
            <col width="5">
            <col/>
            <col/>
            <col/>
            <col width="200"/>
        </colgroup>
        <thead>
        <tr>
            <th>&nbsp;</th>
            <th>[@ww.text name='agent.remote.authentication.ipAddress' /]</th>
            <th>[@ww.text name='agent.remote.authentication.uuid' /]</th>
            <th>[@ww.text name='agent.table.heading.status' /]</th>
            <th>[@ww.text name='agent.table.heading.operations' /]</th>
        </tr>
        </thead>
        <tbody>
            [#foreach authentication in allAuthentications]
                [#assign uuidString="${authentication.uuid.toString()}" /]
                [#if authentication.approved]
                    [#assign discriminator="APPROVED" /]
                    [#assign statusKey="agent.remote.authentication.status.approved" /]
                    [#assign actionKey="revokeApproval" /]
                [#else]
                    [#assign discriminator="WAITING_FOR_APPROVAL" /]
                    [#assign statusKey="agent.remote.authentication.status.waitingForApproval" /]
                    [#assign actionKey="approve" /]
                [/#if]
                <tr data-row="${uuidString}" [#if action.focusUuid?? && action.focusUuid==uuidString]class="highlight"[/#if]>
                    <td data-cell-type="select">
                        <input name="remoteAgentAuthentications" type="checkbox" value="${uuidString}" data-selector-discriminator="${discriminator}">
                    </td>
                    <td data-cell-type="ipAddress">${authentication.ip}</td>
                    <td data-cell-type="uuid">${uuidString}</td>
                    <td data-cell-type="status" data-authentication-status="${statusKey}">[@ww.text name='${statusKey}' /]</td>
                    <td data-cell-type="operations">
                        <a id="${actionKey}-${uuidString}" class="mutative" href="[@ww.url action='configureAgentAuthentications!${actionKey}.action' namespace='/admin/agent' authenticationUuid='${uuidString}'/]">
                            [@ww.text name='agent.remote.authentication.action.${actionKey}' /]
                        </a>
                        [#if authentication.approved]
                            |
                            <a id="edit-ip-${uuidString}" title="${action.getText('agent.remote.authentication.action.editIp.description')}" data-dialog-type="edit-ip"
                                    href="[@ww.url action='editAgentAuthenticationIp.action' namespace='/admin/agent' authenticationUuid='${uuidString}'/]">
                                [@ww.text name='agent.remote.authentication.action.editIp' /]
                            </a>
                        [/#if]
                    </td>
                </tr>
            [/#foreach]
        </tbody>
    </table>
    <script type="text/javascript">
        AJS.$(function ()
              {
                  GenericSelectionActions.init("remoteAgentAuthenticationConfiguration", "remoteAgentAuthentications");
              });
    </script>
        [@dj.simpleDialogForm triggerSelector="a[data-dialog-type=edit-ip]" width=500 height=260
        headerKey="agent.remote.authentication.action.editIp.title" submitCallback="reloadThePage" /]
    [/@ww.form]

[/#if]

