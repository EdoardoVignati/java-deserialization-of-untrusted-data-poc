[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#assign curTab = "myTab" /]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <meta name="decorator" content="atl.dashboard"/>
    <meta name="tab" content="${curTab?html}" />
</head>
<body>

[#include "./displayMyBuildSummaries.ftl"/]

[#if myFavouritesUrl?has_content]
    <script type="text/javascript">
        AJS.$(function() {
            AsynchronousRequestManager.init(".asynchronous", null, function () {
                reloadPanel("myFavourites", "${myFavouritesUrl}");
            });
        });
    </script>
[/#if]

<script type="text/javascript">
    AJS.$(document).delegate("#myFavourites .project > div", "click", function (e) {
        if (!e.target.href) {
            var $projectHeader = AJS.$(this).parent(),
                projectId = $projectHeader.data("projectId") || $projectHeader.data("project-id") || $projectHeader.attr("data-project-id");

            saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, ("favourites_" + projectId), ($projectHeader.hasClass("expanded") ? '0' : null));
            $projectHeader.toggleClass("expanded collapsed");
        }
    });
    BAMBOO.reloadDashboard = false;
    saveCookie("atlassian.bamboo.dashboard.tab.selected", "${curTab?js_string}");
</script>

</body>
</html>
