[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]
<p>${triggerReason}</p>
[#if resultsSummary.commits?has_content]
    <p>
        ${resultsSummary.planResultKey} has the following ${resultsSummary.commits?size} changes:
    </p>

    [#list resultsSummary.commits as change]
        <p>
            ${change.author.fullName} made the following changes at ${change.date}<br>
            with the comment: ${htmlUtils.getAsPreformattedText(change.comment)}
        </p>

        <ul>
        [#list change.files as file]
            <li>${file.name}</li>
        [/#list]
        </ul>
    [/#list]
[/#if]

<p>
    The build has ${resultsSummary.testResultsSummary.failedTestCaseCount} failed tests and ${resultsSummary.testResultsSummary.successfulTestCaseCount} successful tests.
</p>