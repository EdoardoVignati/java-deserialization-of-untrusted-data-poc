
[@ww.textarea labelKey='builder.maven.goal' name='builder.${maven.key}.goal' rows='4' required='true' cssClass="long-field" /]

[@ww.checkbox labelKey='builder.maven.return' name='useMavenReturnCode' /]

[#assign addJdkLink][@ui.displayAddJdkInline /][/#assign]
[@ww.select labelKey='builder.common.jdk' name='builder.${maven.key}.buildJdk'
            cssClass='jdkSelectWidget'
            list=availableJdks required='true'
            extraUtility=addJdkLink]
[/@ww.select]


[#if maven.key == "mvn2" || maven.key == "mvn3" ]
[@ww.textfield labelKey='builder.maven2.projectFile' name='builder.${maven.key}.projectFile' cssClass="long-field" /]
[/#if]
[@ww.textfield labelKey='builder.common.env' name='builder.${maven.key}.environmentVariables' cssClass="long-field" /]
[@ww.textfield labelKey='builder.common.sub' name='builder.${maven.key}.workingSubDirectory' cssClass="long-field" /]

[@ui.bambooSection titleKey='builder.common.tests.directory.description']
    [@ww.checkbox labelKey='builder.common.tests.exists' name='builder.${maven.key}.testChecked' toggle='true'/]

    [@ui.bambooSection dependsOn='builder.${maven.key}.testChecked' showOn='true']
        [@ww.radio labelKey='builder.common.tests.directory' name='builder.${maven.key}.testDirectoryOption'
                   listKey='key' listValue='value' toggle='true'
                   list=testDirectoryTypes ]
        [/@ww.radio]
        [@ui.bambooSection dependsOn='builder.${maven.key}.testDirectoryOption' showOn='customTestDirectory']
            [@ww.textfield labelKey='builder.common.tests.directory.custom' name='builder.${maven.key}.testResultsDirectory' cssClass="long-field" /]
        [/@ui.bambooSection]
    [/@ui.bambooSection]
[/@ui.bambooSection]
