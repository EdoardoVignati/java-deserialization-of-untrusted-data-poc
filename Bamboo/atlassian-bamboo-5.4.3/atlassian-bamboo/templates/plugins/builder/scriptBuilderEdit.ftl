[@ww.textfield labelKey='builder.script.script' name='builder.${script.key}.script' required='true' cssClass="long-field" /]
[@ww.textfield labelKey='builder.command.argument' name='builder.${script.key}.argument' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.env' name='builder.${script.key}.environmentVariables' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.sub' name='builder.${script.key}.workingSubDirectory' cssClass="long-field" /]

[@ui.bambooSection titleKey='builder.common.tests.directory.description']
    [@ww.checkbox labelKey='builder.common.tests.exists' name='builder.${script.key}.testChecked' toggle='true'/]

    [@ui.bambooSection dependsOn='builder.${script.key}.testChecked' showOn='true']
        [@ww.textfield labelKey='builder.common.tests.directory.custom' name='builder.${script.key}.testResultsDirectory' cssClass="long-field" /]
    [/@ui.bambooSection]
[/@ui.bambooSection]
