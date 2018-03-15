[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[@ui.header pageKey='build.bulkEditPermissions.title' title=true /]
[@ui.header pageKey='build.bulkEditPermissions.title' /]

[@ui.messageBox type="warning" titleKey='build.bulkEditPermissions.warning' /]

[@ww.text name='build.bulkEditPermissions.description' id='bulkEditPermissionsBuildDescription' /]

[#if projects?has_content]
    [@ww.form action='specifyBulkEditPermissions'
              namespace='/admin'
              submitLabelKey='global.buttons.next'
              titleKey='build.bulkEditPermissions.form.title'
              description=bulkEditPermissionsBuildDescription]
        [@cp.displayBulkActionSelector bulkAction=action checkboxFieldValueType='id' planCheckboxName='buildIds' /]
    [/@ww.form]
[#else]
    [@ww.text name='build.bulkEditPermissions.plans.none' /]
[/#if]

