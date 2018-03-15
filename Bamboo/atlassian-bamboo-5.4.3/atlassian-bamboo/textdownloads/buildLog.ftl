[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#if buildResults.buildLog?has_content]
Build ${buildResults.buildNumber} generated the following output:

[#list buildResults.buildLog as line]
${line.formattedDate} ${line.unstyledLog} 
[/#list]
[#else]
No logs were found for this build.
[/#if]