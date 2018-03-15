[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[#import "/lib/build.ftl" as bd]

[@ui.header pageKey='build.bulkEditPermissions.title' title=true /]
[@ui.header pageKey='build.bulkEditPermissions.title' /]

[@bd.configurePermissions action='confirmBulkEditPermissions' cancelUri='/admin/chooseBuildsToBulkEditPermissions.action' /]