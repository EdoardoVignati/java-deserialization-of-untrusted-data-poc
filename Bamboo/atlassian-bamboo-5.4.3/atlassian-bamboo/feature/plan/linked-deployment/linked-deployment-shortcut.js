(function ($, BAMBOO) {
    BAMBOO.linkedDeploymentShortcut = (function () {
        var defaults = {
                triggerSelector: null,
                relatedProjectsUrl: null,
                dialogContentTemplate: null
            },
            options;
        return {
            init: function (options) {
                $.extend(true, defaults, options);

                AJS.InlineDialog($(options.triggerSelector), "deployment-shortcut-dialog",
                    function ($container, trigger, showPopup) {
                        var planKey = $(trigger).data("planKey");
                        $container.html(widget.icons.icon({type: 'loading'}));

                        $.ajax({
                            url: options.relatedProjectsUrl + planKey,
                            data: { decorator: 'nothing', confirm: true },
                            dataType: 'json',
                            contentType: 'application/json',
                            cache: false
                        }).success(function (data) {
                            var content = options.dialogContentTemplate({'linkedDeploymentProjects': data});
                            $container.empty().append(content);
                        }).error(function (jqXHR, textStatus, errorThrown) {
                                var $message = BAMBOO.generateErrorMessages(jqXHR, textStatus, errorThrown);
                                if (!$message) {
                                    $message = $('<p/>').append(AJS.I18n.getText('deployment.plan.crosslink.error'));
                                }
                                $container.empty().append($message);
                        });

                        showPopup();
                        return false;
                    }
                );
            }
        }
    }());
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));