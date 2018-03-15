[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]

<html>
<head>
    <meta name="decorator" content="deploymentVersionDecorator"/>
    <meta name="tab" content="status"/>
    [@ww.text id='headerText' name='deployment.version.header'][@ww.param]${deploymentVersion.name?html}[/@ww.param][/@ww.text]
    [@ui.header title=true object=deploymentProject.name pageKey=headerText /]
</head>
<body>
    [#assign commentList = [] /]
    [#list comments as comment]
        [#--[#assign renderedComment][@ui.renderValidJiraIssues comment.content result /][/#assign]--]
        [#assign userDisplayName][#if comment.user??][@ui.displayUserFullName user=comment.user /][/#if][/#assign]
        [#assign commentString][@ui.renderValidJiraIssuesForDeploymentVersion comment.content deploymentVersion/][/#assign]
        [#assign commentList = commentList + [{
            "id": comment.id,
            "comment": commentString,
            "lastModificationDate": comment.lastModificationDate?string("yyyy-MM-dd'T'HH:mm:ss"),
            "prettyLastModificationDate": durationUtils.getRelativeDate(comment.lastModificationDate),
            "avatar": ctx.getGravatarUrl((comment.user.name)!'', "32")!'',
            "user": comment.user!false,
            "userDisplayName": userDisplayName
        }] /]
    [/#list]


    [#if user??]
        [#assign avatar]${ctx.getGravatarUrl((user.name)!'', "32")!''}[/#assign]
    [/#if]
    [#if action.hasEntityPermission("WRITE", deploymentProject)]
        [#assign showCommentsOperations]true[/#assign]
    [/#if]
    [#if action.hasEntityPermission("READ", deploymentProject) && user??]
        [#assign showAddCommentForm]true[/#assign]
    [/#if]
    ${soy.render("bamboo.deployments:view-deployment-version", "bamboo.page.deployment.version.viewDeploymentVersion", {
        "deploymentVersion": deploymentVersion,
        "deploymentProject": deploymentProject,
        "deploymentEnvironmentStatuses": versionDeploymentStatuses,
        "deploymentVersionItemsWithUrls": deploymentVersionItemsWithUrls,
        "createdFromResults" : createdFromResults,
        "commitsTestedInResults": commitsTestedInResults,
        "currentUrl" : currentUrl,
        "comments": commentList,
        "showCommentsOperations": showCommentsOperations!false,
        "showAddCommentForm": showAddCommentForm!false,
        "avatar": avatar!false
    })}
</body>
</html>
