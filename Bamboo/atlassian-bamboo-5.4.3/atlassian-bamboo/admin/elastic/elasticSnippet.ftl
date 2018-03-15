[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<p>[@ww.text name='elastic.manage.running.description']
    [@ww.param value='${runningElasticInstances.size()}' /]
    [@ww.param value='${requestedElasticInstances.size()}' /]
[/@ww.text]</p>

<div class="toolbar">
    <div class="aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a class="toolbar-trigger" href="[@ww.url action='prepareElasticInstances' namespace='/admin/elastic' /]">[@ww.text name='elastic.manage.createAgents' /]</a>
            </li>
            [#if anyRunningElasticInstancesShutdownable]
                <li class="toolbar-item">
                    <a id="shutdownAllElasticInstances" class="toolbar-trigger" href="[@ww.url action='shutdownAllElasticInstances' namespace='/admin/elastic' /]">[@ww.text name='elastic.manage.shutdown.all' /]</a>
                </li>
            [/#if]
        </ul>
    </div>
</div>

[#if requestedElasticInstances?has_content]
    [@ui.messageBox type="info"]
        [@ww.text name='elastic.manage.instances.pending']
            [@ww.param value='${requestedElasticInstances.size()}' /]
        [/@ww.text]
    [/@ui.messageBox]
[/#if]

[#if elasticErrors?has_content]
    [#list elasticErrors as error]
        [@cp.showSystemError error=error returnUrl="/admin/elastic/manageElasticInstances.action"/]
    [/#list]
[/#if]

[#if runningElasticInstances?has_content]
    [@ela.listElasticInstances runningElasticInstances /]   
[/#if]

[#if elasticAgentLogs?has_content]
   <table id="remoteAgentLog">
       [#list elasticAgentLogs as line]
           <tr>
               <td>
                   ${line?html}
               </td>
           </tr>
       [/#list]
   </table>
[/#if]
<p class="subGrey">[@ww.text name='elastic.manage.refresh'/]</p>
