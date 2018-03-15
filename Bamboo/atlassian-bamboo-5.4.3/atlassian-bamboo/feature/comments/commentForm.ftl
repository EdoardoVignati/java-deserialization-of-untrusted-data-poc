[@ww.form
    action='createComment'
    namespace='/build/ajax'
    id='result_summary_comment'
    submitLabelKey='global.buttons.add'
    cancelUri=currentUrl
    cssClass=(showFormOnLoad!true)?string('', 'collapsed')
]
    [@ww.hidden name='buildKey' value=buildKey /]
    [@ww.hidden name='buildNumber' value=buildNumber /]
    [@ww.hidden name='returnUrl' value=returnUrl /]
    [@ui.displayUserGravatar userName=user.name size='32' class="avatar" alt="${user.fullName?html}"/]
    [@ww.textarea labelKey='buildResult.changes.comment' name='commentContent' rows='5' autofocus=(showFormOnLoad!false) placeholderKey='buildResult.changes.comment.placeholder' fullWidthField=true /]
[/@ww.form]