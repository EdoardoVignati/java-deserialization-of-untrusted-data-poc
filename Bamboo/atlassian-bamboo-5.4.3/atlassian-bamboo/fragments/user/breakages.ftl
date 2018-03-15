[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#import "/fragments/buildResults/displayAuthorBuildsTable.ftl" as buildList]
[@buildList.displayAuthorBuildsTable buildResults=author.breakages /]