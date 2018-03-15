[@ww.label labelKey='repository.svn.repository' value='${repository.repositoryUrl?html}' /]
[#if repository.username?has_content]
    [@ww.label labelKey='repository.svn.username' value='${repository.username?html}' /]
[#else]
    [@ww.label labelKey='repository.svn.username' value="<i>[none specified]</i>" escape='false' /]
[/#if]
[@ww.label labelKey='repository.svn.authentication' value='${repository.authType}' /]
[@ww.label labelKey='repository.svn.keyFile' value='${repository.keyFile!}' hideOnNull='true' /]

[@ww.label labelKey='repository.svn.useExternals' value='${repository.useExternals?string}' hideOnNull='true' /]
[@ww.label labelKey='repository.svn.useExport' value='${repository.useExport?string}' hideOnNull='true' /]

[@ww.label labelKey='repository.common.commitIsolation.enabled' value='${repository.commitIsolationEnabled?string}' hideOnNull='true' /]

[#if repository.useExternals && repository.externalPathRevisionMappings?has_content]
    <table class="aui">
            <thead>
            <tr>
                <th>
                    Externals Path
                </th>
                <th>
                    Revision
                </th>
            </tr>
        </thead>
        <tbody>
        [#list repository.externalPathRevisionMappingsSorted.entrySet() as entry]
            <tr>
                <td>
                    ${entry.key}
                </td>
                <td>
                    ${entry.value}                    
                </td>
            </tr>
        [/#list]
        </tbody>
    </table>
[/#if]
