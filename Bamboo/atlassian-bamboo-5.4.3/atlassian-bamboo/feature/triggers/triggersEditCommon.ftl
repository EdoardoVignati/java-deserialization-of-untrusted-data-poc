[#macro triggerListItem id name description editTriggerUrl confirmDeleteTriggerUrl]
<li class="item" data-item-id="${id}" id="item-${id}">
    <a href="${editTriggerUrl}&amp;triggerId=${id}">
        <h3 class="item-title">${name}</h3>
        [#if description?has_content]
            <div class="item-description">${description}</div>
        [/#if]
    </a>
    <a href="${confirmDeleteTriggerUrl}&amp;triggerId=${id}" class="delete" title="[@ww.text name='chain.trigger.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>
</li>
[/#macro]
[#macro triggersMainPanel triggers addTriggerUrl editTriggerUrl confirmDeleteTriggerUrl]
    <div id="panel-editor-setup" class="trigger-config[#if !triggers?has_content] no-items[/#if]">
        <p id="no-items-message">[@ww.text name="chain.triggers.noTriggersDefined" /]</p>

        <div id="panel-editor-list">
            <h2 class="assistive">[@ww.text name="chain.triggers.title" /]</h2>
            <ul>
                [#list triggers as trigger]
                    [@triggerListItem id=trigger.id name=trigger.name description=trigger.userDescription!?html editTriggerUrl=editTriggerUrl confirmDeleteTriggerUrl=confirmDeleteTriggerUrl/]
                [/#list]
            </ul>
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        <a href="${addTriggerUrl}" id="addTrigger" class="toolbar-trigger">[@ww.text name="chain.trigger.add" /]</a>
                    </li>
                </ul>
            </div>
        </div>
        <div id="panel-editor-config"></div>
    </div>

    <script type="text/x-template" title="triggerListItem-template">
        [@triggerListItem id="{id}" name="{name}" description="{description}" editTriggerUrl=editTriggerUrl confirmDeleteTriggerUrl=confirmDeleteTriggerUrl /]
    </script>

    <script type="text/x-template" title="triggerListItemDefaultMarker-template">
    </script>

    <script type="text/x-template" title="icon-template">
        [@ui.icon type="{type}" /]
    </script>

    <script type="text/javascript">
        BAMBOO.TRIGGER.chainTriggerConfig.init({
                                                   addTriggerTrigger: "#addTrigger",
                                                   triggerSetupContainer: "#panel-editor-setup",
                                                   triggerConfigContainer: "#panel-editor-config",
                                                   triggerList: "#panel-editor-list > ul",
                                                   templates: {
                                                       triggerListItem: "triggerListItem-template",
                                                       triggerListItemDefaultMarker: "triggerListItemDefaultMarker-template",
                                                       iconTemplate: "icon-template"
                                                   },
                                                   preselectItemId: ${triggerId!null}
                                               });

    </script>
[/#macro]