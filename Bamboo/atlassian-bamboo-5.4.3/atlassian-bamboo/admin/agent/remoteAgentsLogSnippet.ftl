[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
    [#if remoteAgentLog?has_content]
        <table id="remoteAgentLog">
            [#list remoteAgentLog as line]
            <tr>
                <td>
                    ${line?html}
                </td>
            </tr>
            [/#list]
        </table>
        <div class="subGrey">
           [@ww.text name="agent.remote.log.refresh"/]
        </div>
    [/#if]
