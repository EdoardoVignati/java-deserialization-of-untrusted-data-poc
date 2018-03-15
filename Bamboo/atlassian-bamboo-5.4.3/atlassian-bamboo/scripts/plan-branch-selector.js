BAMBOO.PlanBranchSelector = function (opts) {
    var $ = AJS.$,
        defaults = {
            trigger: null,
            planKey: null,
            id: 'plan-branch-selector',
            includeMaster: false,
            masterBranchName: null,
            masterBranchDescription: null,
            includeLatestResult: false,
            inlineDialogClass: null,
            maxBranches: 10,
            getPlanDetailsUrl: AJS.contextPath() + '/rest/api/latest/plan/{planKey}/branch',
            templates: {
                branchItem: null,
                branchItemActiveBuild: null
            }
        },
        options = $.extend(true, defaults, opts),
        inlineDialog,
        createInlineDialogContent = function ($contents, trigger, showInlineDialog) {
            var $trigger = $(trigger),
                planKey = (options.planKey || $trigger.data('planKey'));

            $contents.html(widget.icons.icon({ type: 'loading' }));

            if (!inlineDialog.is(':visible')) {
                showInlineDialog();
            }
            inlineDialog.refresh();

            getPlanDetails(planKey).done(function (json) {
                var $ul = $('<ul/>'),
                    branches = json['branches']['branch'];

                if (options.includeMaster) {
                    $(AJS.template.load(options.templates.branchItem).fill({ 'key': planKey, 'shortName': options.masterBranchName, 'description': options.masterBranchDescription }).toString()).addClass('master').appendTo($ul);
                }

                for (var i = 0, ii = branches.length; i < ii; i++) {
                    var branchData = branches[i],
                        defaultBranchData = {
                            latestResult: {
                                key: branchData['key'] + '/latest',
                                state: 'NeverExecuted',
                                number: '--',
                                suspendedClass: "",
                                description: ""
                            }
                        },
                        branch = $.extend(true, defaultBranchData, branchData),
                        latestResultNumber = branch['latestResult']['number'];

                    if (typeof latestResultNumber == 'number') {
                        branch['latestResult']['number'] = '#' + latestResultNumber;
                    }

                    if (!branchData.enabled) {
                        branch.latestResult.suspendedClass = "Suspended";
                    }
                    $(AJS.template.load((options.templates.branchItemActiveBuild && branch['latestCurrentlyActive'] ? options.templates.branchItemActiveBuild : options.templates.branchItem)).fill(branch).toString()).appendTo($ul);
                }

                $contents.html($ul);
                $('<a/>', {
                    text: AJS.I18n.getText('branch.complete.listing'),
                    href: AJS.contextPath() + '/browse/' + planKey + '/branches',
                    'class': 'complete-listing'
                }).insertAfter($ul);

                showInlineDialog();
            });
        },
        getPlanDetails = function (planKey) {
            return $.ajax({
                url: options.getPlanDetailsUrl.replace('{planKey}', planKey),
                cache: false,
                dataType: 'json',
                data: {
                    expand: (options.includeLatestResult ? 'branches.branch' : 'branches'),
                    'max-results': (options.maxBranches || 0)
                }
            });
        };

    return {
        init: function () {
            inlineDialog = AJS.InlineDialog(options.trigger, options.id, createInlineDialogContent, {
                fadeTime: 0,
                showDelay: 0,
                useLiveEvents: true,
                width: 250,
                offSetY: 0
            }).addClass('plan-branch-selector ' + (options.inlineDialogClass || ''));
            
            $(document).delegate(options.trigger, 'keydown', function (e) {
                if (e.which == jQuery.ui.keyCode.ENTER) {
                    e.preventDefault();
                    inlineDialog.show.call(this);
                }
            });
        }
    };
};
