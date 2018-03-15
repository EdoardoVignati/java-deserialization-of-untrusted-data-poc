[#-- @ftlvariable name="artifactHandlerDescriptors" type="java.util.List<com.atlassian.bamboo.plugin.descriptor.ArtifactHandlerModuleDescriptor>" --]

<h3>[@ww.text name='webitems.system.admin.plugins.artifactHandlers' /]</h3>

<table class="aui">
    <thead>
    <tr>
        <th>Artifact Handler Name</th>
        <th class="checkboxCell">Enabled for Shared Artifacts</th>
        <th class="checkboxCell">Enabled for Non-Shared Artifacts</th>
    </tr>
    </thead>
[#list artifactHandlerDescriptors as artifactHandlerDescriptor]
    <tbody>
        <tr>
            <td>${artifactHandlerDescriptor.name}</td>
            <td class="checkboxCell">[@ww.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForShared' /]</td>
            <td class="checkboxCell">[@ww.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForNonShared' /]</td>
        </tr>
    </tbody>
[/#list]
</table>
