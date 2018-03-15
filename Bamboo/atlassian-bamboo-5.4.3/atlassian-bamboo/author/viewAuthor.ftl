[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthor" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthor" --]
[#import "/fragments/buildResults/displayAuthorBuildsTable.ftl" as buildList]

<html>
<head>
    [@ui.header pageKey='Author Profile' object=author.name title=true /]
</head>

<body>
    [@ui.header pageKey='Author Summary' object=author.name headerElement='h2' /]


    [@dj.tabContainer  headings=['Builds Summary', 'Last 10 Builds', 'Last 10 Broken', 'Last 10 Fixed']
                       selectedTab='${selectedTab!}']
        [@dj.contentPane labelKey='Builds Summary']
            [@cp.displayAuthorSummary author=author /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='Last 10 Builds']
            [@buildList.displayAuthorBuildsTable buildResults=author.triggeredBuildResults totalBuildNumber=author.numberOfTriggeredBuilds /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='Last 10 Broken']
            [@buildList.displayAuthorBuildsTable buildResults=author.breakages totalBuildNumber=author.numberOfBreakages /]
        [/@dj.contentPane]
        [@dj.contentPane labelKey='Last 10 Fixed']
            [@buildList.displayAuthorBuildsTable buildResults=author.fixes totalBuildNumber=author.numberOfFixes /]
        [/@dj.contentPane]

    [/@dj.tabContainer ]






</body>
</html>