[@ww.textfield labelKey='builder.ant.buildFile' name='builder.${ant.key}.buildFile' required='true' cssClass="long-field" /]
[@ww.textfield labelKey='builder.ant.target' name='builder.${ant.key}.target' required='true' cssClass="long-field" /]

[#assign addJdkLink][@ui.displayAddJdkInline /][/#assign]
[@ww.select labelKey='builder.common.jdk' name='builder.${ant.key}.buildJdk'
            cssClass='jdkSelectWidget'
            list=availableJdks required='true'
            extraUtility=addJdkLink]
[/@ww.select]

[@ww.textfield labelKey='builder.common.env' name='builder.${ant.key}.environmentVariables' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.sub' name='builder.${ant.key}.workingSubDirectory' cssClass="long-field" /]

[@ui.bambooSection titleKey='builder.common.tests.directory.description']
    [@ww.checkbox labelKey='builder.common.tests.exists' name='builder.${ant.key}.testChecked' toggle='true'/]

    [@ui.bambooSection dependsOn='builder.${ant.key}.testChecked' showOn='true']
        [@ww.textfield labelKey='builder.common.tests.directory.custom' name='builder.${ant.key}.testResultsDirectory' cssClass="long-field" /]
    [/@ui.bambooSection]
[/@ui.bambooSection]

