[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.repository.ConfigurePerforceManager" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.repository.ConfigurePerforceManager" --]
<html>
<head>
    <title>[@ww.text name='admin.repository.p4.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
<h1>[@ww.text name='admin.repository.p4.title' /]</h1>

<p>[@ww.text name='admin.repository.p4.description' /]</p>

<table class="aui">
    <thead>
    <tr>
        <th>[@ww.text name='admin.repository.p4.details.title' /]</th>
        <th>[@ww.text name='admin.repository.p4.depot.title' /]</th>
    </tr>
    </thead>
    <tbody>
    [#assign depotViews = depotViewMapping.entrySet() /]
    [#if depotViews?has_content]
        [#list depotViews as entries]
        <tr>
            <td>${entries.key}</td>
            <td>${entries.value}</td>
        </tr>
        [/#list]
    [#else]
    <tr>
        <td colspan="2">
            [@ww.text name='admin.repository.p4.none' /]
        </td>
    </tr>
    [/#if]
    </tbody>
</table>
<p>
    <a href="[@ww.url action='clearPerforceManagerCache' namespace='/admin/agent' /]" class="aui-button">[@ww.text name='admin.repository.p4.clearCache' /]</a>
</p>
</body>
</html>