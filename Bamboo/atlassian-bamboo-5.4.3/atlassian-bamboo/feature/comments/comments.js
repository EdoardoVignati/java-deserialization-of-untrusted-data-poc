BAMBOO.Comments = (function ($) {
    var selectors = {
        comments: '.comments',
        commentsList: '> h2 + ol',
        commentsHeading: '> h2',
        commentForm: '#result_summary_comment',
        createCommentContainer: '.aui-toolbar',
        commentField: 'textarea',
        commentFormSubmit: '.buttons > input',
        commentFormCancel: '.buttons > .cancel',
        errorMessages: '.aui-message.error',
        deleteLink: '.delete'
    };

    function collapseCommentForm() {
        var $commentForm = $(selectors.commentForm).addClass('collapsed');
        $commentForm.find(selectors.commentField).val('');
        $commentForm.find(selectors.errorMessages).remove();
    }
    function expandCommentForm() {
        $(selectors.commentForm).removeClass('collapsed');
    }
    function appendComment(json) {
        var comment = json['comment'],
            $commentsList = $(selectors.comments).find(selectors.commentsList);

        if ($commentsList.length) {
            $(bamboo.feature.comments.commentListItem(comment)).hide().appendTo($commentsList).slideDown();
        } else {
            $(bamboo.feature.comments.commentList({ comments: [ comment ], showOperations: comment.showOperations, showTopLevelHeading: true })).hide().insertBefore(selectors.commentForm).slideDown();
        }
        collapseCommentForm();
    }
    function focusCommentField() {
        $(selectors.commentForm).find(selectors.commentField).focus();
    }
    function deleteComment(e) {
        var $delete = $(this),
            $deletePlaceholder = $('<span/>', { text: $delete.text() }),
            $original,
            $loading = $(widget.icons.icon({ type: 'loading' })),
            $comment = $delete.closest('li');

        e.preventDefault();

        if (confirm($delete.attr("title"))) {
            $original = $delete.replaceWith($deletePlaceholder);
            $loading.insertAfter($deletePlaceholder);
            $.post($delete.attr('href')).done(function () {
                $loading.remove();
                $comment.slideUp(function () {
                    var $comment = $(this),
                        $comments = $comment.siblings(),
                        $commentsList = $comment.closest('ol'),
                        $commentsHeading = $commentsList.prev('h2,h3');

                    if (!$comments.length) {
                        $commentsList.add($commentsHeading).slideUp(function () { $(this).remove(); });
                    } else {
                        $comment.slideUp(function () { $(this).remove(); });
                    }

                });
            }).fail(function () {
                $loading.remove();
                $deletePlaceholder.replaceWith($original);
            });
        }
    }
    function handleKeyUp(e) {
        if (e.which == jQuery.ui.keyCode.ESCAPE) {
            $(selectors.commentForm).find(selectors.commentFormCancel).focus(); // focus the comment link so that keyboard navigation isn't broken after the textarea loses focus
            collapseCommentForm();
        }
    }

    $(document)
        .on('click', selectors.comments + ' ' + selectors.deleteLink, deleteComment)
        .on('focus', selectors.commentField, expandCommentForm)
        .on('keyup', selectors.commentField, handleKeyUp);

    BAMBOO.asyncForm({
        target: selectors.commentForm,
        success: appendComment,
        cancel: collapseCommentForm,
        formReplaced: focusCommentField,
        resetOnSuccess: true,
        loadingIconInsertionMethod: 'append'
    });
    AJS.whenIType(AJS.I18n.getText('global.keyboardshortcut.addcomment')).execute(focusCommentField);
}(jQuery));