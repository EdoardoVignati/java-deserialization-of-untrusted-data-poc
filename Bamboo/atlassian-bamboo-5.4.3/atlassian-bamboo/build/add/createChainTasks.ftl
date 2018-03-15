<html>
<head>
    <meta name="decorator" content="createWizard"/>
    <meta name="tab" content="2"/>
    <title>[@ww.text name='plan.create.tasks.title' /] - [@ww.text name='plan.create.new.title' /]</title>
    ${webResourceManager.requireResourcesForContext("ace.editor")}
</head>
<body>

[#assign planCreateTasksDescription]
<p>[@ww.text name="plan.create.tasks.description" /]</p>
<p>[@ww.text name="job.create.tasks.description"]
        [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.builder"/][/@ww.param]
        [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.configuring"/][/@ww.param]
   [/@ww.text]</p>
[/#assign]

<div id="onePageCreate">
    [@ui.header pageKey="plan.create.tasks.title" description=planCreateTasksDescription headerElement="h2" /]
    [#include "/build/edit/editBuildTasksCommon.ftl"/]
    [@ww.form   action="finalisePlanCreation"
                namespace="/build/admin/create"
                submitLabelKey="global.buttons.create"
                cssClass="top-label"]
        [@ww.hidden name="planKey"/]
        [@ui.bambooSection titleKey="plan.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='chainEnabled' descriptionKey='plan.create.enable.description'/]
        [/@ui.bambooSection]
        [@ww.param name="buttons"]
            <a class="cancel mutative" href="[@ww.url namespace='/build/admin/create' action='cancelPlanCreation' planKey=planKey/]" accesskey="`">
                [@ww.text name="global.buttons.cancel"/]
            </a>
        [/@ww.param]
    [/@ww.form]
</div>
</body>
</html>