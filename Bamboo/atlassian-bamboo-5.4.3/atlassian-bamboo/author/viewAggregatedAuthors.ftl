[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAggregatedAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAggregatedAuthors" --]

<html>
<head>
    [@ui.header pageKey='author.statistics.aggregatedAuthors.title' object='' title=true /]
    <meta name="decorator" content="bamboo.authors"/>
    <meta name="tab" content="users" />
</head>
<body>

[@ui.header pageKey='Users' /]
[#if usersBuildStatistics?has_content]
    <p>[@ww.text name="author.statistics.aggregatedAuthors.description"/]</p>

    <table id="userTable" class="aui tablesorter">
        <thead>
            <tr>
                <th>[@ww.text name="author.name"/]</th>
                <th>[@ww.text name="author.statistics.triggered"/]</th>
                <th>[@ww.text name="author.statistics.failed"/]</th>
                <th>[@ww.text name="author.statistics.percentageFailed"/]</th>
                <th title="[@ww.text name='author.statistics.broken.description'/]">[@ww.text name="author.statistics.broken"/]</th>
                <th title="[@ww.text name='author.statistics.fixed.description'/]">[@ww.text name="author.statistics.fixed"/]</th>
                <th title="[@ww.text name='author.statistics.score.description'/]">[@ww.text name="author.statistics.score"/]</th>
            </tr>
        </thead>
        <tbody>
            [#list usersBuildStatistics as stats]
                <tr>
                    <td><a href="${req.contextPath}/${stats.nameDisplayUrl}">${stats.name?html}</a></td>
                    <td>${stats.numberOfTriggeredBuilds}</td>
                    <td>${stats.numberOfFailedBuilds}</td>
                    <td>${stats.percentageOfFailedBuilds?string.percent}</td>
                    <td>${stats.numberOfBrokenBuilds}</td>
                    <td>${stats.numberOfFixedBuilds}</td>
                    <td>${stats.score}</td>
                </tr>
            [/#list]
        </tbody>
    </table>

    <script type="text/javascript">
        AJS.$(function() {
            AJS.$("#userTable").tablesorter({
                sortList: [[0,0]],
                headers: {
                    1: { sorter: 'digit' },
                    2: { sorter: 'digit' },
                    3: { sorter: 'digit' },
                    4: { sorter: 'digit' },
                    5: { sorter: 'digit' },
                    6: { sorter: 'digit' },
               },
            });
        });
    </script>
[#else]
    [@ui.messageBox type="info" titleKey="author.statistics.aggregatedAuthors.noAuthors" /]
[/#if]

</body>
</html>