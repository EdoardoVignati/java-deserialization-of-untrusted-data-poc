(function ($, BAMBOO) {
    BAMBOO.createVersionPreview = (function () {
        var defaults = {
            versionSoyTemplate: bamboo.page.deployment.version.versionDetails,
            versionNumberTemplate: bamboo.page.deployment.version.showVersionNames,
            sameResultWarningSoyTemplate: bamboo.page.deployment.version.sameBuildResultWarning,
            sourcePlanTemplate: widget.plan.renderRestPlanNameLink,
            resultSoyTemplate: bamboo.feature.build.result.resultSelectionList,
            versionsQueryUrl: 'rest/api/latest/deploy/preview/result',
            resultsQueryUrl: 'rest/api/latest/result',
            lastVersionUrl: 'rest/api/latest/deploy/project',
            nextVersionQueryUrl: 'rest/api/latest/deploy/projectVersioning',
            resultsCount: 0,
            deploymentProjectId: null,
            lastVersionResultKey: null,
            selectors: {
                formSelector: null,
                versionPreviewContainerSelector: null,
                newVersionResultRadioName: null,
                planKeySelector: null,
                deploymentProjectBranchKey: null,
                branchPickerSelector: null,
                pickVersionSelector: null,
                selectBuildSelector: null,
                changesSinceSelector: null,
                customResultFieldSelector: null,
                customResultFieldErrorSelector: null,
                customResultRadioSelector: null,
                saveButtonSelector: null,
                sourcePlanLinkSelector: null
            }
        },
        $branchPicker,
        planKey,
        linkedPlanKey,
        deploymentFromMainBranch,
        lastVersion,
        planResultKey,
        options,
        validate = function () {
            var val = $(options.selectors.customResultFieldSelector).val();
            if (val && val.trim().length > 0 && (!$.isNumeric(val) || val <= 0)) {
                $(options.selectors.customResultFieldErrorSelector).empty().append('Please provide a valid build number').removeClass('hidden');
            } else {
                $(options.selectors.customResultFieldErrorSelector).empty().addClass('hidden');
            }
        },
        updateKeys = function() {
            var deploymentProjectBranchKey = $(options.selectors.deploymentProjectBranchKey).val();
            planKey = $branchPicker.auiSelect2('val');
            linkedPlanKey = $(options.selectors.planKeySelector).val();
            if (planKey.trim().length == 0) {
                planKey = linkedPlanKey;
            }
            deploymentFromMainBranch = (planKey == deploymentProjectBranchKey);
        },
        onPlanBranchChange = function() {
            renderArbitraryContent(options.selectors.selectBuildSelector, widget.icons.icon({type: 'loading'}));
            updateKeys();
            var url = AJS.contextPath() + '/' + options.resultsQueryUrl + '/' + planKey;
            var urlParams = {};
            urlParams.expand = 'results.result.plan.master';
            urlParams.buildstate = 'successful';
            $.ajax({
                       url: url + '?' + $.param(urlParams),
                       dataType: 'json',
                       contentType: 'application/json',
                       cache: false
                   }).success(renderResults).error(renderError)
        },
        updateLatestVersion = function() {
            renderArbitraryContent(options.selectors.pickVersionSelector, widget.icons.icon({type: 'loading'}));
            var url = AJS.contextPath() + '/' + options.lastVersionUrl + '/' + options.deploymentProjectId + '/versions?max-results=1&branchKey=' + planKey;
            $.ajax({
                       url: url,
                       dataType: 'json',
                       contentType: 'application/json',
                       cache: false
                   }).success(updateNextVersion).error(renderError)
        },
        updateNextVersion = function(data) {
            lastVersion = data.versions[0];
            var url = AJS.contextPath() + '/' + options.nextVersionQueryUrl + '/' + options.deploymentProjectId + '/nextVersion';
            var urlParams = {};
            urlParams.deploymentProjectId = options.deploymentProjectId;
            if (lastVersion) {
                urlParams.lastVersionName = lastVersion.name;
            }
            urlParams.incrementNumbers=true;
            urlParams.resultKey=planResultKey;


            $.ajax({
                       url: url + '?' + $.param(urlParams),
                       dataType: 'json',
                       contentType: 'application/json',
                       cache: false
                   }).success(renderVersionNumbers).error(renderError)
        },
        renderVersionNumbers = function(data) {
            $(options.selectors.pickVersionSelector).empty().append(options.versionNumberTemplate({
                deploymentProjectId: options.deploymentProjectId,
                deploymentFromMainBranch: deploymentFromMainBranch,
                latestVersion: lastVersion,
                versionName: data.nextVersionName,
                nextVersionName: data.subsequentVersionName
            }));
        },
        updateVersionInfo = function() {
           renderArbitraryContent(options.selectors.versionPreviewContainerSelector, widget.icons.icon({type: 'loading'}));
           var url = AJS.contextPath() + '/' + options.versionsQueryUrl;
           var urlParams = {};
           var resultKey = $('input[name=' + options.selectors.newVersionResultRadioName + ']:checked', options.selectors.formSelector).val();

           if (resultKey && resultKey.length > 0 && resultKey != 'custom') {
               if (options.lastVersionResultKey && resultKey === options.lastVersionResultKey.key) {
                   renderSameResultWarning();
                   return;
               }
               urlParams.resultKey = resultKey;
               planResultKey = resultKey;
           } else {
               var buildNumber = $(options.selectors.customResultFieldSelector).val();
               if (! $.isNumeric(buildNumber)) {
                   renderArbitraryContent(options.selectors.versionPreviewContainerSelector, AJS.I18n.getText('deployment.execute.preview.version.invalidresult'));
                   return;
               }
               if (options.lastVersionResultKey && buildNumber === options.lastVersionResultKey.resultNumber.toString()) {
                   renderSameResultWarning();
                   return;
               }
               urlParams.planKey = planKey;
               urlParams.buildNumber = buildNumber.trim();
               planResultKey=planKey + '-' + urlParams.buildNumber;
           }

           urlParams.deploymentProjectId = options.deploymentProjectId;

           $.ajax({
                url: url + '?' + $.param(urlParams),
                dataType: 'json',
                contentType: 'application/json',
                cache: false
           }).success(renderVersionInfo).error(renderError)
        },
        showIssueOrCommitsDialog = function ($trigger) {
            var $loading = $('<span class="icon icon-loading aui-dialog-content-loading" />'),
                $dialogContent = $('<div class="aui-dialog-content deployment-preview-dialog"/>').html($loading),
                dialog = new AJS.Dialog({
                    width: 840,
                    height: 600,
                    keypressListener: function (e) {
                        if (e.which == jQuery.ui.keyCode.ESCAPE) {
                            dialog.remove();
                            $dialogContent.html($loading);
                        }
                    }
                });

            dialog.addButton(AJS.I18n.getText('global.buttons.close'), function (dialog) {
                dialog.remove();
                $dialogContent.html($loading);
            });
            dialog.addPanel('', $dialogContent);
            dialog.addHeader($trigger.attr('title'));
            AJS.$.ajax({
                url: $trigger.attr('href'),
                data: { 'bamboo.successReturnMode': 'json', decorator: 'nothing', confirm: true },
                cache: false
            }).done(function (html) {
                $dialogContent.html(html);
            });
            dialog.show();
        },
        renderResults = function(data) {
            var placeHolderBuildNumber = 1;
            if (data.results.result.length > 0) {
                setSectionsVisible(true);
                if (data.results.result.length > 1) {
                    placeHolderBuildNumber = Math.max(data.results.result[1].number, 1);
                }
                else {
                    placeHolderBuildNumber = Math.max(data.results.result[0].number, 1);
                }
            }
            else {
                setSectionsVisible(false);
            }

            var branchData = $branchPicker.auiSelect2('data');
            branchData = branchData.searchEntity ? branchData.searchEntity.branchName : '';

            var planName = $(options.selectors.sourcePlanLinkSelector + '> a').text().replace('›', '-') + " - " + branchData;
            $(options.selectors.selectBuildSelector).empty().append(options.resultSoyTemplate({
                results: data.results.result,
                placeHolderBuildNumber: placeHolderBuildNumber,
                planKey: planKey,
                planName: planName
            }));

            options.customBuildResultsError='';
            updateOnRenderResults();
            BAMBOO.DynamicFieldParameters.syncFieldShowHide($(options.selectors.selectBuildSelector), false);
        },
        renderVersionInfo = function(data) {
            $(options.selectors.versionPreviewContainerSelector).empty().append(options.versionSoyTemplate(data));
        },
        renderArbitraryContent = function(selector, content) {
            $(selector).empty().append($('<p/>').append(content));
        },
        renderError = function(jqXHR, textStatus, errorText, errorThrown) {
            var $message = BAMBOO.generateErrorMessages(jqXHR, textStatus, errorThrown);
            if (!$message) {
                $message = $('<p/>').append(AJS.I18n.getText('deployment.execute.preview.version.error'));
            }
            renderArbitraryContent(options.selectors.versionPreviewContainerSelector, $message);
        },
        renderSameResultWarning = function () {
            $(options.selectors.versionPreviewContainerSelector).empty().append(options.sameResultWarningSoyTemplate({}));
        },
        setSectionsVisible = function(visible) {
            if (visible) {
                $(options.selectors.pickVersionSelector).show();
                if (options.lastVersionResultKey) {
                    $(options.selectors.changesSinceSelector).show();
                }
                $(options.selectors.saveButtonSelector).show();
            }
            else {
                $(options.selectors.pickVersionSelector).hide();
                $(options.selectors.changesSinceSelector).hide();
                $(options.selectors.saveButtonSelector).hide();
            }
        },
        attachResultSelectionEvents = function() {
            $('input[name=buildResult]').on('change', updateOnResultSelection);
            $(options.selectors.customResultFieldSelector)
                    .on('keyup', _.debounce(validate, 200))
                    .on('keyup', _.debounce(updateOnResultSelection, 400));

            $('#new-version').on('click', '.issue_url, .commit_url', function (e) {
                e.preventDefault();
                showIssueOrCommitsDialog($(this));
            });

            $(options.selectors.customResultRadioSelector).on('click', function () {
                if ($(options.selectors.customResultRadioSelector).prop('checked')) {
                    $(options.selectors.customResultFieldSelector).focus();
                }
            });
        },
        updateOnRenderResults = function() {
            attachResultSelectionEvents();
            updateOnResultSelection();
        },
        updateOnResultSelection = function() {
            // 2 AJAX calls in parallel
            updateLatestVersion();
            updateVersionInfo();
        };
        return {
            init: function (opts) {
                options = $.extend(true, defaults, opts);
                $branchPicker = $(options.selectors.branchPickerSelector);

                BAMBOO.EventBus.on('branch:change', function() {
                    onPlanBranchChange();
                });

                updateKeys();

                if (options.resultsCount == 0) {
                    setSectionsVisible(false);
                }
                attachResultSelectionEvents();
                updateVersionInfo();
            }
        }
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));