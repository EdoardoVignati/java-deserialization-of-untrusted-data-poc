BAMBOO.JIRAISSUETRANSITION = (function ($) {
    var opts = {
        issueKey: null,
        returnUrl: null
    },
    $errorMessagesContainer,
    $issueControlsContainer,
    $loginDanceMessageContainer,
    $loadingSpinner,
    $issueDetails,
    $issueStatus,
    $transitionButton,
    $transitionSelect,
    $transitionIssueResolution,
    $resolutionButton,
    $resolutionSelect,

    onTransitionClick = function() {
        $transitionButton.attr("disabled", "disabled");
        $transitionSelect.attr("disabled", "disabled");
        $resolutionButton.attr("disabled", "disabled");
        $resolutionSelect.attr("disabled", "disabled");
        $loadingSpinner.show();
        AJS.$.ajax({
            url: AJS.contextPath() + "/ajax/transitionIssue.action?issueKey=" + opts.issueKey + "&transitionId=" + $transitionButton.val()
                    + ($transitionIssueResolution.is(":visible") ? ("&resolutionId=" + $resolutionButton.val()) : "")
                    + "&returnUrl=" + encodeURIComponent(opts.returnUrl),
            dataType: 'json',
            contentType: 'application/json',
            success: function(response) {
                if (response.status != 'ERROR') {
                    if (response.requireResolution) {
                        $resolutionSelect.children().remove();
                        $(response.resolution.allowedValues).each(function(){
                            $('<option value="' + this.id + '"></option>').appendTo($resolutionSelect).text(this.name);
                        });
                        $resolutionSelect.change();
                        $resolutionButton.removeAttr("disabled");
                        $resolutionSelect.removeAttr("disabled");
                        $transitionIssueResolution.show();
                        $loadingSpinner.hide();
                    } else {
                        refreshIssueStatus();
                    }
                } else {
                    handleErrorResponse(response);
                }
                handleLoginDanceResponse(response);
            },
            error: function (request, textStatus, errorThrown) {
                $transitionButton.removeAttr("disabled");
                $transitionSelect.removeAttr("disabled");
                $resolutionButton.removeAttr("disabled");
                $resolutionSelect.removeAttr("disabled");
            }
        });

    },

    onChangeTransition = function() {
        $transitionButton.val($transitionSelect.val());
        $transitionButton.text($(":selected", $transitionSelect).text());
    },

    onChangeResolution = function() {
        $resolutionButton.val($resolutionSelect.val());
        $resolutionButton.text($(":selected", $resolutionSelect).text());
    },

    refreshIssueStatus = function() {
        $loadingSpinner.show();
        AJS.$.ajax({
            url: AJS.contextPath() + "/ajax/issueDetails.action?issueKey=" + opts.issueKey
                    + "&returnUrl=" + encodeURIComponent(opts.returnUrl),
            dataType: 'json',
            contentType: 'application/json',
            success: function(response) {
                if (response.status != 'ERROR') {
                    $issueDetails.children().remove();
                    $issueDetails.append(AJS.template.load("issueDetails-template").fill({url: response.issueUrl, title: response.fields.summary, iconUrl: response.fields.issuetype.iconUrl, key: response.key}).toString());

                    $issueStatus.children().remove();
                    $issueStatus.append(AJS.template.load("issueStatus-template").fill({iconUrl: response.fields.status.iconUrl, name: response.fields.status.name}).toString());
                    refreshTransitions();
                } else {
                    handleErrorResponse(response);
                }
                handleLoginDanceResponse(response);
            },
            error: function (request, textStatus, errorThrown) {
            }
        });
    },

    refreshTransitions = function() {
        AJS.$.ajax({
            url: AJS.contextPath() + "/ajax/issueTransitions.action?issueKey=" + opts.issueKey
                    + "&returnUrl=" + encodeURIComponent(opts.returnUrl),
            dataType: 'json',
            contentType: 'application/json',
            success: function(response) {
                if (response.status != 'ERROR') {
                    $transitionSelect.children().remove();
                    $(response.transitions).each(function(){
                        $('<option value="' + this.id + '"></option>').appendTo($transitionSelect).text(this.name);
                    });
                    $transitionSelect.change();
                    $issueControlsContainer.show();
                } else {
                    handleErrorResponse(response);
                }
                $loadingSpinner.hide();
                $transitionButton.removeAttr("disabled");
                $transitionSelect.removeAttr("disabled");
                $transitionIssueResolution.hide();
                handleLoginDanceResponse(response);
            },
            error: function (request, textStatus, errorThrown) {
            }
        });
    },

    handleLoginDanceResponse = function(response) {
        if (isDefinedObject(response.authenticationRedirectUrl)) {
            $loginDanceMessageContainer.children().remove();
            $loginDanceMessageContainer.append(AJS.template.load("authenticationRequired-template").fill({authenticationUrl: response.authenticationRedirectUrl}).toString()).show();
            $loginDanceMessageContainer.show();
            $issueControlsContainer.hide();
        } else {
            $loginDanceMessageContainer.hide();
        }
    },

    handleErrorResponse = function(response) {
        $errorMessagesContainer.children().remove();
        $(response.errors).each(function(){
            AJS.messages.error($errorMessagesContainer, { body: this, closeable: false });
        });
        $issueControlsContainer.hide();
        $errorMessagesContainer.show();
        $loadingSpinner.hide();
    };

    return {
        init: function (options) {
            $.extend(true, opts, options);
            $errorMessagesContainer = $("#error-messages-container");
            $issueControlsContainer = $("#issue-controls-container");
            $loginDanceMessageContainer = $("#login-dance-message-container");
            $loadingSpinner = $("#loading-spinner");
            $issueDetails = $("#issue-details");
            $issueStatus = $("#issue-status");
            $transitionButton = $("#transition-button");
            $transitionButton.click(onTransitionClick);
            $transitionSelect = $("#transition-select");
            $transitionSelect.change(onChangeTransition);
            $transitionIssueResolution = $("#transition-issue-resolution");
            $resolutionButton = $("#resolution-button");
            $resolutionButton.click(onTransitionClick);
            $resolutionSelect = $("#resolution-select");
            $resolutionSelect.change(onChangeResolution);
            refreshIssueStatus();
        }
    }
})(jQuery);
