(function ($, BAMBOO) {
    BAMBOO.TELEMETRY = (function () {
        var refreshDelay = 30000,
            refreshDelayOnError = 30000,
            wallboardSelector = "#wallboard",
            $wallboard = null,
            refresh = function () {
                $.ajax({
                    url: document.location.href,
                    cache: false,
                    data: {
                        decorator: 'nothing',
                        confirm: 'true'
                    },
                    dataType: 'html',
                    error: function () {
                        message.show("An error occurred while refreshing the wallboard.<br>Trying again soon&hellip;", "");
                        setTimeout(refresh, refreshDelayOnError);
                    },
                    success: function (data) {
                        var $response = $(data),
                            $serverMsg = $response.filter("#" + message.messageId);

                        if ($serverMsg.length) {
                            message.show($serverMsg.html(), $serverMsg.attr("class"));
                        } else {
                            message.clear();
                        }
                        $wallboard.html($response.filter(wallboardSelector).html());
                        addIndicators();
                        setTimeout(refresh, refreshDelay);
                    }
                });
            },
            spinners = [],
            addIndicators = function () {
                clearSpinners();
                $(".indicator").each(function () {
                    var $this = $(this), paper;

                    if ($this.hasClass("building")) {
                        spinners.push(spinner(this.id, 10, 15, 10, 4, "#FFF"));
                    } else {
                        paper = new Raphael(this.id, 38, 38);
                        paper.path("M16,1.466C7.973,1.466,1.466,7.973,1.466,16c0,8.027,6.507,14.534,14.534,14.534c8.027,0,14.534-6.507,14.534-14.534C30.534,7.973,24.027,1.466,16,1.466zM16,27.533C9.639,27.533,4.466,22.359,4.466,16C4.466,9.64,9.639,4.466,16,4.466c6.361,0,11.533,5.173,11.533,11.534C27.533,22.361,22.359,27.533,16,27.533zM15.999,5.125c-0.553,0-0.999,0.448-0.999,1v9.221L8.954,17.99c-0.506,0.222-0.736,0.812-0.514,1.318c0.164,0.375,0.53,0.599,0.915,0.599c0.134,0,0.271-0.027,0.401-0.085l6.626-2.898c0.005-0.002,0.009-0.004,0.013-0.006l0.004-0.002c0.015-0.006,0.023-0.02,0.037-0.025c0.104-0.052,0.201-0.113,0.279-0.195c0.034-0.034,0.053-0.078,0.079-0.117c0.048-0.064,0.101-0.127,0.13-0.204c0.024-0.06,0.026-0.125,0.038-0.189C16.975,16.121,17,16.064,17,15.999V6.124C17,5.573,16.552,5.125,15.999,5.125z").attr({ fill: "#FFF", stroke: "none" }).attr({ opacity: 0.9 }).scale(1.2, 1.2, 0, 0);
                    }
                });
            },
            clearSpinners = function () {
                while (spinners.length) {
                    spinners.shift()();
                }
            },
            message = {
                blanketId: "message-blanket",
                messageId: "message",
                show: function (messageHtml, messageClass) {
                    var $blanket = $("#" + message.blanketId),
                        $message = $("#" + message.messageId);

                    if (!$blanket.length) {
                        $blanket = $("<div/>", { id: message.blanketId }).appendTo(document.body);
                    }
                    if (!$message.length) {
                        $message = $("<div/>", { id: message.messageId, html: messageHtml, "class": messageClass }).insertAfter($blanket);
                    } else {
                        $message.html(messageHtml).attr("class", messageClass);
                    }

                    return $message;
                },
                clear: function () {
                    $("#" + message.blanketId + ", #" + message.messageId).remove();
                }
            };

        $(document).delegate('.build', 'click', function (e) {
            var $details = $(this).find('.details-ext');

            $details[( $details.is(':visible') ? 'fadeOut' : 'fadeIn' )]();
        });

        $(function ($) {
            $wallboard = $(wallboardSelector);
            addIndicators();
            setTimeout(refresh, refreshDelay);
        });
    })();
}(jQuery, window.BAMBOO = (window.BAMBOO || {})));