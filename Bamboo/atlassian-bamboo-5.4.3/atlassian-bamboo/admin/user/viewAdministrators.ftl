[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ViewAdministrators" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ViewAdministrators" --]
<html>
<head>
    <title>[@ww.text name='administrators.title' /]</title>
</head>
<body>
<h1>[@ww.text name='administrators.heading' /]</h1>
[#if administrators?exists]
    <p>[@ww.text name='administrators.description' /]</p>
    [#if administrators.size() == 0]
        [@ww.text name='administrators.none' /]
    [#else]
        <table class="aui">
            <thead>
                <tr>
                    <th [#if viewContactDetails]colspan="2"[/#if]>[@ww.text name='administrators.table.title' /]</th>
                </tr>
            </thead>
            <tbody>
                [#list administrators as admin]
                    <tr>
                        <td>[@ui.displayUserFullName user=admin /]</td>
                        [#if viewContactDetails]
                            <td>
                                <a href="mailto:${admin.email}">${admin.email}</a>
                            </td>
                        [/#if]
                    </tr>
                [/#list]
            </tbody>
        </table>
    [/#if]
[#else]
    <p>[@ww.text name='administrators.none' /]</p>
[/#if]
</body>
</html>