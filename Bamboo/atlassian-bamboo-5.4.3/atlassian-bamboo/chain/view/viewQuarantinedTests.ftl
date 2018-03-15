[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewQuarantinedTests" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewQuarantinedTests" --]

[#import "/lib/tests.ftl" as tests]

<html>
<head>
    [@ui.header pageKey='chain.quarantine.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="quarantine"/>
</head>
<body>
    <div class="aui-group">
        <div class="aui-item">
            [@ui.header pageKey='chain.quarantine.title.long' descriptionKey='chain.quarantine.test.description.long'/]
        </div>
        <div class="aui-item">
            [@ui.messageBox id="quarantine-test-hint" type="hint" titleKey="chain.quarantine.test.status"]
                <ol class="quarantine-test-history">
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="failed" title="Failed"><a>Failed</a></li>
                    <li class="failed" title="Failed"><a>Failed</a></li>
                    <li class="skipped" title="Skipped"><a>Skipped</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                    <li class="successful" title="Successful"><a>Successful</a></li>
                </ol>
                <p>[@ww.text name='chain.quarantine.test.hint'/]</p>
            [/@ui.messageBox]
        </div>
    </div>
        [#assign testsList = quarantinedTestCases /]
        [#if testsList?has_content]
            <table class="aui tests-table" id="quarantined-tests">
                <thead>
                    <tr>
                        <th class="test">[@ww.text name="build.testSummary.test" /]</th>
                        <th class="job">[@ww.text name="job.common.title" /]</th>
                        <th><span>[@ww.text name="chain.quarantine.test.status" /]</span></th>
                        <th>[@ww.text name="chain.quarantine.test.user" /]</th>
                        <th>[@ww.text name="chain.quarantine.test.date" /]</th>
                        <th class="actions"></th>
                    </tr>
                </thead>
                <tbody>
                    [#list testsList as testCase]
                    [#assign testClass = testCase.testClass/]
                    [#assign testPlan = testClass.plan /]
                    <tr>
                        <td class="test">
                            <span class="test-class">${testClass.shortName?html}</span>
                            <a href="[@ww.url value=fn.getTestCaseResultUrl(testPlan.key, testCase.lastRanBuildNumber, testCase.id) /]"
                               class="test-name">${testCase.name?html}</a>
                            <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(testPlan.key, testCase.id) /]">[@ui.icon type="time" useIconFont=true textKey="buildResult.tests.history" /]</a>
                        </td>
                        <td class="job">
                            <a href="${req.contextPath}/browse/${testPlan.planKey}/"[#if testPlan.description?has_content]
                               title="${testPlan.description}"[/#if]>${testPlan.buildName}</a>
                        </td>
                        <td>
                            [#assign testCaseHistory = action.getTestCaseHistory(testCase)/]
                            <ol class="quarantine-test-history" style="margin-left: ${((10-testCaseHistory?size)* 12)}px;">
                                [#list testCaseHistory as pastResult]
                                    [@ww.url value="/browse/${pastResult.testClassResult.buildResultsSummary.planResultKey}/test/case/${pastResult.testCase.id}" id="testResultUrl"/]
                                    <li class="${pastResult.state.displayName?lower_case}" title="${pastResult.state.displayName}"><a href=${testResultUrl}>${pastResult.state.displayName}</a></li>
                                [/#list]
                            </ol>
                        </td>
                        <td>
                            [#assign quarantineUser=action.getQuarantiningUser(testCase) /]
                            [#if quarantineUser??]
                                <a href="${req.contextPath}/browse/user/${quarantineUser.name?url}">[@ui.displayUserFullName user=quarantineUser/]</a>
                            [#else]
                                [@ww.text name="chain.quarantine.test.noUser" /]
                            [/#if]
                        </td>
                        <td>[@ui.time datetime=testCase.quarantineStatistics.quarantineDate]${testCase.quarantineStatistics.quarantineDate?datetime?string}[/@ui.time]</td>
                        <td class="actions">
                            [@ww.url id="toggleURL" action="unleashTest" namespace="/build/admin" testId="${testCase.id}" returnUrl=currentUrl /]
                            [#if testCase.quarantined]
                                [#assign quarantineLabel = "builder.common.tests.unquarantine" /]
                            [#else]
                                [#assign quarantineLabel = "builder.common.tests.quarantine" /]
                            [/#if]
                            [#if action.getUser()?? && fn.hasPlanPermission("ADMINISTRATION", immutablePlan)]
                                [@cp.displayLinkButton buttonId="toggleTestIgnore-${testCase.name?html}-${testClass.name?html}" buttonLabel=quarantineLabel buttonUrl=toggleURL cssClass="quarantine-action" mutative=true/]
                            [/#if]
                        </td>
                    </tr>
                    [/#list]
                </tbody>
            </table>
        [#else]
            <p>
                [@ww.text name='chain.quarantine.test.none'/]
            </p>
        [/#if]
</body>
</html>
