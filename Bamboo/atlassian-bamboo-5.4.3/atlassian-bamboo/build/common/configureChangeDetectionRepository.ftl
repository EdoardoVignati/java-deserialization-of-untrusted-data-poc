[#include "/build/common/repositoryCommon.ftl"]

<div id="panel-editor-setup" class="repository-config[#if !repositoryDefinitions?has_content] no-items[/#if]">
    <p id="no-items-message">[@ww.text name="repository.config.noRepositoryDefined" /]</p>
    <div id="panel-editor-list">
        <h2 class="assistive">[@ww.text name="repositories.title" /]</h2>
        <ul>
            [#list repositoryDefinitions as repoDef]
                [@repositoryListItem id=repoDef.id name=repoDef.name!?html isDefault=(repoDef_index == 0)/]
            [/#list]
        </ul>
        <div class="aui-toolbar inline">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    <a href="[@ww.url action="addRepository" namespace="/chain/admin/config" planKey=planKey returnUrl=currentUrl /]" id="addRepository" class="toolbar-trigger">[@ww.text name="repository.add" /]</a>
                </li>
            </ul>
        </div>
    </div>
    <div id="panel-editor-config"></div>
</div>

[@dj.simpleDialogForm
    triggerSelector=".repositoryTools"
    width=600
    height=300
    headerKey="repository.shared.convert"
    submitCallback="reloadThePage"/]

<script type="text/x-template" title="repositoryListItem-template">
[@repositoryListItem id="{id}" name="{name}"/]
</script>

<script type="text/x-template" title="repositoryListItemDefaultMarker-template">
<span class="item-default-marker grey">[@ww.text name='repository.default'/]</span>
</script>

<script type="text/x-template" title="icon-template">
[@ui.icon type="{type}" /]
</script>

<script type="text/javascript">
    BAMBOO.REPOSITORY.repositoryConfig.init({
        addRepositoryTrigger: "#addRepository",
        repositorySetupContainer: "#panel-editor-setup",
        repositoryConfigContainer: "#panel-editor-config",
        repositoryList: "#panel-editor-list > ul",
        templates: {
            repositoryListItem: "repositoryListItem-template",
            repositoryListItemDefaultMarker: "repositoryListItemDefaultMarker-template",
            iconTemplate: "icon-template"
        },
        moveRepositoryUrl: "[@ww.url action="moveRepository" namespace="/build/admin/ajax" planKey=planKey /]",
        getRepoConfigUrl: "[@ww.url action='getRepositoryOption' namespace='/chain/admin/config' planKey=planKey /]",
        preselectItemId: ${repositoryId!null}
    });
</script>

[#macro repositoryListItem id name isDefault=false]
<li class="item[#if isDefault] item-default[/#if]" data-item-id="${id}" id="item-${id}">
    <a href="[@ww.url action="editRepository" namespace="/chain/admin/config" planKey=planKey /]&amp;repositoryId=${id}">
        <h3 class="item-title">${name}[#if isDefault] <span class="item-default-marker grey">[@ww.text name='repository.default'/]</span>[/#if]</h3>
    </a>
    <a href="[@ww.url action="confirmDeleteRepository" namespace="/chain/admin/config" planKey=planKey /]&amp;repositoryId=${id}" class="delete" title="[@ww.text name='repository.delete' /]"><span class="assistive">[@ww.text name="global.buttons.delete" /]</span></a>
</li>
[/#macro]