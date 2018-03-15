[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[@ww.select labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
 	 	 	 	 	list='bulkAction.webRepositoryViewers' listKey='key' listValue='name']
[/@ww.select]
[#list bulkAction.webRepositoryViewers as viewer]
    [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn='${viewer.key}']
        ${viewer.getEditHtml(bulkAction.mockBuildConfiguration, bulkAction.mockBuildForEdit)!}
    [/@ui.bambooSection]
[/#list]
