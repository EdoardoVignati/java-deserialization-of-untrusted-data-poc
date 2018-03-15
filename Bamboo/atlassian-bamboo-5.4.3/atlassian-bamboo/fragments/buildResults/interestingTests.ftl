[#import "/lib/tests.ftl" as tests]
[#assign testSummary = chainResult.testResultsSummary /]
[#assign testResults = filteredTestResults /]
[#assign hasNewFailingTests = testSummary.newFailedTestCaseCount gt 0 /]
[#assign hasExistingFailedTests = testSummary.existingFailedTestCount gt 0 /]
[#assign hasFixedTests = testSummary.fixedTestCaseCount gt 0 /]
[#assign hasQuarantinedTests = testSummary.quarantinedTestCaseCount gt 0 /]

[#if chainResult.finished && testResults?? && (hasNewFailingTests || hasExistingFailedTests || hasFixedTests)]
    <div class="tests">
        <h2>[@ww.text name='buildResult.testClass.tests'/]</h2>
        [@tests.displayTestSummary testResults=testResults testSummary=testSummary displayQuarantined=false showJob=true /]
    </div>
[/#if]