[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
<html>
<head>
	<title>[@ww.text name='build.move.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='build.move.title' /]</h1>
    [@ww.form action='chooseBuildsToMove' namespace='/admin'
              titleKey='build.move.form.confirm.title'
              submitLabelKey='global.buttons.done'
    ]
        <table class="aui">
            <thead>
                <tr>
                    <th>[@ww.text name='build.move.list' /]</th>
                </tr>
            </thead>
            <tbody>
                [#list selectedPlans as build]
                    <tr>
                        <td>
                            <a href="${req.contextPath}/browse/${build.key}">
                                ${build.name} <em>(${build.key})</em>
                            </a>
                        </td>
                    </tr>
                [/#list]
            </tbody>
        </table>
    [/@ww.form]
</body>
</html>