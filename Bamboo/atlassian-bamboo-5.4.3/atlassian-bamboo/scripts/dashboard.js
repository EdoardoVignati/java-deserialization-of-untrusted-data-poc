(function($, BAMBOO){
    BAMBOO.DASHBOARD = {};

    BAMBOO.DASHBOARD.Expander = function (opts) {
        var defaults = {
                toggleFilterClass: null,
                triggerSelector: null,
                triggerRootSelector: null,
                tableSelector: null,
                pageSize: 50,
                disabledAttr: 'aria-disabled',
                disabledProperty: 'disabled',
                editFilterClass: 'edit-project-filter',
                icons: {
                    filter: 'filter',
                    loading: 'loading'
                }
            },
            options = $.extend(true, defaults, opts),
            request,
            iconClassPrefix = 'icon-',
            iconFilterClass = iconClassPrefix + options.icons.filter,
            iconLoadingClass = iconClassPrefix + options.icons.loading,
            showMorePlans = function (e) {
                var $loading,
                    $trigger = $(this),
                    lastProjectKey = $trigger.closest(options.triggerRootSelector).data('lastProjectKey');

                if ($(e.target).hasClass(options.editFilterClass) || $trigger.is(':disabled')) {
                    return;
                }

                $loading = $(widget.icons.icon({ type: options.icons.loading }));
                $trigger.append($loading).prop(options.disabledProperty, true);

                getPlans(AJS.contextPath() + '/allPlansSnippet.action', {
                    pageSize: options.pageSize,
                    lastProject: lastProjectKey
                }).done(updateTable).fail(showError);

                function showError() {
                    $loading.remove();
                    $trigger.prop(options.disabledProperty, false).html(AJS.I18n.getText('dashboard.filter.showMore.error'));
                }
            },
            updateTable = function (response) {
                var $table = $(options.tableSelector),
                    $htmlResponse = $(response);

                $table.append($htmlResponse.find('tbody'));
                $table.find('tfoot').replaceWith($htmlResponse.find('tfoot'));
            },
            toggleFilter = function (e, enable) {
                var $button = $('#toggle-project-filter'),
                    filterEnabled = (typeof enable === 'boolean' ? !enable : $button.is('[aria-pressed="true"]')),
                    updateButton = function () {
                        $button.attr('aria-pressed', !filterEnabled).removeAttr(options.disabledAttr);
                        if ($button.hasClass(options.editFilterClass)) {
                            $button.removeClass(options.editFilterClass).addClass(options.toggleFilterClass);
                        }
                        $button.html(widget.icons.icon({ type: options.icons.filter }) + '&nbsp;' + (filterEnabled ? AJS.I18n.getText('dashboard.filter.button.off') : AJS.I18n.getText('dashboard.filter.button.on')));
                    },
                    restoreButton = function () {
                        $button.removeAttr(options.disabledAttr)
                            .find('.icon').removeClass(iconLoadingClass).addClass(iconFilterClass);
                    };

                e && e.preventDefault();

                if ($button.is('[' + options.disabledAttr + '="true"]')) {
                    return;
                }
                $button.attr(options.disabledAttr, true)
                    .find('.icon').removeClass(iconFilterClass).addClass(iconLoadingClass);

                getPlans(AJS.contextPath() + '/toggleDashboardFilterInline.action', { filterEnabled: !filterEnabled })
                    .done(replaceTable).done(updateButton)
                    .fail(restoreButton);
            },
            replaceTable = function (response) {
                $(options.tableSelector).replaceWith(response);
            },
            getPlans = function (url, data) {
                if (request) {
                    request.abort();
                }
                return request = $.ajax({
                    url: url,
                    type: 'POST',
                    cache: false,
                    dataType: 'html',
                    data: $.extend(true, { decorator: 'nothing', confirm: true }, data || {})
                });
            },
            enableFilter = function () {
                toggleFilter(null, true);
            };

        return {
            init: function ()  {
                $(options.tableSelector).on('click', options.triggerSelector, showMorePlans);
                $(document).on('click', makeClassSelector(options.toggleFilterClass), toggleFilter);

                BAMBOO.simpleDialogForm({
                    trigger: makeClassSelector(options.editFilterClass),
                    dialogWidth: 640,
                    dialogHeight: 420,
                    success: enableFilter,
                    header: AJS.I18n.getText('dashboard.filter.title')
                });

                AJS.whenIType(AJS.I18n.getText('global.key.label')).click('#main-edit-project-filter');
            }
        };
    };

    BAMBOO.DASHBOARD.InlineActions = function () {
        var options = {
            classes: {
                favourite: 'markBuildFavourite',
                unfavourite: 'unmarkBuildFavourite',
                enable: 'enableBuild',
                loading: 'loading',
                icon: 'icon',
                iconFavourite: 'icon-favourite',
                iconUnfavourite: 'icon-favourite-remove'
            }
        };

        $(document)
            .on('click', makeClassSelector([ options.classes.favourite, options.classes.unfavourite ]), toggleFavourite)
            .on('click', makeClassSelector(options.classes.enable), enableBuild);

        function toggleFavourite(e) {
            var $this = $(this),
                planKey = $this.data('planKey'),
                icon = $this.children(makeClassSelector(options.classes.icon)),
                isFavourite = $this.hasClass(options.classes.unfavourite),
                endpoint = AJS.contextPath() + '/rest/api/latest/plan/' + planKey + '/favourite';

            e.preventDefault();

            if ($this.hasClass(options.classes.loading)) {
                return;
            }
            $this.addClass(options.classes.loading);

            $.ajax({
                url: endpoint,
                type: (isFavourite ? 'DELETE' : 'POST'),
                dataType: 'json'
            }).done((isFavourite ? unmark : mark)).always(reset);

            function mark() {
                $this.removeClass(options.classes.favourite).addClass(options.classes.unfavourite);
                icon.removeClass(options.classes.iconFavourite).addClass(options.classes.iconUnfavourite);
            }
            function unmark() {
                $this.removeClass(options.classes.unfavourite).addClass(options.classes.favourite);
                icon.removeClass(options.classes.iconUnfavourite).addClass(options.classes.iconFavourite);
            }
            function reset() {
                $this.removeClass(options.classes.loading);
            }
        }

        function enableBuild(e) {
            var $this = $(this),
                planKey = $this.data('planKey');

            e.preventDefault();

            if ($this.hasClass(options.classes.loading)) {
                return;
            }
            $this.addClass(options.classes.loading);

            $.ajax({
                type: 'POST',
                url: AJS.contextPath() + '/rest/api/latest/plan/' + planKey + '/enable',
                dataType: 'json'
            }).done(enable).always(reset);

            function enable() {
                $this.hide();
                $('#manualBuild_' + planKey).css("display", "");
            }
            function reset() {
                $this.removeClass(options.classes.loading);
            }
        }
    };
    BAMBOO.DASHBOARD.InlineActions();

    function makeClassSelector(classes) {
        var classArr = (typeof classes === 'string' ? [ classes ] : classes);
        return '.' + classArr.join(',.');
    }
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));