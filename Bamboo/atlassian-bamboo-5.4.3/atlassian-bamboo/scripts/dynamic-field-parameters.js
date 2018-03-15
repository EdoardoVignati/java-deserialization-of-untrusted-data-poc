BAMBOO.DynamicFieldParameters = (function ($) {
    var handleOnSelectShowHideSelector = ".handleOnSelectShowHide",
        handleDynamicDescriptionSelector = ".handleDynamicDescription",
        // lifted straight from jQuery, just changed the order
        fxAttrs = [
            // height animations
            [ "height", "marginTop", "marginBottom", "paddingTop", "paddingBottom" ],
            // opacity animations
            [ "opacity" ],
            // width animations
            [ "width", "marginLeft", "marginRight", "paddingLeft", "paddingRight" ]
        ],
        // object to handle the methods we make 'public'
        ret = {};

    /**
     * Handles form select field dynamic description updating
     */
    function handleDynamicSelectDescription() {
        var $select = $(this);

        $select.nextAll(".description").html($select.find("option:selected").attr("data-dynamic-select-description") || null);
    }

    /**
     * Syncs form display states for handleOnSelectShowHide fields and select field dynamic description updating
     * @param context (optional) - DOM Element, Document or jQuery object to use as context
     * @param animate (optional) - force transition animations
     */
    ret.syncFieldShowHide = function (context, animate) {
        if (typeof context === "boolean") {
            animate = context;
            context = null;
        }
        $(".handleOnSelectShowHide", context).each(function () { handleOnSelectShowHide.call(this, animate); });
        $(handleDynamicDescriptionSelector, context).each(handleDynamicSelectDescription);
    };

    /**
     * Runs on a change of a field
     */
    function handleOnSelectShowHide(e) {
        var $el = $(this),
            dependsOnSelector = (".dependsOn" + $el.prop("name").replaceAll(".", "\\.")),
            switchValue = getSwitchValue($el),
            showPattern, hidePattern,
            useAnimations = (e instanceof jQuery.Event || (typeof e === "boolean" && e)),
            showFn = !useAnimations ? jQuery.fn.show : function () {
                this.animate(genFx("show", 2), function () { $(this).show(); });
            },
            hideFn = !useAnimations ? jQuery.fn.hide : function () {
                this.animate(genFx("hide", 2), function () { $(this).hide(); });
            };

        if (!(!switchValue && $el.is(":radio"))) {
            showPattern = "showOn" + switchValue;
            hidePattern = "showOn__" + switchValue;

            $el.closest("form").find(dependsOnSelector).each(function () {
                var $deps = $(this);

                if ($deps.prop("class").indexOf("showOn__") != -1) {
                    if ($deps.hasClass(hidePattern)) {
                        hideFn.call($deps);
                    } else {
                        showFn.call($deps);
                    }
                } else {
                    if ($deps.hasClass(showPattern)) {
                        showFn.call($deps);
                    } else {
                        hideFn.call($deps);
                    }
                }
                if ($deps.hasClass(hidePattern)) {
                    hideFn.call($deps);
                }
            });
        }
    }

    /**
     * JSOn listData looks like:
     *
     *  [data: [{value: 'key1', text: 'name for the screen', supportedValues: ['dependencyKey1', 'dependencyKey2']},
     *   {value: 'key2', text: "name 2", supportedValues: ['dependencyKey1']}]]
     *
     * If supportedValues is empty it will be shown for all selections in selParentJQ.
     *
     * @param selParentJQ - the select list that the your data depends on
     * @param selToMutateJQ - the select list that you want to mutate based on the contents of the selDependency
     * @param listDataJson - the json containing all information required to generate the selToMutate
     */
    ret.mutateSelectListContent = function (selParentJQ, selToMutateJQ, listDataJson) {
        var selToMutate = selToMutateJQ[0],
            currentSelectedValue = selToMutateJQ.val(),
            switchValue = getSwitchValue(selParentJQ),
            listData = listDataJson.data;

        //wipe existing items
        selToMutate.options.length = 0;

        // go through selToMutate check if each item is in allowed Items, if not remove?
        for (var i = 0; i<listData.length; i++){
            var value = listData[i].value,
                text = listData[i].text,
                allowedOptions = listData[i].supportedValues,
                show = allowedOptions === null || allowedOptions.length <= 0 || !switchValue;

            if (!show) {
                for (var x = 0; x < allowedOptions.length; x++) {
                    var allowedOption = allowedOptions[x];
                    if (switchValue === allowedOption) {
                        show = true;
                        break;
                    }
                }
            }

            if (show) {
                selToMutate.options[selToMutate.options.length] = new Option(text, value, false, value === currentSelectedValue);
            }
        }

        // make sure we update the dependents of the mutated list.
        handleOnSelectShowHide.call(selToMutate)
    };

    function getSwitchValue($el) {
        if ($el.is("select") && $el.prop("selectedIndex") > -1) {
            var $opt = $el.find("option:selected").filter(":first"),
                optClass = $opt.prop("class");

            //  Special uiSwitch* class prefix
            if (optClass.indexOf('uiSwitch') != -1) {
                return optClass.substring(optClass.lastIndexOf("uiSwitch") + 8);
            } else {
                return $el.val();
            }
        } else if ($el.is(":radio") || $el.is(":checkbox")) {
            return ($el.is(":checked") ? $el.val() : false);
        } else {
            return $el.val();
        }
    }

    ret.selectFirstFieldOfForm = function (formId) {
        var $form = $("#" + formId),
            $firstError = $form.find(":input:visible:enabled.errorField:first").focus();

        if (!$firstError.length) {
            $form.find(":input:visible:enabled:first").focus();
        }
    };

    /** Generate parameters to create a standard animation
     * This has been lifted straight from jQuery
     * @param type
     * @param num
     */
    function genFx( type, num ) {
        var obj = {};

        jQuery.each( fxAttrs.concat.apply([], fxAttrs.slice(0,num)), function() {
            obj[ this ] = type;
        });

        return obj;
    }

    // handleOnSelectShowHide functionality
    $(document)
        .delegate('input' + handleOnSelectShowHideSelector, 'click', handleOnSelectShowHide)
        .delegate('select' + handleOnSelectShowHideSelector, 'change', handleOnSelectShowHide)
        .delegate(handleDynamicDescriptionSelector, 'change', handleDynamicSelectDescription);

    $(function () {
        ret.syncFieldShowHide();
    });

    return ret;
})(jQuery);