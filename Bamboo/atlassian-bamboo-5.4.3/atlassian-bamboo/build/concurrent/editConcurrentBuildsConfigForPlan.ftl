[#if action.concurrentBuildsEnabled]
[@ui.bambooSection titleKey="build.concurrent.title"]
    [@ww.checkbox labelKey='build.concurrent.overrideDefault'
                  name='custom.concurrentBuilds.overrideNumberOfConcurrentBuilds'
                  toggle='true' /]

    [@ui.bambooSection dependsOn='custom.concurrentBuilds.overrideNumberOfConcurrentBuilds' showOn='true']
        [@ww.textfield labelKey='build.concurrent.maxnumber'
                       name='custom.concurrentBuilds.numberOfConcurrentBuilds'
                        /]
    [/@ui.bambooSection]
[/@ui.bambooSection]
[/#if]