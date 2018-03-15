(function (window, undefined) {
    var History = window.History,
        $ = window.jQuery,
        document = window.document;

    if (!History.enabled) {
        return false;
    }

    $(function () {
        var $tabsContainer = $('.aui-tabs.aui-tabs-disabled,.aui-navgroup-horizontal'),
            isHorizontalNav = $tabsContainer.hasClass('aui-navgroup-horizontal'),
            $content = (
                isHorizontalNav ?
                $tabsContainer.nextAll('.aui-page-panel:first').find('.aui-page-panel-content').filter(':first') :
                $tabsContainer.children('.tabs-pane').filter(':first')
            ),
            $links = (
                isHorizontalNav ?
                $tabsContainer.find('.aui-navgroup-primary:first .aui-nav') :
                $tabsContainer.children('.tabs-menu')
            ),
            activeClass = (isHorizontalNav ? 'aui-nav-selected' : 'active-tab'),
            $planNavigator = $('#plan-navigator'),
            $plan,
            $jobs,
            planKey,
            activeJobKey,
            request,
            contextPath = AJS.contextPath() || '',
            listenForPotentialTabLinksInContent = function () {
                var $tab = $(this);

                $content.delegate('a[href="' + $tab.attr('href') + '"]', 'click', function (e) {
                    // Continue as normal for cmd clicks etc
                    if (e.which == 2 || e.metaKey) { return true; }

                    e.preventDefault();
                    $tab.click();
                });
            };

        // If not a tabbed page don't do any history manipulation
        if (!$tabsContainer.length || $tabsContainer.hasClass('history-xhr-disabled')) {
            return false;
        }

        // Get active tab on page load and store that data against this history entry
        History.replaceState({
            tabId: BAMBOO.escapeIdToJQuerySelector($links.find('.' + activeClass).children('a').attr('id'))
        }, document.title, null);

        if ($planNavigator.length) {
            $plan = $planNavigator.find('> ol');
            planKey = $plan.data('planKey');
            $jobs = $planNavigator.find('> ol ul > li');
            activeJobKey = $jobs.filter('.active').data('jobKey');
        }

        $links.find('a').click(function (e) {
            var $this = $(this),
                url = $this.attr('href'),
                title = $this.attr('title') || null;

            // Continue as normal for cmd clicks etc
            if (e.which == 2 || e.metaKey) { return true; }

            History.pushState({ tabId: BAMBOO.escapeIdToJQuerySelector($this.attr('id')) }, title, url);
            e.preventDefault();
        }).each(listenForPotentialTabLinksInContent);

        $(window).bind('statechange', function () {
            var State = History.getState(),
                url = State.url,
                tabId = State.data.tabId,
                $tab = $('#' + tabId);

            if (request && request.readyState < 4) {
                request.abort();
            }

            $tabsContainer.addClass('loading');
            $tab.parent().addClass(activeClass).siblings().removeClass(activeClass);

            $(document).trigger('statechange.historyxhr', [ url ]);

            if ($planNavigator.length) {
                // Update urls in plan navigator
                if (activeJobKey) {
                    // Update job urls
                    $jobs.each(function () {
                        var $li = $(this),
                            $a = $li.children('a').last(),
                            jobKey = $li.data('jobKey');

                        $a.attr('href', (jobKey == activeJobKey ? url : url.replace(activeJobKey, jobKey)));
                    });
                } else {
                    // Update plan url
                    // $plan.children('a').attr('href', url);
                }
            }
            
            request = $.ajax({
                cache: false,
                url: url,
                beforeSend: function (jqXHR) {
                    jqXHR.setRequestHeader('X-History-XHR', true);
                },
                success: function (data, textStatus, jqXHR) {
                    var title, planURL, jobURL;

                    // If no data is returned, or an entire web page, go directly to that page for normal error handling
                    if (!$.trim(data) || /<html/i.test(data)) {
                        return window.location = url;
                    }

                    $content.html(data);

                    title = jqXHR.getResponseHeader('X-Page-Title') || $.trim($content.find('title,.document-title').remove().filter(':first').text());
                    if (title) {
                        document.title = title;
                        try {
                            document.getElementsByTagName('title')[0].innerHTML = document.title.replace('<','&lt;').replace('>','&gt;').replace(' & ',' &amp; ');
                        }
                        catch ( Exception ) { }
                    }

                    planURL = jqXHR.getResponseHeader('X-Plan-URL');
                    jobURL = jqXHR.getResponseHeader('X-Job-URL');
                    if ($planNavigator.length) {
                        if (activeJobKey && planURL) {
                            // Update plan url (url is returned with current job key, replace it with the plan key)
                            // $plan.children('a').attr('href', contextPath + planURL.replace(activeJobKey, planKey));
                        } else if (!activeJobKey && jobURL) {
                            // Update job urls (url is returned with plan key, replace it with the appropriate job key)
                            $jobs.each(function () {
                                var $li = $(this),
                                    $a = $li.children('a').last(),
                                    jobKey = $li.data('jobKey');

                                $a.attr('href', contextPath + jobURL.replace(planKey, jobKey));
                            });
                        }
                    }

                    $tabsContainer.removeClass('loading');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    if (textStatus != 'abort') {
                        return window.location = url;
                    }
                }
            });
        });
    });
})(window);