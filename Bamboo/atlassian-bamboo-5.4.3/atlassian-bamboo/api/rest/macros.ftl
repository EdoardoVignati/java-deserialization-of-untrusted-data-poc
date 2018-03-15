[#-- ============================================================================================== @api.buildResult --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
[#macro buildResult buildSummary planManager]
    [#assign buildObject=planManager.getPlanByKey(buildSummary.getPlanKey()) /]
    <projectName>${buildObject.getProject().getName()}</projectName>
    <buildName>${buildObject.getBuildName()}</buildName>
    <buildKey>${buildSummary.planKey!}</buildKey>
    <buildState>${buildSummary.buildState!}</buildState>
    <buildNumber>${buildSummary.buildNumber!}</buildNumber>
    <failedTestCount>${(buildSummary.testResultsSummary.failedTestCaseCount)!}</failedTestCount>
    <successfulTestCount>${(buildSummary.testResultsSummary.successfulTestCaseCount)!}</successfulTestCount>
    <buildTime>${buildSummary.buildTime!}</buildTime>
    <buildCompletedDate>${buildSummary.buildCompletedDate!?string("yyyy-MM-dd'T'HH:mm:ssZ")}</buildCompletedDate>
    <buildDurationInSeconds>${buildSummary.durationInSeconds!?xml}</buildDurationInSeconds>
    <buildDurationDescription>${buildSummary.durationDescription!?xml}</buildDurationDescription>
    <buildRelativeBuildDate>${buildSummary.relativeBuildDate!?xml}</buildRelativeBuildDate>
    <buildTestSummary>${buildSummary.testSummary!}</buildTestSummary>
    <buildReason>${buildSummary.triggerReason!}</buildReason>

    [#if buildSummary.commits??]
    <commits>
		[#list buildSummary.commits as commit]
		    [#if commit.author??]
                <commit author="${commit.author.name?xml}" />
            [/#if]
		[/#list]
    </commits>
	[/#if]

[/#macro]

[#macro testResult testResult indentation]<testResult testClass="${testResult.className?xml}" testMethod="${testResult.actualMethodName?xml}" duration="${testResult.durationInSeconds?xml}">
[#if !testResult.errors.empty]
${indentation}    <errors>
[#list testResult.errors as error]
${indentation}        <error>${error.rawErrorMessage?xml}</error>
[/#list]
${indentation}    </errors>
[/#if]
[#if testResult.systemOut??]
${indentation}    <output>${testResult.systemOut?xml}</output>
[/#if]
${indentation}</testResult>[/#macro]