[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.PlanResultsAction" --]

[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
	[@ui.header pageKey='buildResult.summary.title' object='${immutablePlan.name} ${resultsSummary.buildNumber}' title=true /]
    <meta name="tab" content="metadata"/>

</head>
<body>
    [@ui.header pageKey='buildResult.metadata.title' /]

    [#if resultsSummary.customBuildData?has_content && resultsSummary.finished]

        <p>[@ww.text name='buildResult.metadata.description' /]</p>

        <table class="aui" id="buildMetadata">
            <thead>
            <tr>
                <th>[@ww.text name='buildResult.metadata.key' /]</th>
                <th>[@ww.text name='buildResult.metadata.value' /]</th>
            </tr>
            </thead>
            [#list maskedMetadata.entrySet().toArray()?sort as entry]
                <tr>
                    <td>${entry.key?html}</td>
                    <td>${entry.value?html}</td>
                </tr>
            [/#list]
        </table>
    [#else]
        <p>[@ww.text name='buildResult.metadata.none' /]</p>
    [/#if]

    <h2>[@ww.text name='buildResult.variables.title' /]</h2>
    [#assign hasJob = (immutablePlan.type == "JOB")/]

    [#if maskedVariables?has_content]
        [#if hasJob]
            <p>[@ww.text name='buildResult.variables.uses' /]</p>
        [#else]
            <p>[@ww.text name='buildResult.variables.manual' /]</p>
        [/#if]
        [@variables.displaySubstitutedVariables id="buildVariables" variablesList=maskedVariables /]
    [#else]
        [#if hasJob]
            <p>[@ww.text name='buildResult.variables.noneUsed' /]</p>
        [#else]
            <p>[@ww.text name='buildResult.variables.noManual' /]</p>
        [/#if]
    [/#if]
</body>
</html>
