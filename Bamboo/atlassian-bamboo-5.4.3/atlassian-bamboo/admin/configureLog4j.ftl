[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureLog4jAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureLog4jAction" --]

[@ui.header pageKey='logSettings.heading' descriptionKey='logSettigns.description' /]

[@ww.form id='addLog4jEntry' action='addLog4jEntry' namespace='/admin' submitLabelKey='global.buttons.add' titleKey='logSettings.add' descriptionKey='logSettings.add.description']
    [@ww.textfield id='newEntry' size="50" name='extraClassName' labelKey='logSettings.add.classname' longField=true/]
    [@ww.select label='Type' name='extraLevelName' list=levelTypes optionTitle='pathHelp' descriptionKey='builders.form.type.description' /]
[/@ww.form]

[@ui.bambooPanel titleKey='logSettings.edit' descriptionKey='logSettings.edit.description' ]
<table class="aui">
    <thead>
    <tr>
        <th>Package</th>
        <th>Current Level</th>
        <th>New Level</th>
    </tr>
    </thead>
    [#list entries as entry]
        <tr>
            <td>${entry.clazz?html}</td>
            <td>${entry.level}</td>
            <td>
            [@ww.form id='configureLog4jForm' action='saveLog4jClass' theme="simple" namespace="/admin" cssClass='aui' ]
                [@ww.select label='Level' name='levelName' list=levelTypes cssClass='select short-field' /]
                [@ww.hidden name="className" value=entry.clazz /]
                [@compress single_line=true]
                [@ww.submit type="submit" value=action.getText('global.buttons.update') cssClass='button' /]
                    <a id="deleteLogClass:${entry.clazz?html}" href="${req.contextPath}/admin/deleteLog4jClass.action?toDeleteName=${entry.clazz?html}">[@ww.text name='global.buttons.delete'/]</a>
                [/@compress]
            [/@ww.form]
            </td>
        </tr>
    [/#list]
</table>
[/@ui.bambooPanel]

