[#-- Copied and converted from the the Streams plugin --]

[#assign feedId = "recentlyBuilt" /]
[#assign resourceKey = "com.atlassian.streams.bamboo" /]
[#assign maxResults = "10" /]
[#assign feedUrl = "${req.contextPath}/plugins/servlet/streams?local=true" /]

[#assign baseurl = req.contextPath /]

[#assign feediconTitle = i18n.getText("portlet.activityfeed.feedicon.title")]
[#assign configIconTitle = i18n.getText("activityfeed.configicon.title")]
<div id="${feedId}" class="activityFeed">
    <div class="header">
        <a id="feedLink-${feedId}" href="${feedUrl?if_exists}" class="feedLink" title="${feediconTitle}">${feediconTitle}</a>
    </div>
    [#if feedError??]
        <div id="feedError-${feedId}" class="error">
            <div class="inner">${feedError?if_exists}</div>
        </div>
    [/#if]
    [#if feedWarning??]
        <div id="feedWarning-${feedId}" class="warning">
            <div class="inner">${feedWarning?if_exists}</div>
        </div>
    [/#if]
    <div id="feedContainer-${feedId}" class="feedContainer">
        <p id="feedLoading-${feedId}" class="loading">${i18n.getText("portlet.loadingFeed")}</p>
    </div>
    <a href="#" id="showMoreLink-${feedId}" class="switch" style="display:none;"><span>${i18n.getText("activityfeed.show.more")}</span></a>
    <span id="moreWaiting-${feedId}"><span>${i18n.getText("portlet.loadingFeed")}</span></span>
</div>
<script type="text/javascript">
    //<![CDATA[
    var activityFeed_${feedId};
    AJS.$(function () {
        AJS.$("#showMoreLink-${feedId}").click(function(e){ e.preventDefault(); });
        activityFeed_${feedId} = new ActivityFeed("${feedId}", "${baseurl}", "${baseurl}/download/resources/${resourceKey}", "${feedUrl?if_exists}", "${maxResults?if_exists}");
        activityFeed_${feedId}.populateFeed();
    });
    //]]>
</script>
