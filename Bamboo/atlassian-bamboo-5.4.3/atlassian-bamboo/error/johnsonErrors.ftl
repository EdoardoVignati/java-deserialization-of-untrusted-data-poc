[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.error.ErrorAction" --]
<title>[@ww.text name='error.title' /]</title>
<meta name="decorator" content="install" />

[#if events?size==0]
    [@ww.text name='error.events.none' ]
        [@ww.param]<a href="${req.contextPath}/">[/@ww.param]
        [@ww.param]</a>[/@ww.param]
    [/@ww.text]
[#else]
    <p>[@ww.text name='error.events.present' /]</p>

    <table class="aui grid">
        <thead>
            <tr>
                <th>Time</th>
                <th>Level</th>
                <th>Type</th>
                <th>Description</th>
                <th>Exception</th>
            </tr>
        </thead>
        [#list events as event]

        <tr>
            <td nowrap>${event.date}</td>
            <td nowrap>${event.level.level}</td>
            <td nowrap>${event.key.type}</td>
            <td>
                ${htmlUtils.getTextAsHtml(event.desc)}
            [#if event.key.type == 'license-too-old']
                Please <a style="font-weight: bold;" href="${req.contextPath}/setup/updateLicense!default.action">update your license</a>  and then restart Bamboo.
            [/#if]</td>
            <td>
[#if event.getException()?exists]
${event.exception}
[#else]
    N/A
[/#if]
            </td>
        </tr>
        [/#list]
    </table>
    <br>
<p>Please contact us at <a href="https://support.atlassian.com/">https://support.atlassian.com/</a> if you have any queries.</p>
[/#if]
