BAMBOO.BranchCreation = (function ($) {
    var defaults = {
        containerSelector: null,
        checkBoxFieldSetSelector: null,
        showMoreSelector: null,
        placeHolderSelector: null,
        optionsSelector: null,
        getBranchesUrl: null,
        planKey: null,
        templates: {
            branchesList: null,
            branchesItem: null,
            branchesNone: null,
            branchesTooMany: null,
            branchesTimeout: null,
            branchesError: null
        }
    },
    options,
    lastResult = 0,
    $container,
    execute = function () {
        var $branchesCheckboxes = $(options.checkBoxFieldSetSelector);
        if (!$branchesCheckboxes.length)  {
            lastResult = 0; /*reset if there is no checkboxes on the page*/
        }
        $.ajax({
            url: options.getBranchesUrl,
            cache: false,
            dataType: 'json',
            data: {
                planKey: options.planKey,
                "start-index": lastResult,
                "max-results": lastResult > 0 ? 100 : 30
            }
        }).done(function (json) {
            $(options.placeHolderSelector).remove();
            var branches = json["branches"]["branch"];
            if (branches && branches.length > 0) {
                var $toAppend = $();
                for (var i = 0, ii = branches.length; i < ii; i++) {
                    $toAppend = $toAppend.add($(AJS.template.load(options.templates.branchesItem).fill({branch: branches[i].name, itemCount: (i+lastResult)}).toString()));
                }

                if (!$branchesCheckboxes.length) {
                    var $branchesContent = $(AJS.template.load(options.templates.branchesList).toString());
                    $branchesCheckboxes = $branchesContent.filter(options.checkBoxFieldSetSelector);
                    $toAppend.appendTo($branchesCheckboxes);
                    $branchesContent.appendTo($container);
                } else {
                    $toAppend.appendTo($branchesCheckboxes);
                }

                var $tooManyBranches = $(options.showMoreSelector);
                lastResult = json.branches["max-result"] + json.branches["start-index"];
                if (!$tooManyBranches.length && json.branches["size"] > lastResult) {
                    $(AJS.template.load(options.templates.branchesTooMany).toString()).appendTo($container);
                } else if ($tooManyBranches.length && json.branches["size"] <= lastResult) {
                    $tooManyBranches.remove();
                }
                $(options.optionsSelector).show().removeClass("hidden");
            } else {
                $(AJS.template.load(options.templates.branchesNone).toString()).appendTo($container);
            }
        }).error(function(jqXHR, textStatus, errorThrown) {
            $(options.placeHolderSelector).remove();
            if (textStatus === "timeout") {
                BAMBOO.buildAUIMessage([AJS.template.load(options.templates.branchesTimeout).toString()], "error", {escapeTitle:false}).appendTo($container);
            } else {
                BAMBOO.buildAUIMessage([AJS.template.load(options.templates.branchesError).toString()], "error", {escapeTitle:false}).appendTo($container);
            }
        });
    },
    switchToAuto = function() {
                 $("#autoBranchCreation").show().removeClass("hidden");
                 $("#manualBranchCreation").hide().addClass("hidden");
                 $("#creationOption").val("AUTO");
    },
    switchToManual = function(){
                 $("#manualBranchCreation").show().removeClass("hidden");
                 $("#autoBranchCreation").hide().addClass("hidden");
                 $("#creationOption").val("MANUAL");
    };

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);
            $("#createPlanBranch").delegate(".switchToAuto", "click", switchToAuto)
                                  .delegate(".switchToManual", "click", switchToManual)
                                  .delegate(options.showMoreSelector, "click", execute);
            $container = $(options.containerSelector);
            execute();
        }
    };
})(AJS.$);
