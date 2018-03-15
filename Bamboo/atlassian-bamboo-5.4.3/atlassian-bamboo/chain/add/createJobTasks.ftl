<html>
<head>
    <title>[@ww.text name='plan.create' /]</title>
    <meta name="decorator" content="createWizard"/>
    <meta name="tab" content="2"/>
    <meta name="prefix" content="job"/>
</head>
<body>

[@ww.text id="jobCreateTasksDescription" name="job.create.tasks.description"]
    [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.builder"/][/@ww.param]
    [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.configuring"/][/@ww.param]
[/@ww.text]

<div id="onePageCreate">
    [@ui.header pageKey="plan.create.tasks.title" description=jobCreateTasksDescription headerElement="h2" /]
    [#include "/build/edit/editBuildTasksCommon.ftl"/]

    [@ww.form   action="finaliseJobCreation"
                namespace="/chain/admin"
                submitLabelKey="global.buttons.create"
                cssClass="top-label"]
        [@ww.hidden name="planKey"/]
        [@ui.bambooSection titleKey="job.create.enable.title"]
            [@ww.checkbox labelKey="job.create.enable.option" name='jobEnabled' descriptionKey='job.create.enable.description'/]
        [/@ui.bambooSection]
        [@ww.param name="buttons"]
            <a class="cancel mutative" href="[@ww.url namespace='/chain/admin' action='cancelJobCreation' planKey=planKey/]" accesskey="`">
                [@ww.text name="global.buttons.cancel"/]
            </a>
        [/@ww.param]
    [/@ww.form]
</div>
</body>
</html>