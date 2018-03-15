[#--
pstefaniak, 15-05-2013: this is stupid that I have to duplicate code for that form here (for errors) and in the
                        view-deployment-version.soy. I wish I could reuse soy template in xwork.xml "redirect" result,
                        or call this .ftl form directly from view-deployment-version.soy :/
--]
[@ww.form
    action='createComment'
    namespace='/deploy'
    id='result_summary_comment'
    submitLabelKey='global.buttons.add'
    cancelUri='/deploy/viewDeploymentVersion.action?versionId=${deploymentVersion.id}'
    cssClass=(showFormOnLoad!true)?string('', 'collapsed')
]
    [@ww.hidden name='versionId' value=deploymentVersion.id /]
    [@ww.hidden name='returnUrl' value=returnUrl /]
    [@ui.displayUserGravatar userName=user.name size='32' class="avatar" alt="${user.fullName?html}"/]
    [@ww.textarea labelKey='buildResult.changes.comment' name='commentContent' rows='5' autofocus=(showFormOnLoad!false) placeholderKey='buildResult.changes.comment.placeholder' fullWidthField=true /]
[/@ww.form]