[@ww.checkbox labelKey='repository.svn.useExternals' name='repository.svn.useExternals' /]
[@ww.checkbox labelKey='repository.svn.useExport' name='repository.svn.useExport' /]
[@ww.checkbox labelKey='repository.common.commitIsolation.enabled' name='commit.isolation.option' /]

[@ww.checkbox labelKey='repository.svn.branch.autodetectRootUrl' toggle=true name='repository.svn.branch.autodetectRootUrl'/]
[@ui.bambooSection dependsOn='repository.svn.branch.autodetectRootUrl' showOn=false]
    [@ww.textfield labelKey='repository.svn.branch.manualRootUrl' name='repository.svn.branch.manualRootUrl' cssClass="long-field" required=true/]
[/@ui.bambooSection]

[@ww.checkbox labelKey='repository.svn.tag.autodetectRootUrl' toggle=true name='repository.svn.tag.autodetectRootUrl'/]
[@ui.bambooSection dependsOn='repository.svn.tag.autodetectRootUrl' showOn=false]
    [@ww.textfield labelKey='repository.svn.tag.manualRootUrl' name='repository.svn.tag.manualRootUrl' cssClass="long-field" required=true/]
[/@ui.bambooSection]