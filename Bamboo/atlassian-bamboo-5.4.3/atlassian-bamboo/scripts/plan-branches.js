BAMBOO.BRANCHES = {};

BAMBOO.BRANCHES.EditChainBranchDetails = function (opts) {
    var $ = AJS.$,
            defaults = {
                controls : {
                    form: null,
                    integrationEnabled: null,
                    integrationStrategy: null,
                    gateKeeperCheckoutBranch: null,
                    gateKeeperPushBranch: null,
                    integrationStrategies: '.integration-strategy'
                }
            },
            options = $.extend(true, defaults, opts),
            $controls = {
                form: null,
                integrationStrategy: null,
                gateKeeperPushBranch: null
            },
            onChangeGateKeeperCheckoutBranch = function() {
                var gateKeeperBranch = $(this).find('option:selected').text();
                $controls.gateKeeperPushBranch.text(gateKeeperBranch);
            },
            onChangeIntegrationEnabled = function() {
                if ($(this).is(':checked')) {
                    if (!$controls.integrationStrategy.is(':checked')) {
                        $controls.integrationStrategy.filter(':first').prop('checked', true);
                    }
                    indicateActiveStrategy();
                }
            },
            indicateActiveStrategy = function () {
                $controls.integrationStrategy.each(function () {
                    var $radio = $(this);

                    $radio.closest(options.controls.integrationStrategies).toggleClass('active', $radio.is(':checked'));
                });
            },
            onClickInStrategy = function () {
                $(this).find(options.controls.integrationStrategy).prop('checked', true);
                indicateActiveStrategy();
            };

    return {
        init: function () {
            $controls.form = $(options.controls.form);
            $controls.integrationStrategy = $controls.form.find(options.controls.integrationStrategy).click(indicateActiveStrategy);
            $controls.gateKeeperPushBranch = $controls.form.find(options.controls.gateKeeperPushBranch);

            $controls.form.find(options.controls.gateKeeperCheckoutBranch).change(onChangeGateKeeperCheckoutBranch).each(onChangeGateKeeperCheckoutBranch);
            $controls.form.find(options.controls.integrationEnabled).change(onChangeIntegrationEnabled).each(onChangeIntegrationEnabled);
            $controls.form.find(options.controls.integrationStrategies).click(onClickInStrategy);
        }
    };
};

BAMBOO.BRANCHES.BranchesSplashScreen = (function ($) {
    var defaults = {
            content: null,
            contentId: 'branch-splash-content',
            dialog: {
                width: 688,
                height: 480,
                id: 'branch-splash',
                keypressListener: function (e) {
                    if (e.which == jQuery.ui.keyCode.ESCAPE) {
                        dialog.remove();
                    }
                }
            },
            templates: {
                dontShowCheckbox: null
            }
        },
        options,
        dialog,
        $dontShowCheckbox;

    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);

            dialog = new AJS.Dialog(options.dialog)
                .addHeader(AJS.I18n.getText('branch.splash.title'))
                .addPanel('', $('<div />', { html: options.content, id: options.contentId }))
                .addButton(AJS.I18n.getText('global.buttons.close'), function () { dialog.remove(); });

            $dontShowCheckbox = $(AJS.template.load(options.templates.dontShowCheckbox).toString())
                .prependTo($(dialog.page[0].element).find('.dialog-button-panel'))
                .find('input:checkbox');

            dialog.show();

            $(window).bind('remove.dialog', function (e, data) {
                if (data.dialog.id === options.dialog.id && $dontShowCheckbox.is(':checked')) {
                    $.post(AJS.contextPath() + '/rest/pref/latest/user', { 'bamboo.user.branches.splashscreen.hide': true });
                }
            });
        }
    }
})(jQuery);