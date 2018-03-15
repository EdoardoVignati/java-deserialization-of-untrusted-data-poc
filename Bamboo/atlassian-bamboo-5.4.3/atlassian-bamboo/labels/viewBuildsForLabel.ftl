[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.ViewBuildResultsForLabelAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.ViewBuildResultsForLabelAction" --]
<html>
<head>
    [@ui.header pageKey='Label' object=labelName title=true /]
</head>

<body>

<header class="aui-page-header">
    <div class="aui-page-header-inner">
        <div class="aui-page-header-main">
        [#assign parentCrumbs = [{
            "text": "All Labels",
            "link": "${req.contextPath}/browse/label"
        }] /]
        ${soy.render("bamboo.widget.nav.breadcrumb.crumbContainer", {
            "parentCrumbs": parentCrumbs
        })}
        [@ui.header page='Label' object=labelName /]
        </div><!-- .aui-page-header-main -->
    </div><!-- .aui-page-header-inner -->
</header>
<p>Below are the ${resultsList.size()} build results with label <strong>${labelName?html}</strong>.</p>

[@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true" /]

[@ww.url id='rssFeedUrl' action='createLabelRssFeed' namespace='/rss' labelName=labelName /]
<p>
    <a href="${rssFeedUrl}">[@ui.icon type="rss" /] Feed for builds labelled ${labelName?html}</a>
</p>
</body>
</html>