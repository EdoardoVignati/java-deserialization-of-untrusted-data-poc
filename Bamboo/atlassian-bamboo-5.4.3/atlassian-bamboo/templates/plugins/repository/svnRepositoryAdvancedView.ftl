[@ww.label labelKey='repository.svn.useExternals' value=repository.useExternals hideOnNull=true /]
[@ww.label labelKey='repository.svn.useExport' value=repository.useExport hideOnNull=true /]
[@ww.label labelKey='repository.common.commitIsolation.enabled' value=repository.commitIsolationEnabled hideOnNull=true /]

[#if !repository.autodetectBranchRootUrl]
    [@ww.label labelKey='repository.svn.branch.manualRootUrl' value=repository.manualBranchRootUrl/]
[/#if]

[#if !repository.autodetectTagRootUrl]
    [@ww.label labelKey='repository.svn.tag.manualRootUrl' value=repository.manualTagRootUrl/]
[/#if]