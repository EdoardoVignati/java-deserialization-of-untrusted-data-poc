BAMBOO.JIRAISSUECREATION = (function ($) {
    var defaults = {
            planResultKey: null,
            applinkId: null,
            projectId: null,
            returnUrl: null,
            issueTypeId: null,
            noProjectsMessage: null,
            templates: {
                authenticationRequiredTemplate: null,
                cannotCreateTemplate: null,
                shortcutHint: null,
                genericErrorHelpLink: null
            }
        },
        options,
        firstTime = true,
        setRequiredField = function ($selectField, value) {
            var $label = $("label[for="+$selectField.attr('id')+"]");
            $label.find("span").remove();
            if (value) {
                $label.append("<span class=\"aui-icon icon-required\"></span><span class=\"content\"> (required)</span>");
            }
        },
        hideSelect = function ($selectField) {
            $selectField.parent().hide();
            $selectField.find("option").remove();
        },
        populateMultiSelect = function ($selectField, fieldSchema) {
            var show = false;
            setRequiredField($selectField, fieldSchema.required);

            $(fieldSchema.allowedValues).each(function () {
                $('<option />', {
                    val: this.id,
                    text: this.name,
                    title: this.description
                }).appendTo($selectField);
               show = true;
            });
            if (show) {
                $selectField.parent().show();
            }
        },
        populateErrors = function (data) {
            var $messageContainer = $("#cannot-create-message-container"),
                $issueContainer = $("#issue-contents-container"),
                $message;
            /* other error cases */
            if (data.errors && data.errors.length) {
                $message = BAMBOO.buildAUIErrorMessage(data.errors);
            } else if (data.fieldErrors && data.fieldErrors.length) {
                var renderedErrors = [];
                for (var fieldError in data.fieldErrors){
                    if (data.fieldErrors.hasOwnProperty(fieldError)) {
                        renderedErrors.push(fieldError + ": " + data.fieldErrors[fieldError]);
                    }
                }
                $message = BAMBOO.buildAUIErrorMessage(renderedErrors);
            } else if (data.messages && data.messages.length) {
                $message = BAMBOO.buildAUIWarningMessage(data.messages);
            }
            $message.append(AJS.template.load(options.templates.genericErrorHelpLink).toString());
            $messageContainer.append($message).show();
        },
        clearErrors = function () {
            $("#executeCreateNewJiraIssue div.error").remove();
        },
        populateForm = function (projectKey, issueTypeId) {
            var $versionSelectField = $("#jiraProjectVersions"),
                $componentSelectField =$("#jiraProjectComponents"),
                $messageContainer = $("#cannot-create-message-container"),
                $fieldContainer = $("#issue-fields-container"),
                $loadingSpinner = $("#fields-loading-spinner"),
                $createButton = $("#executeCreateNewJiraIssue_save");

            $messageContainer.hide().children().remove();
            $fieldContainer.hide();
            $loadingSpinner.show();
            $createButton.attr("disabled", "disabled");
            hideSelect($versionSelectField);
            hideSelect($componentSelectField);

            $.ajax({
                url: AJS.contextPath() + "/ajax/issueTypeSchema.action",
                data: {
                    appLinkId: $("#jiraServer option:selected").val(),
                    projectKey: projectKey,
                    issueTypeId: issueTypeId,
                    returnUrl: options.returnUrl
                },
                dataType: 'json',
                contentType: 'application/json',
                success: function (data) {
                    if (data.status != 'ERROR') {
                        var fields = data.projects[0].issuetypes[0].fields,
                            unhandledRequiredFields = "";

                        for (var fieldName in fields) {
                            if (fields.hasOwnProperty(fieldName)) {
                                var field = fields[fieldName];
                                if (fieldName == "summary") {
                                    setRequiredField($("#jiraIssueSummary"), field.required);
                                } else if (fieldName == "description") {
                                    setRequiredField($("#issueDescription"), field.required);
                                } else if (fieldName == "components") {
                                    populateMultiSelect($componentSelectField, field);
                                } else if (fieldName == "versions") {
                                    populateMultiSelect($versionSelectField, field);
                                } else if (field.required && fieldName != "issuetype" && fieldName != "reporter" && fieldName != "project" && fieldName != "assignee") {
                                    unhandledRequiredFields = unhandledRequiredFields + " " + field.name;
                                }
                            }
                        }
                        $loadingSpinner.hide();
                        if (unhandledRequiredFields.length) {
                            $messageContainer.append(AJS.template.load(options.templates.cannotCreateTemplate).fill({issueTypeName: data.projects[0].issuetypes[0].name, fieldNames: unhandledRequiredFields}).toString()).show();
                        } else {
                            $createButton.removeAttr("disabled");
                            $fieldContainer.show();
                        }
                    } else {
                        populateErrors(data);
                    }
                },
                error: function (request, textStatus, errorThrown) {}
            });
        },
        serverSelect = function () {
            var projectsById = {},
                $loginDanceContainer = $("#login-dance-message-container"),
                $issueContainer = $("#issue-contents-container"),
                $messageContainer = $("#cannot-create-message-container");

            $("#executeCreateNewJiraIssue_save").attr("disabled", "disabled");
            $("#jiraServer").attr("disabled", "disabled");
            $loginDanceContainer.hide();
            $issueContainer.hide();
            $("#cannot-create-message-container").hide();
            $("#issue-loading-spinner").show();
            $('#jiraProjectKey option').remove();
            $('#jiraIssueType option').remove();
            $messageContainer.hide().children().remove();

            $.ajax({
                url: AJS.contextPath() + "/ajax/jiraIssueSchema.action",
                data: {
                    appLinkId: $("#jiraServer option:selected").val(),
                    returnUrl: options.returnUrl
                },
                dataType: 'json',
                contentType: 'application/json',
                success: function (data) {
                    if (data.status != 'ERROR') {
                        var $projects = $('#jiraProjectKey'),
                            projectIdExists = false;

                        // there is a slight chance of multiple requests being made via selenium or bad programming.
                        // this prevents the project list from getting duplicate options
                        $projects.children().remove();

                        if (data.projects && data.projects.length) {
                            $(data.projects).each(function () {
                                projectsById[this.id] = this;
                                $('<option />', {
                                    val: this.id,
                                    text: this.name
                                }).appendTo($projects);
                                if (this.id == options.projectId) {
                                    projectIdExists = true;
                                }
                            });

                            $projects.unbind();
                            var updateForProject = function () {
                                var project = $('option:selected', $projects),
                                    projectScheme = projectsById[project.val()],
                                    issueTypeExists = false,
                                    $types = $('#jiraIssueType');

                                $types.find("option").remove();
                                $types.unbind();
                                $(projectScheme.issuetypes).each(function () {
                                    if (!this.subtask) {
                                        $('<option />', {
                                            val: this.id,
                                            text: this.name,
                                            title: this.description
                                        }).appendTo($types);
                                        if (this.id == options.issueTypeId) {
                                            issueTypeExists = true;
                                        }
                                    }
                                });

                                var updateForType = function () {
                                    populateForm(projectScheme.key, $types.val());
                                };
                                $types.change(function () {
                                    clearErrors();
                                    updateForType();
                                });
                                if (firstTime && issueTypeExists) {
                                    $types.val(options.issueTypeId);
                                }
                                updateForType();
                            };
                            $projects.change(function () {
                                clearErrors();
                                updateForProject();
                            });
                            if (firstTime && projectIdExists) {
                                $projects.val(options.projectId);
                            }
                            updateForProject();
                            $projects.focus();
                            $loginDanceContainer.hide();
                            $issueContainer.show();
                            firstTime=false;
                        } else {
                            var $message = BAMBOO.buildAUIErrorMessage([options.noProjectsMessage]);
                            $message.append(AJS.template.load(options.templates.genericErrorHelpLink).toString());
                            $messageContainer.append($message).show();
                        }
                    } else if (data.authenticationRedirectUrl && data.authenticationRedirectUrl.length) {
                        $loginDanceContainer.children().remove();
                        $loginDanceContainer.append(AJS.template.load(options.templates.authenticationRequiredTemplate).fill({ authenticationUrl: data.authenticationRedirectUrl, authenticationInstanceName: (data['authenticationInstanceName'] || AJS.I18n.getText('jira.title')) }).toString()).show();
                        $issueContainer.hide();
                    } else {
                        populateErrors(data);
                    }
                    $("#issue-loading-spinner").hide();
                    $("#jiraServer").removeAttr("disabled");
                },
                error: function (request, textStatus, errorThrown) {}
            });
        };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);
            firstTime = true;
            $("#executeCreateNewJiraIssue").find(".buttons-container").prepend(AJS.template.load(options.templates.shortcutHint).toString());
            var $jiraServer = $("#jiraServer");
            $jiraServer.change(function () {
                clearErrors();
                serverSelect();
            });
            if (options.applinkId && $jiraServer.find("option[value='" + options.applinkId + "']").length) {
                $jiraServer.val(options.applinkId);
            }
            serverSelect();
            $jiraServer.closest('form').bind('asyncform-notification', function (e, messages, warnings) {
                var messageDialog, $messages = $('<div />');

                if (messages && messages.length) {
                    $messages.append(BAMBOO.buildAUIMessage(messages, 'success', {escapeTitle: false}));
                }
                if (warnings && warnings.length) {
                    var $message = BAMBOO.buildAUIWarningMessage(warnings);
                    $message.append(AJS.template.load(options.templates.genericErrorHelpLink).toString());
                    $messages.append($message);
                }
                if ($messages.children().length) {
                    $messages.hide().appendTo(document.body); // append to the DOM so we can calculate how big the dialog should be to accommodate the messages
                    messageDialog = new AJS.Dialog({
                        width: 600,
                        height: $messages.innerHeight() + 70 // ~70px should be enough for the button bar plus a bit of padding
                    });
                    messageDialog.addPanel('', $messages.remove().html());
                    messageDialog.addButton(AJS.I18n.getText('global.buttons.close'), function (dialog) {
                        dialog.remove();
                    });
                    messageDialog.show();
                }
            });
        },
        returnFromDialog: function (response) {
            BAMBOO.JIRAISSUES.refresh(response['newIssueKey']);
        }
    };
})(jQuery);


BAMBOO.JIRAISSUECREATION.NOAPPLINK = (function ($) {
    var defaults = {
        trigger: null,
        contentTemplate: null,
        appLinksAdminUrl: null,
        admin: null
    },
    options,
    showDialog = function () {
        var dialog = new AJS.Dialog({
            width: 600,
            height: 600,
            keypressListener: function (e) {
                if (e.which == jQuery.ui.keyCode.ESCAPE) {
                    dialog.remove();
                }
            }
        });
        dialog.addHeader(AJS.I18n.getText("buildResult.create.issue.title"));
        dialog.addPanel("", AJS.template.load(options.contentTemplate).toString());
        if (options.admin) {
            dialog.addButton(AJS.I18n.getText("buildResult.create.issue.noAppLinks.connect"), function (dialog) {
                window.location = options.appLinksAdminUrl;
            });
        }
        dialog.addCancel(AJS.I18n.getText("global.buttons.cancel"), function (dialog)
        {
            dialog.hide();
        });
        dialog.show();
    };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);
            $(document).delegate(options.trigger, "click", function (e) {
                e.preventDefault();
                showDialog();
            });
        }
    }
})(AJS.$);
