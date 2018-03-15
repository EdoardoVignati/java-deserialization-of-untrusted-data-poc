[@ww.form   action="saveFilter"
            submitLabelKey="global.buttons.saveAndApply"
            cancelUri='/start.action' ]

    [@ww.text name="dashboard.filter.description"/]

    [@ui.bambooSection titleKey="dashboard.filter.projects" ]
        [@ww.textfield name="addProjectTextField" labelKey='dashboard.filter.project' id="addProjectTextField" /]
        [@ui.displayFieldGroup]
            ${soy.render("bamboo.widget.autocomplete.projectFilter.list", {
                "projects": existingProjectsJson.toString()?eval,
                "extraClasses": "selected-projects bamboo-selected-set-list"
            })}
        [/@ui.displayFieldGroup]
    [/@ui.bambooSection]
    [@ui.bambooSection titleKey="dashboard.filter.labels"]
        [#if allPlanLabels?has_content]
            [@ww.checkboxlist name='selectedLabelNames' listKey="name" listValue="name" labelKey="dashboard.filter.label.dialog.checkbox" list=allPlanLabels /]
        [#else]
            <p>[@ww.text name="dashboard.filter.label.dialog.description.nolabels" /]</p>
        [/#if]
        <p class="labelPickerHint">[@ww.text name="dashboard.filter.hint"/]</p>
    [/@ui.bambooSection]
    <script>
        (function ($) {
            new BAMBOO.FilterProjectSelect({
               el:$('#addProjectTextField'),
               selectedPlansEl:$('.selected-projects'),
               bootstrap: ${existingProjectsJson.toString()}
           });
        }(jQuery));
    </script>

[/@ww.form]
