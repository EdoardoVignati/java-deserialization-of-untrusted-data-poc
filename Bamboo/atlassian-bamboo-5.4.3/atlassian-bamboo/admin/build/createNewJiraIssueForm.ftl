[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.jira.AbstractCreateNewJiraIssueAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.jira.AbstractCreateNewJiraIssueAction" --]

[#macro createNewJiraIssueForm action]
    [@ww.form action="${action}"
            namespace="/ajax"
            cssClass="bambooAuiDialogForm createIssueForm"
            submitLabelKey="global.buttons.create"]

        [@ww.hidden name='planResultKey' /]
        [@ww.hidden name='returnUrl' /]

        [#nested /]

        <div id="cannot-create-message-container" class="hidden"></div>

            [#if jiraServers.size() < 1]
            <p>[@ww.text name="buildResult.create.issue.error.noAppLinks" /]</p>
            <p>[#if fn.hasAdminPermission()]
                <a href="[@ww.url value='/plugins/servlet/applinks/listApplicationLinks'/]">[@ww.text name="buildResult.create.issue.noAppLinks.connect"/]</a>
            [#else]
                [@ww.text name="buildResult.create.issue.noApplinks.notAdmin"/]
            [/#if]</p>
            [#else]
                [@ww.select id="jiraServer" labelKey='jira.server' name='appLinkId' list=jiraServers listKey='id' listValue='name' toggle=true cssClass='long-field' /]
            <div id="issue-loading-spinner" >[@ui.icon type="loading" /]</div>
            <div id="login-dance-message-container" class="hidden"></div>
            <div id="issue-contents-container" class="hidden">
                [@ww.select id="jiraProjectKey" labelKey='jira.project' name='project' list=jiraProjects listKey='id' listValue='name' toggle=true /]
                [@ww.select id="jiraIssueType" labelKey='jira.issue.type' name='issuetype' list=jiraIssueTypes listKey='id' listValue='name' toggle=true /]
                <div id="fields-loading-spinner"  class="hidden">[@ui.icon type="loading" /]</div>
                <div id="issue-fields-container" class="hidden">
                    [@ww.textfield id="jiraIssueSummary" labelKey='jira.summary' name='summary' required="true"/]
                    [@ww.select id="jiraProjectComponents" labelKey='jira.components' name='components' multiple=true/]
                    [@ww.select id="jiraProjectVersions" labelKey='jira.versions' name='versions' multiple=true/]
                    [@ww.textarea id="issueDescription" labelKey='jira.description' name='description' rows=5 /]
                </div>
            </div>
            [/#if]
        [/@ww.form]

    <script type="text/x-template" title="authenticationRequired-template">
        [@cp.oauthAuthenticationRequest "{authenticationUrl}"/]
    </script>

    <script type="text/x-template" title="cannotCreate-template">
        [@ui.messageBox type="info"]
            <p>[@ww.text name="jira.create.required.fields"]
                [@ww.param]{issueTypeName}[/@ww.param]
                [@ww.param]{fieldNames}[/@ww.param]
            [/@ww.text]
            </p>
            [@help.staticUrl "jira.createissue.troubleshooting"][@ww.text name="jira.create.troubleshooting"/][/@help.staticUrl]
        [/@ui.messageBox]
    </script>

    <script type="text/x-template" title="shortcutHint-template">
        <div class="dialog-tip">[@ww.text name="jira.shortcut.hint"/]</div>
    </script>
    <script type="text/x-template" title="genericErrorHelp-template">
        [@help.staticUrl "jira.createissue.troubleshooting"][@ww.text name="jira.create.troubleshooting"/][/@help.staticUrl]
    </script>

    <script type="text/javascript">
        BAMBOO.JIRAISSUECREATION.init({
            planResultKey: "${planResultKey}",
            applinkId: "${appLinkId!}",
            projectId: "${project!}",
            returnUrl: "${returnUrl!}",
            issueTypeId: "${issuetype!}",
            noProjectsMessage: "[@ww.text name='jira.create.noProjects'/]",
            templates: {
                authenticationRequiredTemplate: "authenticationRequired-template",
                cannotCreateTemplate: "cannotCreate-template",
                shortcutHint:  "shortcutHint-template",
                genericErrorHelpLink: "genericErrorHelp-template"
            }
        });
    </script>

[/#macro]

