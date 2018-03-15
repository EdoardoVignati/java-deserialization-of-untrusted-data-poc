<div class="latest-changes">
[#--left Column--]
[#if authors?has_content]
    <h2>Latest Changes</h2>
[@ww.action name='myChanges' namespace='/ajax' executeResult='true' /]
    [#else]
    [@ui.messageBox]
        No changes found. You may need to
        <a href="${req.contextPath}/profile/editProfile.action" title="Edit your profile">associate yourself</a> with a source repository alias.
    [/@ui.messageBox]
[/#if]
</div>
