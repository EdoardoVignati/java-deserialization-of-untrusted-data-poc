[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
<title>Add a new Stage</title>
[@ww.form action="saveStage" namespace="/chain/admin/ajax"
        submitLabelKey="global.buttons.update"]
    [@ww.hidden name="returnUrl" /]
    [@ww.textfield labelKey='stage.name' name='stageName' required='true' /]
    [@ww.textfield labelKey='stageDescription' name='stageDescription' required='false' /]
    [@ww.checkbox labelKey='stage.manual' name='stageManual' /]
    [@ww.hidden name="buildKey"/]
    [@ww.hidden name="stageId"/]
[/@ww.form]