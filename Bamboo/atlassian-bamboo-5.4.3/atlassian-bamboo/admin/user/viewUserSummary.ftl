[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#import "/fragments/buildResults/displayAuthorBuildsTable.ftl" as buildList]

<html>
<head>
	[@ui.header pageKey='User Profile' object='${fn.getUserFullName(currentUser)}' title=true/]
</head>
<body>
    [@ui.header pageKey='User Summary' object='${fn.getUserFullName(currentUser)}' headerElement='h2' /]

    [#if author??]
        [#assign tabHeadings=['User Details', 'Builds Summary', 'Last 10 Builds', 'Last 10 Broken', 'Last 10 Fixed'] /]
    [#else]
        [#assign tabHeadings=['User Details'] /]
    [/#if]

    [@dj.tabContainer headings=tabHeadings selectedTab='${selectedTab!}']
        [@dj.contentPane labelKey='User Details']
            [@ui.bambooInfoDisplay  titleKey='user.personal.details' height='300px']
                [@ww.label labelKey='user.username' name='currentUser.name' /]
                [@ww.label labelKey='user.fullName' name='currentUser.fullName' /]

                [#if viewContactDetails ]
                    [@ww.label labelKey='user.email' name='currentUser.email' /]
                    [@ww.label labelKey='user.jabber' name='currentUser.jabberAddress' /]

                    [#if groups?has_content]
                        [#assign groupList='' /]
                        [#list groups as group]
                            [#assign groupList='${groupList} ${group}' /]
                            [#if group_has_next]
                                [#assign groupList='${groupList},' /]
                            [/#if]
                        [/#list]
                        [@ww.label labelKey='user.groups' value='${groupList}'/]
                    [/#if]
                [/#if]
                [#if repositoryAliases?has_content]
                    [#assign list='' /]
                    [#list repositoryAliases as author]
                        [#assign list='${list} ${author.name!?html}' /]
                        [#if author_has_next]
                            [#assign list='${list},' /]
                        [/#if]
                    [/#list]
                    [@ww.label labelKey='user.repositoryAliases' value='${list}' escape=false/]
                [/#if]
            [/@ui.bambooInfoDisplay]
        [/@dj.contentPane]

        [#if author??]
            [@dj.contentPane labelKey='Builds Summary']
                [@cp.displayAuthorSummary author=author /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='buildResult.summary.builds']
                <h3>
                    [@ww.text name='buildResult.summary.builds' /]
                </h3>
                [@buildList.displayAuthorBuildsTable buildResults=author.triggeredBuildResults totalBuildNumber=author.numberOfTriggeredBuilds /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='buildResult.summary.broken']
                <h3>
                    [@ww.text name='buildResult.summary.broken' /]
                </h3>
                [@buildList.displayAuthorBuildsTable buildResults=author.breakages totalBuildNumber=author.numberOfBreakages /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='buildResult.summary.fixed']
                <h3>
                    [@ww.text name='buildResult.summary.fixed' /]
                </h3>
                [@buildList.displayAuthorBuildsTable buildResults=author.fixes totalBuildNumber=author.numberOfFixes /]
            [/@dj.contentPane]
        [/#if]
    [/@dj.tabContainer ]
</body>
</html>
