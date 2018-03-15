[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[@ww.textfield labelKey='repository.cvs.module' name='repository.cvs.module' required='true' /]

[@ww.select labelKey='repository.cvs.module.versionType' name='repository.cvs.selectedVersionType'
            listKey='name' listValue='label' toggle='true'
            list=bulkAction.repository.versionTypes required='true' helpKey='cvs.module.version' /]

[@ui.bambooSection dependsOn='repository.cvs.selectedVersionType' showOn='branch']
    [@ww.textfield labelKey='repository.cvs.module.branch' name='repository.cvs.branchName' /]
[/@ui.bambooSection]
