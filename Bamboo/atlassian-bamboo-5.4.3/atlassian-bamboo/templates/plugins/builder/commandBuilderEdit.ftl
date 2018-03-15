[@ww.textfield labelKey='builder.command.argument' name='builder.${command.key}.argument' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.env' name='builder.${command.key}.environmentVariables' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.sub' name='builder.${command.key}.workingSubDirectory' cssClass="long-field" /]

[@ui.bambooSection titleKey='builder.common.tests.directory.description']
    [@ww.checkbox labelKey='builder.common.tests.exists' name='builder.${command.key}.testChecked' toggle='true'/]

    [@ui.bambooSection dependsOn='builder.${command.key}.testChecked' showOn='true']
        [@ww.textfield labelKey='builder.common.tests.directory.custom' name='builder.${command.key}.testResultsDirectory' cssClass="long-field" /]
    [/@ui.bambooSection]
[/@ui.bambooSection]