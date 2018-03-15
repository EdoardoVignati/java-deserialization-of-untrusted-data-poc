(function($) {
    var BAMBOO = window.BAMBOO || {};
    BAMBOO.STAGES = {};
    BAMBOO.STAGES.manualStagesSelection = (function () {
        return {
            init: function() {
               $("#stageContainer").delegate("input:checkbox", "click", function() {
                    var $checkbox = $(this),
                        checked = $checkbox.is(":checked"),
                        $selectedStage = $("#selectedStage"),
                        prevManualFound = false;

                    if (checked) {
                        $selectedStage.val($checkbox.val());
                    } else {
                        $selectedStage.val("");
                    }

                    $checkbox.parent().closest(".checkbox").toggleClass("selected", checked).prevAll(".checkbox").each(function () {
                        var $checkboxContainer = $(this),
                            $checkbox = $checkboxContainer.children("input:checkbox"),
                            isManual = $checkboxContainer.hasClass("manual");
                        if (checked) {
                            $checkboxContainer.addClass("selected");
                            if (isManual) {
                                $checkbox.attr("checked", "checked").attr("disabled", "disabled");
                            }
                        } else {
                            if (isManual && !prevManualFound) {
                                $selectedStage.val($checkbox.val());
                                $checkbox.removeAttr("disabled");
                                prevManualFound = true;
                            }
                        }
                    }).end().nextAll(".checkbox").each(function () {
                        var $checkboxContainer = $(this);
                        if ($checkboxContainer.hasClass("manual")) {
                            return false; // breaks the loop
                        } else {
                            $checkboxContainer.toggleClass("selected", checked);
                        }
                    });
                });
            }
        }
    })();
})(jQuery);
