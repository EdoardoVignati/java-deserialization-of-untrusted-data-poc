//  ######
//  #     #  ######  #####   #####   ######   ####     ##     #####  ######  #####
//  #     #  #       #    #  #    #  #       #    #   #  #      #    #       #    #
//  #     #  #####   #    #  #    #  #####   #       #    #     #    #####   #    #
//  #     #  #       #####   #####   #       #       ######     #    #       #    #
//  #     #  #       #       #   #   #       #    #  #    #     #    #       #    #
//  ######   ######  #       #    #  ######   ####   #    #     #    ######  #####

// Constants
var BAMBOO_DASH_DISPLAY_TOGGLES = "bamboo.dash.display.toggles",
    BAMBOO_EVENT_ON_DASHBOARD_RELOADED = "BAMBOO_EVENT_ON_DASHBOARD_RELOADED";

window.BAMBOO = (window.BAMBOO || {});
BAMBOO.reloadDashboardTimeout = 20;
//
// Display the given help page in a separate window
//
function openHelp(helpPage) {
    window.open(helpPage, 'manualPopup', 'width=770,height=550,scrollbars=yes,status=yes,resizable=yes');
}

function reloadThePage() {
    window.location.reload(true);
}

function redirectAfterReturningFromDialog(response) {
    if (response.redirectUrl) {
        window.location = AJS.contextPath() + response.redirectUrl;
    } else {
        reloadThePage();
    }
}

function isDefinedObject(reference) {
    return (typeof reference !== "undefined") && (reference !== null);
}

if (!jQuery.isNumeric) {
    jQuery.isNumeric = function (n) {
        return !isNaN(parseFloat(n)) && isFinite(n);
    };
}

/**
 * Any href clicked with rel=help (e.g. our help bubbles) will open in new window.
 * Any element with id=addPlanLabel will trigger the edit labels dialog
 * Applies to all of Bamboo.
**/
AJS.$(document).delegate("a[rel~='help']", "click", function (e) {
    var $this = AJS.$(this);
    e.preventDefault();
    if ($this.data('useHelpPopup')) {
        openHelp(this.href);
    } else {
        window.open(this.href);
    }
});


/**
 * Workaround for Cancel links in Dialog which append a hash to URL by default
 */
AJS.$("a.button-panel-link[href='#']").live("click", function (e) {
    e.preventDefault();
});

/**
 * AJS.BambooDialog
 */
AJS.BambooDialog = function(options, onSubmitCallback, onCancelCallback) {
    var dialog;
    options = options || {};
    options = jQuery.extend({}, options, {
        keypressListener: function(e) {
            if (e.which == jQuery.ui.keyCode.ESCAPE) {
                 if (isDefinedObject(onCancelCallback)) {
                     onCancelCallback(dialog);
                 } else {
                     dialog.remove();
                 }
            } else if (e.which == jQuery.ui.keyCode.ENTER && isDefinedObject(onSubmitCallback)) {
                onSubmitCallback(dialog);
                if (options.submitMode && options.submitMode == "ajax") {
                    e.preventDefault();
                }
            }
        }
    });
    dialog = new AJS.Dialog(options);
    return dialog;
};
AJS.Dialog.prototype.addHelpText = function (template, args) {
    if (!template) {
        // Don't do anything if there is no text to add.
        // This stops us printing 'undefined'.
        return;
    }

    var text = template;
    if (args) {
        text = AJS.template(template).fill(args).toString();
    }

    var page = this.page[this.curpage];
    if (!page.buttonpanel) {
        page.addButtonPanel();
    }

    // The text may include html i.e. links or strongs
    var tip = AJS.$("<div class='dialog-tip'></div>").html(text);
    page.buttonpanel.append(tip);
    tip.find("a").click(function() {
        window.open(this.href, '_blank').focus();
        return false;
    });
};
AJS.Dialog.prototype.updateHeightProperly = function () {
    this.updateHeight();
    this.getCurrentPanel().body.css('height', '');
};

String.prototype.replaceAll = function(pcFrom, pcTo) {
    var MARKER = "js___bmbo_mrk",
        i = this.indexOf(pcFrom),
        c = this;
    while (i > -1) {
        c = c.replace(pcFrom, MARKER);
        i = c.indexOf(pcFrom);
    }

    i = c.indexOf(MARKER);
    while (i > -1) {
        c = c.replace(MARKER, pcTo);
        i = c.indexOf(MARKER);
    }

    return c;
};


if (!jQuery.generateId) {
  jQuery.generateId = function() {
    return arguments.callee.prefix + arguments.callee.count++;
  };
  jQuery.generateId.prefix = 'jq-';
  jQuery.generateId.count = 0;

  jQuery.fn.generateId = function() {
    return this.each(function() {
      this.id = jQuery.generateId();
    });
  };
}

// Cookie handling functions

function saveToConglomerateCookie(cookieName, name, value)
{
    var cookieValue = getCookieValue(cookieName);
    cookieValue = addOrAppendToValue(name, value, cookieValue);

    saveCookie(cookieName, cookieValue, 365);
}

function readFromConglomerateCookie(cookieName, name, defaultValue)
{
    var cookieValue = getCookieValue(cookieName);
    var value = getValueFromCongolmerate(name, cookieValue);
    if (value != null)
    {
        return value;
    }

    return defaultValue;
}

function eraseFromConglomerateCookie(cookieName, name)
{
    saveToConglomerateCookie(cookieName, name, "");
}

function getValueFromCongolmerate(name, cookieValue)
{
    var newCookieValue = null;
    // a null cookieValue is just the first time through so create it
    if (cookieValue == null)
    {
        cookieValue = "";
    }
    var eq = name + "-";
    var cookieParts = cookieValue.split('|');
    for (var i = 0; i < cookieParts.length; i++)
    {
        var cp = cookieParts[i];
        while (cp.charAt(0) == ' ')
        {
            cp = cp.substring(1, cp.length);
        }
        // rebuild the value string exluding the named portion passed in
        if (cp.indexOf(name) == 0)
        {
            return cp.substring(eq.length, cp.length);
        }
    }
    return null;
}

//either append or replace the value in the cookie string
function addOrAppendToValue(name, value, cookieValue)
{
    var newCookieValue = "";
    // a null cookieValue is just the first time through so create it
    if (cookieValue == null)
    {
        cookieValue = "";
    }

    var cookieParts = cookieValue.split('|');
    for (var i = 0; i < cookieParts.length; i++)
    {
        var cp = cookieParts[i];

        // ignore any empty tokens
        if (cp != "")
        {
            while (cp.charAt(0) == ' ')
            {
                cp = cp.substring(1, cp.length);
            }
            // rebuild the value string exluding the named portion passed in
            if (cp.indexOf(name) != 0)
            {
                newCookieValue += cp + "|";
            }
        }
    }

    // always append the value passed in if it is not null or empty
    if (value != null && value != '')
    {
        var pair = name + "-" + value;
        if ((newCookieValue.length + pair.length) < 4020)
        {
            newCookieValue += pair;
        }
    }
    return newCookieValue;
}

function getCookieValue(name, defaultString)
{
    var eq = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++)
    {
        var c = ca[i];
        while (c.charAt(0) == ' ')
        {
            c = c.substring(1, c.length);
        }
        if (c.indexOf(eq) == 0)
        {
            return c.substring(eq.length, c.length);
        }
    }

    return defaultString;
}

function saveCookie(name, value, days)
{
    var ex;
    if (days)
    {
        var d = new Date();
        d.setTime(d.getTime() + (days * 24 * 60 * 60 * 1000));
        ex = "; expires=" + d.toGMTString();
    }
    else
    {
        ex = "";
    }
    document.cookie = name + "=" + value + ex + ";path=" + (!AJS.contextPath().length ? "/" : AJS.contextPath());
}

/*
Reads a cookie. If none exists, then it returns and
*/
function readCookie(name, defaultValue)
{
    var cookieVal = getCookieValue(name);
    if (cookieVal != null)
    {
        return cookieVal;
    }

    // No cookie found, then save a new one as on!
    if (defaultValue)
    {
        saveCookie(name, defaultValue, 365);
        return defaultValue;
    }
    else
    {
        return null;
    }
}

function eraseCookie(name)
{
    saveCookie(name, "", -1);
}

function toggleOn(e, toggleGroup_id)
{
    var onToggle = document.getElementById(toggleGroup_id + "_toggler_on");
    var offToggle = document.getElementById(toggleGroup_id + "_toggler_off");
    var target = document.getElementById(toggleGroup_id + "_target");
    onToggle.style.display = 'block';
    offToggle.style.display = 'none';
    target.style.display = 'block';
    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, null);
}

function toggleOff(e, toggleGroup_id)
{
    var onToggle = document.getElementById(toggleGroup_id + "_toggler_on");
    var offToggle = document.getElementById(toggleGroup_id + "_toggler_off");
    var target = document.getElementById(toggleGroup_id + "_target");
    onToggle.style.display = 'none';
    offToggle.style.display = 'block';
    target.style.display = 'none';
    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, '0');
}

function restoreTogglesFromCookie(toggleGroup_id)
{
    var elem = document.getElementById(toggleGroup_id + "_target");
    if (elem)
    {
        if (readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, null) == '0')
        {
            toggleOff(null, toggleGroup_id);
        }
        else
        {
            toggleOn(null, toggleGroup_id);
        }
    }
}

// Forms JS
function toggleContainingCheckbox(e)
{
    if (e && e.target.tagName == "INPUT")
    {
        return true;
    }

    AJS.$(this).find("input:checkbox").each(function(){
        this.checked = !this.checked;
    });

    return true;
}

function toggleIconOff(dom)
{
    dom.src = dom.src.replace('_on.', '_off.');
}

function toggleIconOn(dom)
{
    dom.src = dom.src.replace('_off.', '_on.');
}

/*
*   For user picker - when you click "Check All' all the select boxes are changed
*/
    var selectedBoxes = [];

    function setCheckboxes()
    {
        var numelements = document.selectorform.elements.length;
        var item0 = document.selectorform.elements[0];
        var item1;

        for (var i=1 ; i < numelements ; i++)
        {
            item1 = document.selectorform.elements[i];
            item1.checked = item0.checked;
            if (!selectedBoxes[item1.name])
                selectedBoxes[item1.name] = [];
            selectedBoxes[item1.name][item1.value] = item1.checked;
        }
    }

/*
*  For User Picker - checkboxes are named after users so by compiling a list of all selected checkboxes
*   we have a list of users (comma seperated)
*/
    function getEntityNames()
    {
        var numelements = document.selectorform.elements.length;
        var item;
        var checkedList = "";

        var sep = "";
        for (var i = 0 ; i < numelements ; i++)
        {
            item = document.selectorform.elements[i];
            if (item != null && item.type == "checkbox" && item.name != "all" && item.checked == true)
            {
                var itemValue = item.value;
                itemValue = itemValue.replace(/\\/g, "\\\\").replace(/,/g, "\\,");
                checkedList  = checkedList + sep + itemValue;
                sep = ", ";
            }
        }

        return checkedList;
    }

/*
*   For User Picker - takes comma seperated list of users and places them in specified field.
*/
   function addUsers(commaDelimitedUserNames, fieldID, multiSelect)
    {
        var element = document.getElementById(fieldID);
        var currentUsers = element.value;
        if (!multiSelect) {
            element.value = commaDelimitedUserNames;
        } else if (currentUsers != null && currentUsers != ""){
            element.value = currentUsers + ", " + commaDelimitedUserNames;
        } else {
            element.value = commaDelimitedUserNames;
        }
    }

var STATUS_PREFIX = 'statusSection';
var REASON_PREFIX = 'reasonSummary';
var DURATION_PREFIX = 'durationSummary';
var LAST_BUILT = 'lastBuiltSummary';
var TESTCOUNT_PREFIX = 'testSummary';
var LATEST_BUILD_PREFIX = 'latestBuild';
var PLAN_PROPS = [LATEST_BUILD_PREFIX, REASON_PREFIX, DURATION_PREFIX, TESTCOUNT_PREFIX, LAST_BUILT];

function updatePlan(plan, toHide, toShow)
{
    try
    {
        var planKey = plan.planKey;

        //the following for loops have len initialised as such for improved performance
        for (var i = 0, len = PLAN_PROPS.length; i < len; i++)
        {
            var propPrefix =  PLAN_PROPS[i];
            var elem = AJS.$("#" + propPrefix + planKey);
            if (LATEST_BUILD_PREFIX == propPrefix)
            {
                // Update the status when first item and clear the existing classes on this element

                elem.closest(".planKeySection").attr('class', 'planKeySection ' + plan.statusClass);
            }
            elem.html(plan[propPrefix]);
        }

        AJS.$("#" + STATUS_PREFIX + planKey).find(".icon").each(function(){
            if (!AJS.$(this).hasClass(plan.statusIconClass)){
                AJS.$(this).removeClass().addClass("icon " + plan.statusIconClass).attr("title", plan.statusText);
            }
        });

        //Update link
        var link = AJS.$("a#" + STATUS_PREFIX + planKey);
        if (link.length) {
            if (plan.lastResultKey != null) {
                link.attr("href", AJS.contextPath() + "/browse/" + plan.lastResultKey);
            } else {
                link.attr("href", AJS.contextPath() + "/browse/" + planKey);
            }
        }

        // Update favourites
        var faves = AJS.$('#favouriteIconFor_' + planKey);
        for (var i = 0, len = faves.length; i < len; i++)
        {
            var fave = faves.get(i);
            if (plan.favourite)
            {
                toggleIconOn(fave);
            }
            else
            {
                toggleIconOff(fave);
            }
        }

        if (plan.suspendedFromBuilding) {
            toShow.push('#resumeBuild_' + planKey);
            toHide.push( '#stopSingleBuild_' + planKey, '#stopMultipleBuilds_' + planKey, '#manualBuild_' + planKey);
        } else {
            toHide.push('#resumeBuild_' + planKey);
            if (plan.allowStop) {
                toHide.push('#manualBuild_' + planKey);
                if (plan.numberOfCurrentlyBuildingPlans > 1) {
                    toHide.push('#stopSingleBuild_' + planKey);
                    toShow.push('#stopMultipleBuilds_' + planKey);
                } else {
                    toShow.push('#stopSingleBuild_' + planKey);
                    toHide.push('#stopMultipleBuilds_' + planKey);
                }
            } else {
                toHide.push('#stopSingleBuild_' + planKey, '#stopMultipleBuilds_' + planKey);
                toShow.push('#manualBuild_' + planKey);
            }
        }
    } catch(ex) {
        //alert(ex);
        console.warn(ex);
    }
}

function updatePlans(sinceSystemTime) {
    // Make the call to the server for JSON data
    if (!sinceSystemTime) sinceSystemTime = 0;

    var $showMoreTrigger = AJS.$(".show-more-plans");
    var lastProjectKey = $showMoreTrigger.length ? $showMoreTrigger.data("lastProjectKey") : "";

    // Define the callbacks for the asyncRequest
    var timeout,
        panelId = 'dashboardUpdatePlans',
        callbacks = {
            dataType: 'json',
            url:AJS.contextPath() + "/ajax/viewPlanUpdates.action",
            data: { sinceSystemTime: sinceSystemTime,
                    lastProject: lastProjectKey
            },
            success : function (response) {
                if (!BAMBOO.reloadDashboard) return; // do nudda

                // Process the JSON data returned from the server
                try {
                    if (response.plans) {
                        var plans = response.plans,
                            toHide = [], toShow = [];
                        //Using toHide/toShow arrays here and deferring hide/show improved performance 20x,
                        //do not change it without heavy performance testing (on 2000 top level plans) please
                        for (var i = 0, len = plans.length; i < len; i++) {
                            var plan = plans[i];
                            updatePlan(plan, toHide, toShow);
                        }
                        if (toHide.length) {
                            AJS.$(toHide.join(',')).hide();
                        }
                        if (toShow.length) {
                            AJS.$(toShow.join(',')).show();
                        }
                    }
                } catch (x) {
                    console.warn("JSON Parse failed! " + x + "\n", response);
                }

                sinceSystemTime = response ? response.currentTime : 0;

                BAMBOO.panelTimeouts[panelId] = setTimeout(function () { updatePlans(sinceSystemTime); }, BAMBOO.reloadDashboardTimeout * 1000);
                hideAjaxErrorMessage();
                AJS.$("body").trigger(BAMBOO_EVENT_ON_DASHBOARD_RELOADED);
            },
            error : function (XMLHttpRequest) {
                showAjaxErrorMessage(XMLHttpRequest);
            },
            timeout : 60000
        };

    if (typeof BAMBOO.panelTimeouts === "undefined") {
        BAMBOO.panelTimeouts = {};
    } else {
        timeout = BAMBOO.panelTimeouts[panelId];
        clearTimeout(timeout);
    }

    AJS.$.ajax(callbacks);
}

function reloadPanel(id, url, reloadEvery, loadScripts, previousText, callback) {
    var timeout;
    if (typeof BAMBOO.panelTimeouts === "undefined") {
        BAMBOO.panelTimeouts = {};
    } else {
        timeout = BAMBOO.panelTimeouts[id];
        clearTimeout(timeout);
    }
    AJS.$.get(processReloadUrl(url), function(data) {
        var reponseText = data;

        if (!document.getElementById(id)) { return false; } // don't bother updating if the target isn't available to update

        if (!previousText || previousText != reponseText) {
            // only update if the previous response is different
            updateDomObject(reponseText, id, loadScripts, callback);
        }
        if (reloadEvery) {
            BAMBOO.panelTimeouts[id] = setTimeout(function () { reloadPanel(id, url, reloadEvery, loadScripts, reponseText, callback); }, reloadEvery * 1000);
        }
    });
}

function processReloadUrl(url)
{
    if (BAMBOO.buildLastCurrentStatus)
    {
        var indexOfCurrentStatus = url.indexOf("&lastCurrentStatus");
        if (indexOfCurrentStatus != -1)
        {
            url = url.substring(0, indexOfCurrentStatus);
        }

        return url + "&lastCurrentStatus=" + BAMBOO.buildLastCurrentStatus;

    }
    else
    {
        return url;
    }
}

function updateDomObject(html, targetId, loadScripts, callback)
{
    if(typeof html == 'undefined'){
        html = '';
    }
    if(loadScripts !== true){
        AJS.$("#" + targetId).html(html);
        if (AJS.$.isFunction(callback))
        {
            AJS.$("#" + targetId).each(callback);
        }
        return;
    }
    var id = AJS.$.generateId();
    html += '<span id="' + id + '"></span>';

    AJS.$("#" + id).ready(function(){
        var hd = document.getElementsByTagName("head")[0];
        var re = /(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/img;
        var srcRe = /\ssrc=([\'\"])(.*?)\1/i;
        var match;
        while(match = re.exec(html)){
            var srcMatch = match[0].match(srcRe);
            if(srcMatch && srcMatch[2]){
                var s = document.createElement("script");
                s.src = srcMatch[2];
                hd.appendChild(s);
            }else if(match[1] && match[1].length > 0){
                eval(match[1]);
            }
        }
        var el = document.getElementById(id);
        if(el){el.parentNode.removeChild(el);}
    });
    var newHtml = html.replace(/(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/img, '');
    AJS.$("#" + targetId).html(newHtml);

    if (AJS.$.isFunction(callback))
    {
        AJS.$("#" + targetId).each(callback);
    }
    return;
}


function updateInlineSection(url, sectionName)
{
     AJS.$.get(processReloadUrl(url), function(data)
      {
          updateDomObject(data, sectionName, "true", "null");
      });
}


function addConfirmationToLinks() {
    AJS.$(document).on(
        'click',
        '.requireConfirmation',
        function(e) {
            var $el = AJS.$(this);
            var isConfirmed = confirm('Please confirm that you are about to \n' + ($el.attr("title") ? $el.attr("title") : AJS.$.trim($el.text())));
            if (isConfirmed && $el.hasClass("mutative")) {
                e.preventDefault();
                $el.trigger("clickMutativeLink");
            }
            return isConfirmed;
        }
    );
}

/**
 * Build queue related stuff
 */
var buildQueue = function()
{
    AJS.$(document).ready(function() {buildQueue.portletReloadCallback();});

    return {
        /**
         * Shows and hides Build Queue's action panels
         */
        displayActions : function(actionsId)
        {
            var prevActionsId = readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", actionsId);
            AJS.$("#builders").removeClass(prevActionsId);
            AJS.$("#builders").addClass(actionsId);

            saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", actionsId);
        },

        restoreDisplayActionsFromCookie : function()
        {
            this.displayActions(readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", "actions-queueControl"));
        },

        portletReloadCallback : function()
        {
            buildQueue.restoreDisplayActionsFromCookie();
        }
    };
}();


function initCommitsTooltip(targetId, planKey, buildNumber)
{
    AJS.InlineDialog(AJS.$("#" + targetId),
                 targetId,
                 AJS.contextPath() + "/build/ajax/viewBuildCommits.action?buildKey=" + planKey + "&buildNumber=" + buildNumber,
                {onHover: true, fadeTime: 50, hideDelay: 0, showDelay: 100, width: 300, offsetX: 0,offsetY: 10});
}

function initCommentTooltip(targetId, planKey, buildNumber)
{
    var link = AJS.$("#" + targetId);
    AJS.InlineDialog(link,
             targetId,
             AJS.contextPath() + "/build/ajax/viewBuildComments.action?buildKey=" + planKey + "&buildNumber=" + buildNumber,
            {onHover: true, fadeTime: 50, hideDelay: 0, showDelay: 100, width: 300, offsetX: 0,offsetY: 10});
}

/**
 * This function is not mentioned to be used directly but rather via @dj.simpleDialogForm FTL macro defined in dojo.ftl
 *
 * All the input params are also described in the dojo.ftl
 */
function simpleDialogForm(triggerSelector, getDialogBodyUrl, dialogWidth, dialogHeight, submitLabel, submitMode, submitCallback, cancelCallback, header, eventNamespace)
{
    function clearAllErrors(formJQ)
    {
        formJQ.find('.error,.aui-message').remove();
    }

    function addActionError(formJQ, errors)
    {
        formJQ.find(".field-group:first").before(BAMBOO.buildAUIErrorMessage(errors));
    }

    function applyErrors(formJQ, result)
    {
        if (result.fieldErrors) {
            for (var fieldName in result.fieldErrors) {
                BAMBOO.addFieldErrors(formJQ, fieldName, result.fieldErrors[fieldName]);
            }
        }

        if (result.errors) {
            addActionError(formJQ, result.errors);
        }
    }

    /**
     * This is called where callee requests non-ajax submit.
     * 1st phase is to call validation via AJAX using form's action attribute and then submit form in a classical way.
     *
     * @param formJQ  form to be submitted
     */
    function validateSubmitForm(formJQ)
    {
        clearAllErrors(formJQ);

        function validationCallback(result)
        {
            if (result.status.toUpperCase() == "OK")
            {
                formJQ.submit();
            }
            else
            {
               applyErrors(formJQ, result);
            }
        }

        AJS.$.post(formJQ.attr("action"), formJQ.serialize() + '&bamboo.enableJSONValidation=true', validationCallback, "json");
    }

    /**
     * For Ajax submit there's no separate validation phase.
     * Assumption is made that action will validate itself and will return proper JSON response in case of validation errors.
     *
     * @param formJQ          jQuery wrapper for form
     * @param submitCallback
     */
    function ajaxSubmitForm(formJQ, submitCallback)
    {
        clearAllErrors(formJQ);

        function successCallback(result)
        {
            if (result.status.toUpperCase()  == "OK")
            {
                submitCallback(result);
            }
            else
            {
               applyErrors(formJQ, result);
            }
        }

         function errorCallback(result)
        {
            if (result.status == 500)
            {
                addActionError(formJQ, Array("An internal server error has occurred. Please check the logs for more details."));
            }
            else
            {
                addActionError(formJQ, Array("An unknown error has occurred."));
            }
        }

        AJS.$.ajax({
            type: "POST",
            url: formJQ.attr("action"),
            data: formJQ.serialize(),
            success: successCallback,
            error: errorCallback,
            dataType: "json"
        });
    }

    function showDialog(linkElementJQ) {
        var $loading = AJS.$('<span class="icon icon-loading aui-dialog-content-loading" />'),
            $dialogForm = AJS.$("<div id='simpleDialogForm'/>").html($loading),
            setFocus = function () {
                var $firstError = $dialogForm.find(":input:visible:enabled.errorField:first").focus();
                if (!$firstError.length) {
                    $dialogForm.find(":input:visible:enabled:first").focus();
                }
            },
            onSubmitCallback = function(dialog) {
                var formJQ = AJS.$("#simpleDialogForm form");

                if (submitMode == "ajax") {
                    ajaxSubmitForm(formJQ, function(result) {
                        if (AJS.$.isFunction(submitCallback)) {
                            submitCallback(result);
                        }
                        dialog.remove();
                        $dialogForm.html($loading);
                    });
                } else {
                    validateSubmitForm(formJQ);
                }
            },
            onCancelCallback = function(dialog) {
                if (AJS.$.isFunction(cancelCallback)) {
                    cancelCallback();
                }
                dialog.remove();
                $dialogForm.html($loading);
            },
            $popup = new AJS.BambooDialog({width: dialogWidth, height: dialogHeight, submitMode: submitMode}, onSubmitCallback, onCancelCallback);

        $popup.addHeader(header != null ? header : linkElementJQ.attr('title'))
              .addPanel("I am invisible", $dialogForm)
              .addCancel("Cancel", onCancelCallback);

        AJS.$.get(getDialogBodyUrl, function(data) {
            $dialogForm.html(data);
            $popup.addSubmit(submitLabel, onSubmitCallback);
            $popup.getPage(0).button[1].moveLeft();
            setFocus();
            BAMBOO.DynamicFieldParameters.syncFieldShowHide($dialogForm, false);
        });
        $popup.show();
    }

    if (triggerSelector) {
        var namespace = "click";
        if (eventNamespace && eventNamespace.length) {
            namespace += "." + eventNamespace;
        }
        AJS.$(triggerSelector).bind(namespace, function(e) {
            showDialog(AJS.$(this));
            //disable the default behaviour (we don't want link to be followed when we display dialog)
            e.preventDefault();
        });
    } else {
        showDialog(AJS.$(this));
    }

}

/**
 * Asynchronous form handler
 * @param options
 *  - target        String - selector targeting the form
 *  - success       Function - handles JSON response from successful form submission
 *  - cancel        Function - handles what to do when the cancel link is clicked
 *  - formReplaced  Function - is fired after the form is replaced
 *  - $delegator    jQuery Object - where the event handler should be bound
 */
BAMBOO.asyncForm = function (options) {
    var $ = AJS.$,
        defaults = {
            target: null,
            success: null,
            cancel: null,
            formReplaced: null,
            error: null,
            $delegator: $(document),
            resetOnSuccess: false,
            loadingIconInsertionMethod: 'prepend'
        },
        handleSubmit = function (e) {
            var $form = $(this),
                cancelOnClick = function (e) { e.stopPropagation(); };

            e.preventDefault();
            $form.ajaxSubmit({
                data: {
                    "bamboo.successReturnMode": "json",
                    decorator: "nothing",
                    confirm: true
                },
                dataType: "html",
                beforeSerialize: function ($form, options) {
                    var fileInputs = $form.find('input:file').length > 0,
                        mp = 'multipart/form-data',
                        multipart = ($form.attr('enctype') == mp || $form.attr('encoding') == mp);

                    if (options.iframe !== false && (fileInputs || options.iframe || multipart)) {
                        this.data["bamboo.successReturnMode"] = "json-as-html";
                    }
                },
                beforeSubmit: function (formData, $form) {
                    $form
                        .find(".buttons")[options.loadingIconInsertionMethod]('<span class="icon icon-loading"/>')
                        .find('input:submit').prop('disabled', true).end()
                        .find('.cancel').addClass('disabled').on('click', cancelOnClick);
                },
                success: function (data) {
                    var $data, json, messages, warnings;

                    if (typeof data == "object") {
                        // Returned data is JSON
                        json = data;
                    } else {
                        // Returned data is string
                        try {
                            // Try to parse string as JSON
                            json = $.parseJSON(data);
                        }
                        catch (e1) {
                            // Must be HTML
                            $data = $(data);
                            try {
                                // Check if the response only contains a textarea, if so it probably just contains JSON
                                if ($data.length == 1 && !$data.children().length && $data.is("textarea")) {
                                    json = $.parseJSON($data[0].value);
                                }
                            }
                            catch (e2) {}
                        }
                    }

                    if (json) {
                        $form.trigger("asyncform-success", [ json ]);

                        messages = json['messages'];
                        warnings = json['warnings'];
                        if (messages || warnings) {
                            $form.trigger("asyncform-notification", [ messages, warnings ]);
                        }

                        if (options.resetOnSuccess) {
                            $form
                                .find(".buttons").find('.icon-loading').remove().end()
                                .find('input:submit').prop('disabled', false).end()
                                .find('.cancel').removeClass('disabled').off('click', cancelOnClick);
                        }

                        options.success(json);
                    } else if ($data) {
                        $form.trigger("asyncform-replaced", [ $data ]);
                        // Returned data isn't JSON, isn't JSON in a textarea, assume it's straight HTML
                        if (!$data.is("form")) {
                            // Should have been a form, probably IE stripping the form element, will just replace form contents instead
                            $form.html($data);
                        } else {
                            $form.replaceWith($data);
                        }
                        if ($.isFunction(options.formReplaced)) {
                            options.formReplaced($data);
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    $form.trigger("asyncform-error", [ jqXHR, textStatus, errorThrown ]);
                    if ($.isFunction(options.error)) {
                        options.error(jqXHR, textStatus, errorThrown);
                    } else {
                        var $dummy = $('<div />'), $stackTrace;

                        try {
                            $stackTrace = $(jqXHR.responseText).filter('pre');
                        }
                        catch (e) {}

                        if (!$stackTrace || !$stackTrace.length) {
                            $stackTrace = $('<p/>', { text: errorThrown });
                        }

                        AJS.messages.error($dummy, { title: AJS.I18n.getText('error.heading'), body: $stackTrace.wrap('<div/>').parent().html(), closeable: false });
                        $form.replaceWith($dummy.children());
                    }
                }
            });
        },
        handleCancel = function (e) {
            e.preventDefault();
            options.cancel(e);
        };

    options = $.extend(defaults, options);

    if ($.isFunction(options.success)) { // No point in an async form if there's no success callback to handle a successful post
        options.$delegator.undelegate(options.target, "submit.asyncform").delegate(options.target, "submit.asyncform", handleSubmit);
    }

    if ($.isFunction(options.cancel)) {
        options.$delegator.undelegate(options.target + " .cancel", "click.asyncform").delegate(options.target + " .cancel", "click.asyncform", handleCancel);
    }
};

/**
 * Handles form input in dialogs
 * @param options
 *  - trigger       String - selector targeting the element that triggers the popup
 *  - dialogWidth   Number - dialog width
 *  - dialogHeight  Number - dialog height
 *  - success       Function - handles JSON response from successful form submission
 *  - cancel        Function - handles what to do when the cancel link is clicked
 *  - header        String - header for the dialog
 */
BAMBOO.simpleDialogForm = function (options) {
    var defaults = {
        trigger: null,
        dialogWidth: null,
        dialogHeight: null,
        success: null,
        cancel: null,
        header: null,
        help: null
    };
    options = AJS.$.extend(defaults, options);
    var $trigger,
        $loading = AJS.$('<span class="icon icon-loading aui-dialog-content-loading" />'),
        $formContainer = AJS.$('<div class="aui-dialog-content"/>').html($loading),
        dialog,
        setFocus = function () {
            var $firstError = $formContainer.find(":input:visible:enabled.errorField:first").focus();
            if (!$firstError.length) {
                $formContainer.find(":input:visible:enabled:first").focus();
            }
        },
        setupDialogContent = function (html) {
            $formContainer.html(html);
            setupForm($formContainer.find("form"));
            BAMBOO.asyncForm({
                $delegator: $formContainer,
                target: "form",
                success: function (data) {
                    if (AJS.$.isFunction(options.success)) {
                        options.success(data);
                    }
                    dialog.remove();
                    $formContainer.html($loading);
                },
                cancel: function (e) {
                    e.preventDefault();
                    if (AJS.$.isFunction(options.cancel)) {
                        options.cancel(e);
                    }
                    dialog.remove();
                    $formContainer.html($loading);
                },
                formReplaced: setupForm
            });
        },
        setupForm = function ($dialogForm) {
            if (options.help) {
                addHelp();
            }
            setFocus();
            BAMBOO.DynamicFieldParameters.syncFieldShowHide($dialogForm, false);
        },
        showDialog = function () {
            dialog = new AJS.Dialog({
                width: options.dialogWidth,
                height: options.dialogHeight,
                keypressListener: function (e) {
                    if (e.which == jQuery.ui.keyCode.ESCAPE) {
                        dialog.remove();
                        $formContainer.html($loading);
                    }
                }
            });
            var header = options.header ? options.header : $trigger.attr("title");
            if (header) {
                dialog.addHeader(header);
            }
            dialog.addPanel("", $formContainer);

            // $trigger.attr("data-dialog-href") won't be needed once we're on jQuery 1.4.3
            AJS.$.ajax({
                url: $trigger.attr("href") || $trigger.data("dialog-href") ||  $trigger.attr("data-dialog-href"),
                data: { 'bamboo.successReturnMode': 'json', decorator: 'nothing', confirm: true },
                success: setupDialogContent,
                cache: false
            });

            dialog.show();
        },
        addHelp = function () {
            return AJS.$('<div />', {
                'class': 'dialog-tip',
                html: options.help
            }).prependTo($formContainer.find('.buttons-container'));
        };

    if (options.trigger) {
        var namespace = "click";
        if (options.eventNamespace && options.eventNamespace.length) {
            namespace += "." + options.eventNamespace;
        }
        AJS.$(document).undelegate(options.trigger, namespace);
        AJS.$(document).delegate(options.trigger, namespace, function (e) {
            $trigger = AJS.$(this);
            e.preventDefault();
            showDialog();
        });
    } else {
        showDialog();
    }
};

/**
 * Displays confirmation dialog that is consistent in style with simpleDialogForm but with content
 * generated without additional server request.
 */
function simpleConfirmationDialog(dialogWidth, dialogHeight, content, header, submitLabel, cancelLabel, onSubmit, onCancel) {
    var confirmDialog = new AJS.BambooDialog({width: dialogWidth, height: dialogHeight, submitMode: "ajax"}),
            doSubmit = function(dialog)
            {
                if (AJS.$.isFunction(onSubmit)) {
                    onSubmit();
                }
                dialog.remove();
            },
            doCancel = function(dialog)
            {
                if (AJS.$.isFunction(onCancel))
                {
                    onCancel();
                }
                dialog.remove();
            };
    confirmDialog.addHeader(header);

    // @TODO a workaround to some bug... We should revisit this post AUI 2.0 upgrade
    confirmDialog.addPanel("nothing", "nothing");
    confirmDialog.addButton(submitLabel, doSubmit);
    confirmDialog.addCancel(cancelLabel, doCancel);

    confirmDialog.getCurrentPanel().html("<div id='simpleDialogForm'>" + content + "</div>");
    confirmDialog.show();
}

/**
 * General checkbox tree utilities.
 */
var checkboxTree = function() {
    return {
        DONT_ENABLE_PARENT_ON_ALL_CHILDREN_ENABLED : 1 << 0,
        DISABLE_CHILDREN_ON_PARENT_CHECKED : 1 << 1,
        /**
         * Cascade state of a parent checkbox to collection of children checkboxes.
         * @param jqParent    parent checkbox (jQuery object)
         * @param jqChildren  children checkboxes (jQuery object)
         */
        cascadeToChildren : function(jqParent, jqChildren, options) {
            if (jqParent.is(":checked")) {
                jqChildren.attr("checked", "checked");
            } else {
                jqChildren.removeAttr("checked");
            }
            if (options & this.DISABLE_CHILDREN_ON_PARENT_CHECKED) {
                if (jqParent.is(":checked")) {
                    jqChildren.attr("disabled", "disabled");
                } else {
                    jqChildren.removeAttr("disabled");
                }
            }
        },

        /**
         * Propagate state of children checkboxes to parent checkbox.
         * @param jqParent    parent checkbox (jQuery object)
         * @param jqChildren  children checkboxes (jQuery object)
         * @param options     options that modify default behavior
         */
        propagateToParent : function(jqParent, jqChildren, options) {
            if (jqChildren.is(":not(:checked)")) {
                jqParent.removeAttr("checked");
            } else {
                if (!(options & this.DONT_ENABLE_PARENT_ON_ALL_CHILDREN_ENABLED))
                {
                    jqParent.attr("checked", "checked");
                }
            }
        }
    };
}();

function enableShowSnapshotsForMaven2Dependencies(showAllSelector, showOnlySnapshotsSelector, tableSelector, hasSnapshots)
{
    AJS.$(document).ready(function() {
        var showAllLink = AJS.$(showAllSelector);
        var showOnlySnapshotsLink = AJS.$(showOnlySnapshotsSelector);
        var table = AJS.$(tableSelector);

        showAllLink.click(function() {
            showOnlySnapshotsLink.show();
            showAllLink.hide();
            AJS.$('.gav-tbody-releases').show();
        });

        showOnlySnapshotsLink.click(function() {
            showAllLink.show();
            showOnlySnapshotsLink.hide();
            AJS.$('.gav-tbody-releases').hide();
        });

        if (hasSnapshots) {
            showOnlySnapshotsLink.click();
        } else {
            showAllLink.hide();
            showOnlySnapshotsLink.hide();
        }
    });
}

function removeError(errorNumber)
{
    var removeErrorForm = window.opener.AJS.$('#removeErrorHiddenForm_' + errorNumber);
    removeErrorForm.submit();
    window.close();
}

function addAliasSubmitCallback(result) {
    AJS.$("select.selectAlias").append(AJS.$("<option />", { text: result.aliasName, selected: "selected", val: result.aliasId }))
                               .val(result.aliasId);
}

/**
 * Checks if any forms on the page need a submit on change hook.
 */
AJS.$(function($){
    $(".submitOnChange").change(function(){ $(this).closest("form").submit(); });
});

/**
 * Current Activity screen
 */
var CurrentActivity = {
    // Default options
    options: {
        contextPath: null,
        getBuildsUrl: null,
        viewAgentUrl: null,
        reorderBuildUrl: null,
        stopBuildUrl: null,
        manageElasticInstancesUrl: null,
        emptyQueueText: null,
        emptyBuildingText: null,
        cancellingBuildText: null,
        cancelBuildText: null,
        queueOutOfDateText: null,
        canBuildElastically: null,
        canBuildElasticallyAdmin: null,
        fetchingBuildData: null,
        hasAdminPermission: false,
        caParent: null,
        buildingParent: null,
        queueParent: null,
        activityStream: null,
        agentSummary: null
    },
    updateTimeout: null, // ID of timeout which determines when the data will be next fetched from the server
    building: null, // jQuery object referring to the list holding the currently building builds (set on init)
    queue: null, // jQuery object referring to the list holding the queued builds (set on init)
    noBuilding: null, // jQuery object referring to the message shown when there are no currently building builds (set on init)
    noQueued: null, // jQuery object referring to the message shown when there are no queued builds (set on init)
    loadingBuilding: null, // jQuery object referring to the loading indicator shown while currently building data is being fetched the first time (set on init)
    loadingQueued: null, // jQuery object referring to the loading indicator shown while queue data is being fetched the first time (set on init)
    queueOutOfDate: null, // jQuery object referring to the message shown when the queue order has been updated remotely and is not reflected locally (set on init)
    updateTimestamp: null, // Timestamp (represented as milliseconds since the Unix epoch) that the builds were last updated
    isBeingSorted: false, // Is the queue currently being sorted?
    disabledStopHTML: '', // HTML to replace the stop button with if it's disabled (set on init)
    /**
     * Generates a nice, readable string of Agents that the Plan can build on
     * @param executableAgents - Array of Agent objects
     * @returns {String} A readable sentence containing the list of agents
     */
    generateBuildableAgentsText: function (executableAgents) {
        var agentNames = [];

        for (var i = 0; i < executableAgents.length; i++) {
            agentNames.push(executableAgents[i].name);
        }
        return "Can build on " + agentNames.join(", ");
    },
    /**
     * Generates the list item
     * @param build - Build object
     * @returns {Object} containing the list item or false if no list item is built (would require build.status to be something other than BUILDING or QUEUED)
     */
    generateListItem: function (build) {
        var ca = CurrentActivity,
            o = ca.options,
            el = "";

        if (build.hasReadPermission) {
            var masterName = build.isBranch ? build.planName.split(" - ", 2)[1] + ' &rsaquo; <span class="aui-icon aui-icon-small aui-iconfont-devtools-branch"/> ' : "";
            var buildLink = '<a href="' + o.contextPath + '/browse/' + build.planResultKey + '/">' + build.projectName + ' &rsaquo; ' + masterName + build.chainName + ' &rsaquo; #' + build.buildNumber + '</a> &rsaquo; <a href="' + o.contextPath + '/browse/' + build.buildResultKey + '/">' + build.jobName + '</a>';

            if (build.status == "BUILDING") {
                var msgHtml = build.messageType == "PROGRESS" ? '<div class="progress-bar" style="width:' + build.percentageComplete + '%;"></div><div class="progress-text">' + build.messageText + '</div>' : build.messageText;
                var buildAgentInfo = build.agent ? ' building on <a href="' + o.viewAgentUrl + '?agentId=' + build.agent.id + '" class="' + build.agent.type.toLowerCase() + '">' + build.agent.name + '</a>' : '';
                el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + buildLink + buildAgentInfo + '</div><div class="message ' + build.messageType.toLowerCase() + '">' + msgHtml + '</div>'; //Current Activity
                if (build.hasBuildPermission) {
                    var stopButtonHTML = (build.isBeingStopped) ? ca.disabledStopHTML : '<a href="' + o.stopBuildUrl + '?planResultKey=' + build.buildResultKey + '" class="build-stop">' + widget.icons.icon({ type: 'build-stop', text: o.cancelBuildText, showTitle: true }) + '</a>';
                    el += '<ul class="buildActions"><li>' + stopButtonHTML + '</li></ul>';
                }
                el += '</li>';
            } else if (build.status == "QUEUED") {
                var title = build.executableAgents ? ' title="' + ca.generateBuildableAgentsText(build.executableAgents) + '"' : '',
                    handle = o.hasAdminPermission ? '<span class="handle"></span>' : '';
                el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + handle + buildLink + '</div><div class="message ' + build.messageType.toLowerCase() + '"' + title + '>' + build.messageText + '</div>';  //Current Activity
                if (build.executableElasticImages || build.hasBuildPermission) {
                    el += '<ul class="buildActions">';
                    if (build.executableElasticImages) {
                        if (o.hasAdminPermission) {
                            el += '<li><a href="' + o.manageElasticInstancesUrl + '">' + widget.icons.icon({ type: 'elastic', text: o.canBuildElasticallyAdmin, showTitle: true }) + '</a></li>';
                        } else {
                            el += '<li>' + widget.icons.icon({ type: 'elastic-disabled', text: o.canBuildElastically, showTitle: true }) + '</li>';
                        }
                    }
                    if (build.hasBuildPermission) {
                        el += '<li><a href="' + o.stopBuildUrl + '?planResultKey=' + build.buildResultKey + '" class="build-stop">' + widget.icons.icon({ type: 'build-stop', text: o.cancelBuildText, showTitle: true }) + '</a></li>'
                    }
                    el += '</ul>';
                }
                el += '</li>';
            }
        } else {
            el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + build.planName + '</div><span class="message ' + build.messageType.toLowerCase() + '">' + build.messageText + '</span></li>';
        }
        return (el.length == 0 ? false : AJS.$(el));
    },
    /**
     * Checks if an activity stream is available, and if it is (and there are no activity stream comment forms open -
     * which would indicate the user is probably in the middle of adding a comment) then trigger a refresh.
     */
    updateActivityStream: function () {
        var o = CurrentActivity.options;

        if (o.activityStream && AJS.$(".activity-item-comment-form:visible", document.getElementById("feedContainer-" + o.activityStream.feedId)).length == 0) {
            o.activityStream.populateFeed();
        }
    },
    /**
     * Checks the time the build was last updated with the time the last data was retrieved.
     * Removes the build if it's older than the last update.
     * @param li - List item containing the build
     * @returns {Boolean} indicating whether the build was removed or not
     */
    checkLastUpdated: function (li) {
        var b = AJS.$(li);

        if (b.data("lastUpdated") < CurrentActivity.updateTimestamp) {
            b.remove();
            return true;
        } else {
            return false;
        }
    },
    /**
     * Checks if build lists are empty and if so, hide the list and display a message, otherwise show the list and hide the message.
     */
    checkListsHaveBuilds: function () {
        var ca = CurrentActivity;

        if (ca.building.children().length == 0) {
            ca.building.hide();
            ca.noBuilding.show();
        } else {
            ca.building.show();
            ca.noBuilding.hide();
        }
        if (ca.queue.children().length == 0) {
            ca.queue.hide();
            ca.noQueued.show();
            // If queue is empty but "queue is out-of-date" message is being displayed then hide the message and re-enable sorting
            if (ca.queueOutOfDate.is(":visible")) {
                ca.queue.sortable("enable");
                ca.queueOutOfDate.hide();
            }
        } else {
            ca.queue.show();
            ca.noQueued.hide();
        }
    },
    /**
     * Checks if current activity container exists and is in DOM
     * @returns {Boolean} indicating whether the container exists in the DOM
     */
    isCurrentActivityPresent: function () {
        var o = CurrentActivity.options;

        return (!o.caParent || !o.caParent.length || !o.caParent.parent().length);
    },
    /**
     * Retrieves the build JSON from the server and adds/removes/changes builds in the currently building and queue as needed.
     * @param callback - Allows the ability to execute a callback once the update has completed
     */
    updateBuilds: function (callback) {
        var ca = CurrentActivity,
            o = ca.options;

        ca.updateTimestamp = (new Date()).getTime();
        // Get builds from API
        AJS.$.ajax({
            url: o.getBuildsUrl,
            dataType: 'json',
            cache: false,
            success: function (json) {
                if (ca.isCurrentActivityPresent()) {
                    return false;
                }

                // If a callback was supplied to updateBuilds, fire it
                if (callback && AJS.$.isFunction(callback)) {
                    callback.call();
                }
                // Update agent summary text if available
                if (o.agentSummary) {
                    o.agentSummary.text(json.agentSummary);
                }
                // Go through each build returned and either update or insert as required
                AJS.$.each(json.builds, function () {
                    var build = AJS.$("#b" + this.buildResultKey),
                        msg, progress, messageType, stopButton;

                    if (build.length > 0) { // Check if the build already exists in building/queue
                        if (this.status == "BUILDING") {
                            // Check if build has started, if so move to building
                            if (build.closest(".buildContainer")[0] == o.queueParent[0]) {
                                build.remove();
                                build = ca.generateListItem(this).appendTo(ca.building);
                                progress = AJS.$(".progress", build[0]);
                                if (progress.length > 0) {
                                    progress.progressBar();
                                }
                            } else {
                                msg = AJS.$(".message", build[0]);
                                messageType = this.messageType.toLowerCase();

                                if (messageType == "progress" && msg.hasClass(messageType)) {
                                    msg.progressBar("option", { value: this.percentageComplete, text: this.messageText });
                                } else if (messageType == "progress") {
                                    msg.attr("class", "message").progressBar({ value: this.percentageComplete, text: this.messageText });
                                } else {
                                    if (msg.hasClass("progress")) {
                                        msg.progressBar("destroy");
                                    }
                                    if (!msg.hasClass(messageType)) {
                                        msg.attr("class", "message " + messageType).text(this.messageText);
                                    } else {
                                        msg.text(this.messageText);
                                    }
                                }
                                if (this.hasBuildPermission && this.isBeingStopped) {
                                    stopButton = AJS.$(".build-stop", build[0]);
                                    if (stopButton.length > 0) {
                                        stopButton.replaceWith(ca.disabledStopHTML);
                                    }
                                }
                            }
                        } else if (this.status == "QUEUED") {
                            msg = AJS.$(".message", build[0]).text(this.messageText).attr("title", (this.executableAgents ? ca.generateBuildableAgentsText(this.executableAgents) : null));
                            if (!msg.hasClass(this.messageType.toLowerCase())) {
                                msg.attr("class", "message " + this.messageType.toLowerCase());
                            }
                        }
                    } else {
                        if (this.status == "BUILDING") {
                            build = ca.generateListItem(this).appendTo(ca.building);
                            progress = AJS.$(".progress", build[0]);
                            if (progress.length > 0) {
                                progress.progressBar();
                            }
                        } else if (this.status == "QUEUED") {
                            build = ca.generateListItem(this).appendTo(ca.queue);
                        }
                    }
                    // Check if queue order is correct and reorder if required
                    if (!ca.isBeingSorted && typeof(this.queueIndex) != "undefined" && this.queueIndex != build.prevAll().length) {
                        build.insertBefore(ca.queue.children("li:eq(" + this.queueIndex + ")"));
                    }
                    build.data("lastUpdated", ca.updateTimestamp);
                });

                // Clean up builds not returned in JSON
                var numRemoved = 0;
                ca.building.children().each(function () {
                    if (ca.checkLastUpdated(this)) { numRemoved++; }
                });
                ca.queue.children().each(function () {
                    if (ca.checkLastUpdated(this)) { numRemoved++; }
                });
                if (numRemoved > 0) { ca.updateActivityStream(); }

                if (o.hasAdminPermission) {
                    // Refresh sorting
                    ca.queue.sortable("refresh");
                }

                ca.checkListsHaveBuilds();

                // Clear timeout to ensure we don't have multiple running
                clearTimeout(ca.updateTimeout);

                // Update again in 5 seconds
                ca.updateTimeout = setTimeout(ca.updateBuilds, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                if (ca.isCurrentActivityPresent()) {
                    return false;
                }

                // Clear timeout to ensure we don't have multiple running
                clearTimeout(ca.updateTimeout);

                // Error occurred when doing the update, try again in 30 sec, making sure the callback is passed so that it will actually get executed when it finally succeeds
                ca.updateTimeout = setTimeout(function () { ca.updateBuilds(callback); }, 30000);
            }
        });
    },
    /**
     * Strips a build list item's id down to a build result key
     * @param buildListItemID - String containing the build list item's id - eg. bBAM-FUNC-1234
     * @returns {String} containing the build result key - eg. BAM-FUNC-1234
     */
    buildListItemIDToBuildResultKey: function (buildListItemID) {
        return buildListItemID.substr(1);
    },
    /**
     * Initialisation for the Current Activity
     * @param options - Object containing the options to overwrite our defaults
     */
    init: function (options) {
        var ca = CurrentActivity,
            o = ca.options;

        AJS.$.extend(o, options);

        ca.building = AJS.$("<ul/>").appendTo(o.buildingParent).hide();
        ca.queue = AJS.$("<ul/>").appendTo(o.queueParent).hide();
        ca.noBuilding = AJS.$("<p>" + o.emptyBuildingText + "</p>").appendTo(o.buildingParent).hide();
        ca.noQueued = AJS.$("<p>" + o.emptyQueueText + "</p>").appendTo(o.queueParent).hide();
        ca.queueOutOfDate = AJS.$("<p>" + o.queueOutOfDateText + "</p>").insertBefore(ca.queue).hide();
        ca.loadingBuilding = AJS.$('<p class="loading">' + o.fetchingBuildData + '</p>').appendTo(o.buildingParent);
        ca.loadingQueued = AJS.$('<p class="loading">' + o.fetchingBuildData + '</p>').appendTo(o.queueParent);
        ca.disabledStopHTML = widget.icons.icon({ type: 'build-stop-disabled', text: o.cancellingBuildText, showTitle: true });

        clearTimeout(ca.updateTimeout);
        ca.updateTimestamp = null;

        o.caParent.delegate(".buildActions a.build-stop", "click", function (e) {
            var el = AJS.$(this),
                li = el.closest(".buildRow");
            AJS.$.post(this.href, function () {
                // Only remove from the queue immediately - currently building builds may take a while to stop and clean up - let the next updateBuilds() that runs clean it up
                if (li.closest(".buildContainer")[0] == o.queueParent[0]) {
                    li.remove();
                }
                ca.checkListsHaveBuilds();
            });
            el.replaceWith(ca.disabledStopHTML);
            e.preventDefault();
        });
        AJS.$("a", ca.queueOutOfDate[0]).click(function (e) {
            clearTimeout(ca.updateTimeout);
            ca.queue.empty().sortable("enable");
            AJS.$(this).parent().hide();
            ca.updateBuilds();
            ca.updateActivityStream();
            e.preventDefault();
        });
        if (o.hasAdminPermission) {
            ca.queue.sortable({
                handle: "span.handle",
                update: function (event, ui) {
                    var self = AJS.$(ui.item),
                        buildResultKey = ca.buildListItemIDToBuildResultKey(self.attr("id")),
                        checkListItemExists = function ($el) {
                            if ($el.length > 0) {
                                return ca.buildListItemIDToBuildResultKey($el.attr("id"));
                            } else {
                                return "";
                            }
                        },
                        prevBuildResultKey = checkListItemExists(self.prev()),
                        nextBuildResultKey = checkListItemExists(self.next());
                    AJS.$.post(o.reorderBuildUrl,
                        { buildResultKey: buildResultKey, prevBuildResultKey: prevBuildResultKey, nextBuildResultKey: nextBuildResultKey },
                        function (json) {
                            // If an error is returned show the queue out of date message. The next update will restore the correct queue order.
                            if (json.status == "ERROR") {
                                ca.queueOutOfDate.show();
                                ca.queue.sortable("disable");
                            }
                        }, "json");
                },
                start: function (event, ui) {
                    ca.isBeingSorted = true;
                },
                stop: function (event, ui) {
                    ca.isBeingSorted = false;
                }
            });
        }
        ca.updateBuilds(function () {
            ca.loadingBuilding.hide();
            ca.loadingQueued.hide();
        });
    }
};

/**
 * Agent Manager dropdown
 */
var AgentManager = {
    // Default options
    options: {
        contextPath: null,
        getAgentsUrl: null,
        enableAgentUrl: null,
        disableAgentUrl: null,
        enableAllAgentsUrl: null,
        disableAllAgentsUrl: null,
        viewAgentUrl: null,
        enableAgentText: null,
        disableAgentText: null,
        enableAllAgentsText: null,
        disableAllAgentsText: null,
        onlineAgentsText: null,
        defaultRemoteAgentSummaryText: null,
        onlineOnly: false,
        includeRemoteAgentSummary: false,
        triggerId: null,
        dedicatedLozenge: null
    },
    $agentList: null, // jQuery object referring to the list holding the agents
    $dialog: null, // jQuery object referring to the AUI Inline Dialog
    $remoteAgentSummary: null, // jQuery object referring to the paragraph containing the remote agent summary text
    /**
     * Generates the list item
     * @param agent - Agent object
     * @returns {Object} containing the list item or false if no list item is built
     */
    generateListItem: function (agent) {
        var am = AgentManager,
            o = am.options,
            el = "";
        el = '<li class="' + agent.type.toLowerCase() + ' ' + (agent.enabled ? "enabled" : "disabled") + '"><h3><a href="' + o.viewAgentUrl + '?agentId=' + agent.id + '">' + agent.name + '</a>' + (agent.isDedicated ? ' ' + o.dedicatedLozenge : '') + '</h3><span>' + (agent.agentStatus == "Building" ? agent.agentStatus + ' - <a href="' + o.contextPath + agent.buildLogUrl + '">' + agent.buildDisplayName + '</a>' : agent.agentStatus) + '</span> <button class="aui-button ' + (agent.enabled ? "disable" : "enable") + '">' + (agent.enabled ? o.disableAgentText : o.enableAgentText) + '</button></li>';
        return (el.length == 0 ? false : AJS.$(el).data("agentId", agent.id));
    },
    /**
     * Updates the list of agents
     * @param $contents - jQuery element of the Inline Dialog's contents
     * @param $trigger - jQuery element that is triggering the popup
     * @param doShowPopup - function to display the popup
     */
    updateAgents: function ($contents, $trigger, doShowPopup) {
        var am = AgentManager,
            o = am.options;
        AJS.$.ajax({
            url: o.getAgentsUrl,
            data: { onlineOnly: o.onlineOnly, includeRemoteAgentSummary: o.includeRemoteAgentSummary },
            dataType: 'json',
            cache: false,
            success: function (json) {
                if (o.includeRemoteAgentSummary && json.remoteAgentSummary) {
                    am.$remoteAgentSummary.html(json.remoteAgentSummary);
                } else if (o.includeRemoteAgentSummary) {
                    am.$remoteAgentSummary.html(o.defaultRemoteAgentSummaryText);
                }
                am.$agentList.empty();
                AJS.$.each(json.agents, function () {
                    am.$agentList.append(am.generateListItem(this));
                });
                if (doShowPopup) {
                    doShowPopup();
                }
            }
        });
    },
    /**
     * Initialisation for the Agent Manager
     * @param options - Object containing the options to overwrite our defaults
     */
    init: function (options) {
        var am = AgentManager,
            o = am.options;

        // Don't init if already created
        if (am.$dialog) { return false; }

        AJS.$.extend(o, options);

        am.$dialog = AJS.InlineDialog("#" + o.triggerId, o.triggerId, am.updateAgents, {
            onHover: true,
            width: 400,
            offsetX: 0,
            offsetY: 3,
            cacheContent: false,
            useLiveEvents: true
        });
        var $contents = am.$dialog.find(".contents").addClass("agentManager");
        am.$agentList = AJS.$('<ul />').appendTo($contents).before('<h2>' + o.onlineAgentsText + '</h2>');
        if (o.includeRemoteAgentSummary) {
            am.$remoteAgentSummary = AJS.$('<p>' + o.defaultRemoteAgentSummaryText + '</p>').insertBefore(am.$agentList);
        }
        var $buttons = AJS.$('<div class="aui-buttons"></div>').appendTo($contents);
        AJS.$('<button class="aui-button">' + o.enableAllAgentsText + '</button>').appendTo($buttons).click(function () {
            var el = AJS.$(this);
            el.attr("disabled", "disabled");
            AJS.$.post(o.enableAllAgentsUrl, function () {
                el.removeAttr("disabled");
                am.updateAgents();
            });
        });
        AJS.$('<button class="aui-button">' + o.disableAllAgentsText + '</button>').appendTo($buttons).click(function () {
            var el = AJS.$(this);
            el.attr("disabled", "disabled");
            AJS.$.post(o.disableAllAgentsUrl, function () {
                el.removeAttr("disabled");
                am.updateAgents();
            });
        });
        // FF not firing buttons on click for some reason, mouseup is okay though?!!
        var dialogId = am.$dialog.attr("id");
        AJS.$("#" + dialogId + " button.enable").live("mouseup", function () {
            var el = AJS.$(this),
                li = el.closest("li");
            var agentId = li.data("agentId");
            el.attr("disabled", "disabled");
            AJS.$.post(o.enableAgentUrl, { agentId: agentId }, function () {
                el.text(o.disableAgentText).attr("class", "aui-button disable").removeAttr("disabled").parent().removeClass("disabled");
            });
        });
        AJS.$("#" + dialogId + " button.disable").live("mouseup", function () {
            var el = AJS.$(this),
                li = el.closest("li");
            var agentId = li.data("agentId");
            el.attr("disabled", "disabled");
            AJS.$.post(o.disableAgentUrl, { agentId: agentId }, function () {
                el.text(o.enableAgentText).attr("class", "aui-button enable").removeAttr("disabled").parent().addClass("disabled");
            });
        });
    }
};

var SelectionActions = function() {
    return {
        init: function (formId) {
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='"+formId+"_all']").click( function() {
                    clearSelectionStatus();

                    getSelectAllWarning().show();
                    getAllPagesSelectedInfo().hide();

                    getAllCheckBoxes("").attr("checked", "checked");
                });
                AJS.$("span[selector='"+formId+"_none']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='"+formId+"_disabled']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("[class~='selectorAgentEnabled_false']").attr("checked", "checked");
                });
                AJS.$("span[selector='"+formId+"_idle']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("[class~='selectorAgentStatus_Idle']").attr("checked", "checked");
                });
                AJS.$("span[selector='"+formId+"_allPages']").click( function() {
                    setCompleteContentSelected(true);
                    getSelectAllWarning().hide();
                    getAllPagesSelectedInfo().show();
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.selectorAgentType_"+formId+"[name='selectedAgents']"+selector);
            }

            function setCompleteContentSelected(newValue) {
                AJS.$('.'+formId+'_completeContentSelected').val(newValue);
            }

            function clearSelectionStatus() {
                AJS.$('.'+formId+'_paginatedWarning').hide();
                getAllCheckBoxes("").removeAttr("checked");
                setCompleteContentSelected(false);
            }

            function getSelectAllWarning() {
                return AJS.$('.'+formId+'_paginatedSelectAllWarning');
            }

            function getAllPagesSelectedInfo() {
                return AJS.$('.'+formId+'_paginatedAllPagesSelected');
            }
        }
    };
}();

/**
 * Generic selection in table control without support for pagination.
 * Selectors need to have 2 attributes :
 *  - data-selector-id (must match name of the checkbox group)
 *  - data-selector-type (ALL, NONE or custom selector that will be match by discriminators)
 *
 * Checkboxes can specify a comma-separated list of discriminators for selection in
 * the 'data-selector-discriminator' attribute.
 *
 */
var GenericSelectionActions = function($) {
    var SELECT_ALL = "ALL", DESELECT_ALL = "NONE";

    return {

        init: function (formId, checkboxName) {
            registerSelectionActions();

            function registerSelectionActions() {
                var $form = $(BAMBOO.escapeIdToJQuerySelector("#" + formId));
                if ($form.length === 0) {
                    return;
                }
                $form.find("span[data-selector-id='"+checkboxName+"']").click(function() {
                        discriminator = $(this).data("selectorType");
                    applyToCheckboxes($form, discriminator);
                });
            }

            function applyToCheckboxes($inForm, discriminator) {
                $inForm.find("input:checkbox").each(function() {
                    var $this = $(this);
                    if (matchesDiscriminator($this, discriminator)) {
                        $this.attr("checked", "checked");
                    } else {
                        $this.removeAttr("checked");
                    }
                });
            }

            function matchesDiscriminator($checkbox, selector) {
                var found = false;
                if (selector === SELECT_ALL) {
                    return true;
                } else if (selector === DESELECT_ALL) {
                    return false;
                } else {
                    $.each($checkbox.data("selectorDiscriminator").split(","), function(index, value) {
                        if (value === selector) {
                            found = true;
                            return true;
                        }
                    });
                    return found;
                }
            }
        }
    };
}(AJS.$);

var BulkSelectionActions = function() {
    return {
        init: function (formId) {
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='bulk_selector_all']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("").attr("checked", "checked");
                });
                AJS.$("span[selector='bulk_selector_none']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='bulk_selector_plans']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Plan").attr("checked", "checked");
                });
                AJS.$("span[selector='bulk_selector_jobs']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Job").attr("checked", "checked");
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.bulk"+selector);
            }

            function setCompleteContentSelected(newValue) {
                AJS.$('.'+formId+'_completeContentSelected').val(newValue);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes("").removeAttr("checked");
                setCompleteContentSelected(false);
            }
        }
    };
}();

var BulkSubtreeSelectionActions = function() {
    return {
        init: function (formId, enableProjectCheckbox) {
            registerSelectionActions(enableProjectCheckbox);

            function registerSelectionActions(enableProjectCheckbox) {
                AJS.$("span[selector='bulk_selector_sub_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes(formId).attr("checked", "checked");
                });
                AJS.$("span[selector='bulk_selector_sub_none_"+formId+"']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='bulk_selector_sub_plans_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Plan" + formId).attr("checked", "checked");
                });
                AJS.$("span[selector='bulk_selector_sub_jobs_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Job" + formId).attr("checked", "checked");
                });

                if (enableProjectCheckbox) {
                    AJS.$("#checkbox_"+formId).change( function() {
                        var val = AJS.$(this).is(":checked");
                        clearSelectionStatus();
                        if (val) {
                            getAllCheckBoxes(formId).attr("checked", "checked");
                        }
                    });
                }
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.bulk"+selector);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes(formId).removeAttr("checked");
            }
        }
    };
}();

var ConfigurableSelectionActions = function() {
    return {
        init: function (formId) {
            var formIdSelector = formId.replace(/([\.:])/g, "\\$1");
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='"+formId+"_all']").click( function() {
                    getAllCheckBoxes("").attr("checked", "checked");
                });
                AJS.$("span[selector='"+formId+"_none']").click( function() {
                    clearSelectionStatus();
                });

                AJS.$("span[selector^='"+formId+"_'][selector!='"+formId+"_none'][selector!='"+formId+"_all']").each(function () {
                    var span = AJS.$(this),
                        selector = span.attr("selector").substring(formId.length + 1);
                    span.click( function() {
                        clearSelectionStatus();
                        getAllCheckBoxes("[class~='selector_"+selector+"_true']").attr("checked", "checked");
                    });
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.selectorScope_"+formIdSelector+selector);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes("").removeAttr("checked");
            }
        }
    };
}();

/**
 * Live Activity for Plans
 */
var LiveActivity = function ($) {
    var opts = {
        planKey: null,
        container: null,
        getBuildsUrl: null,
        getResultUrl: null,
        getChangesUrl: null,
        queueEmptyText: null,
        cancellingBuildText: null,
        noAdditionalInfoText: null,
        defaultIssueIconUrl: null,
        defaultIssueType: null,
        slideSpeed: 600,
        templates: {
            buildListItemTemplate: null,
            buildingOnTemplate: null,
            buildMessageTemplate: null,
            jiraIssueTemplate: null,
            codeChangeTemplate: null,
            codeChangeChangesetLinkTemplate: null,
            codeChangeChangesetDisplayTemplate: null,
            currentStageTemplate: null,
            toggleDetailsButton: AJS.template('<span class="toggle-details"></span>')
        }
    },
    $buildList, // jQuery object referring to the list holding the builds
    $noBuilds, // jQuery object referring to the message that shows when there are no builds
    disabledStopHTML, // HTML fragment that replaces the stop button when a user clicks it (so it can't be clicked multiple times)
    toggleDetailsHTML, // HTML fragment inserted to enable the user to toggle the display of additional information
    /**
     * Checks if build list is empty and if so, hide the list and display a message, otherwise show the list and hide the message.
     */
    checkListHasBuilds = function () {
        if ($buildList.children().length == 0) {
            $buildList.hide();
            $noBuilds.show();
        } else {
            $buildList.show();
            $noBuilds.hide();
        }
    },
    updateTimeout, // ID of timeout which determines when the data will be next fetched from the server
    updateTimestamp, // Timestamp (represented as milliseconds since the Unix epoch) that the builds were last updated
    /**
     * Retrieves the build JSON from the server and adds/removes/changes builds in the build list as needed.
     */
    update = function () {
        // Otherwise switching to history tab results in undefined behaviour
        if($('#liveActivity').length == 0) return;
        updateTimestamp = (new Date()).getTime();
        $.ajax({
            url: opts.getBuildsUrl,
            data: { planKey: opts.planKey },
            dataType: "json",
            cache: false,
            success: function (json) {
                // Go through each build returned and either update or insert as required
                $.each(json.builds, function () {
                    var $build = $("#b" + this.buildResultKey),
                        messageType = this.messageType.toLowerCase(),
                        status = this.status.toLowerCase();
                    if ($build.length > 0) { // Check if the build already exists in list
                        var $msg = $(".message", $build[0]),
                            $stageInfo = $(".stage-info", $build[0]),
                            $agentInfo = $(".agent-info", $build[0]);
                        if (messageType == "progress" && $msg.hasClass(messageType)) {
                            $msg.progressBar("option", { value: this.percentageComplete, text: this.messageText });
                        } else if (messageType == "progress") {
                            $msg.attr("class", "message").progressBar({ value: this.percentageComplete, text: this.messageText });
                        } else {
                            if ($msg.hasClass("progress")) {
                                $msg.progressBar("destroy");
                            }
                            if (!$msg.hasClass(messageType)) {
                                $msg.attr("class", "message " + messageType).text(this.messageText);
                            } else {
                                $msg.text(this.messageText);
                            }
                        }
                        if (status == "building") {
                            if ($agentInfo.length == 0 && this.agent != null) {
                                var buildingOnHTML = status == "building" ? AJS.template.load(opts.templates.buildingOnTemplate).fill({ agentId: this.agent.id, agentType: this.agent.type.toLowerCase(), agentName: this.agent.name }).toString() : "";
                                $(".build-description", $build[0]).append(buildingOnHTML);
                            }
                            if (this.stage != null && $stageInfo.length > 0) {
                                var currentStageHTML = (status == "building" ? AJS.template.load(opts.templates.currentStageTemplate).fill({ stageName: this.stage.name, stageNumber: this.stage.number, totalStages: this.stage.totalStages }).toString() : "");
                                $stageInfo.html($.trim(currentStageHTML));
                            }
                        }
                        if (!$build.hasClass(status)) {
                            $build.removeClass(status == "building" ? "queued" : "building").addClass(status);
                        }
                    } else {
                        var buildingOnHTML = (status == "building" && this.agent != null) ? AJS.template.load(opts.templates.buildingOnTemplate).fill({ agentId: this.agent.id, agentType: this.agent.type.toLowerCase(), agentName: this.agent.name }).toString() : "",
                            currentStageHTML = (status == "building" && this.stage != null) ? AJS.template.load(opts.templates.currentStageTemplate).fill({stageName: this.stage.name, stageNumber: this.stage.number, totalStages: this.stage.totalStages }).toString() : "",
                            buildMessageHTML = AJS.template.load(opts.templates.buildMessageTemplate).fill({ type: messageType, text: this.messageText }).toString(),
                            listItemHTML = AJS.template.load(opts.templates.buildListItemTemplate).fill({
                                buildResultKey: this.buildResultKey,
                                cssClass: status,
                                planKey: this.planKey
                            }).fillHtml({
                                buildingOn: buildingOnHTML,
                                triggerReason: this.triggerReason,
                                currentStage: currentStageHTML,
                                buildMessage: buildMessageHTML
                            }).toString();
                        $build = $(listItemHTML).appendTo($buildList);
                        var $msg = $(".message", $build[0]);
                        $build.addClass("collapsed").prepend(toggleDetailsHTML);
                        $(".additional-information", $build).hide();
                        if (messageType == "progress") {
                            $msg.progressBar({ value: this.percentageComplete, text: this.messageText });
                        }
                    }
                    $build.data("lastUpdated", updateTimestamp);
                });

                // Clean up builds not returned in JSON
                var planResultKeys = [];
                $buildList.children().each(function () {
                    var b = $(this);
                    if (b.data("lastUpdated") < updateTimestamp) {
                        b.fadeOut(500, function () {
                            $(this).remove();
                            checkListHasBuilds();
                        })
                        planResultKeys.push(b.attr('id').substring(1));
                    }
                });
                if (planResultKeys.length > 0) {
                    // Pet peeve - reverse mutates in place :(
                    planResultKeys.reverse();
                    $.ajax({
                        url: opts.getResultUrl,
                        data: { planResultKeys: planResultKeys },
                        success: function (result) {
                            $('.buildResultsNone').hide();
                            $('#buildResultsTable').show().find('tbody').prepend($(result).find('tr'));
                        }
                    });
                }

                checkListHasBuilds();

                // Update again in 5 seconds if something is going on, later if everything is calm
                updateTimeout = setTimeout(update, json.builds && json.builds.length ? 5000 : 15000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        /**
         * Initialisation for the Live Activity
         * @param options - Object containing the options to overwrite our defaults
         */
        init: function (options) {
            $.extend(true, opts, options);
            disabledStopHTML = widget.icons.icon({ type: 'build-stop-disabled', text: opts.cancellingBuildText, showTitle: true });
            if (opts.templates.toggleDetailsButton) {
                toggleDetailsHTML = opts.templates.toggleDetailsButton.toString();
            }

            $buildList = $("> ul", opts.container);
            if ($buildList.length == 0) {
                $buildList = $("<ul />").hide().prependTo(opts.container);
            } else {
                $buildList.children().addClass("collapsed").prepend(toggleDetailsHTML);
                $(".additional-information", $buildList).hide();
            }
            $noBuilds = $("> p", opts.container);
            if ($noBuilds.length == 0) {
                $noBuilds = $("<p>" + opts.queueEmptyText + "</p>").hide().appendTo(opts.container);
            }

            $("#" + opts.container.attr("id") + " a.build-stop").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li");
                $.post(this.href, function () {
                    // Only remove from the queue immediately - currently building builds may take a while to stop and clean up - let the next updateBuilds() that runs clean it up
                    if (li.hasClass("queued")) {
                        li.fadeOut(500, function () {
                            $(this).remove();
                            checkListHasBuilds();
                        })
                    }
                });
                el.replaceWith(disabledStopHTML);
                e.preventDefault();
            });

            $("#" + opts.container.attr("id") + " .collapsed .toggle-details").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li"),
                    additionalInfo = $(".additional-information", li[0]),
                    buildResultKey = li.attr("id").substring(1);

                if (!additionalInfo.data("data-retrieved")) {
                    li.removeClass("collapsed");
                    $.ajax({
                        url: opts.getChangesUrl + buildResultKey,
                        data: {
                            expand: "jiraIssues,vcsRevisions.vcsRevision.changes.change"
                        },
                        dataType: "json",
                        contentType: "application/json",
                        success: function (json) {
                            var issues = "";
                            if (json.jiraIssues && json.jiraIssues.size > 0) {
                                $.each(json.jiraIssues.issue, function () {
                                    if (this.url && this.url.href && this.key && this.summary) {
                                        issues += AJS.template.load(opts.templates.jiraIssueTemplate).fill({
                                            url: this.url.href,
                                            issueType: (this.issueType && this.issueType.length > 0) ? this.issueType : opts.defaultIssueType,
                                            issueIconUrl: (this.iconUrl && this.iconUrl.length > 0) ? this.iconUrl : opts.defaultIssueIconUrl,
                                            key: this.key,
                                            details: this.summary
                                        }).toString();
                                    }
                                });
                            }

                            var changes = "";
                            if (json.vcsRevisions && json.vcsRevisions.size > 0) {
                                $.each(json.vcsRevisions.vcsRevision, function() {
                                    if (this.changes && this.changes.size > 0) {
                                        $.each(this.changes.change, function () {
                                            if (this.author && this.comment) {
                                                changes += AJS.template.load(opts.templates.codeChangeTemplate).fill({
                                                    authorOrUser: (this.userName && this.userName.length > 0) ? "user" : "author",
                                                    author: (this.userName && this.userName.length > 0) ? this.userName : this.author,
                                                    displayName: (this.fullName && this.fullName.length > 0) ? this.fullName : this.author,
                                                    comment: this.comment
                                                }).fillHtml({
                                                    changesetInfo: this.changesetId ? AJS.template.load(this.commitUrl ? opts.templates.codeChangeChangesetLinkTemplate : opts.templates.codeChangeChangesetDisplayTemplate).fill({
                                                        commitUrl: this.commitUrl ? this.commitUrl : null,
                                                        changesetId: this.changesetId
                                                    }).toString() : ""
                                                }).toString();
                                            }
                                        });
                                    }
                                });
                            }

                            if (issues.length == 0 && changes.length == 0) {
                                additionalInfo.text(opts.noAdditionalInfoText);
                            } else {
                                if (issues.length == 0) {
                                    $(".issueSummary", additionalInfo[0]).remove();
                                } else {
                                    $(".issueSummary", additionalInfo[0]).append("<ul>" + issues + "</ul>");
                                }
                                if (changes.length == 0) {
                                    $(".changesSummary", additionalInfo[0]).remove();
                                } else {
                                    $(".changesSummary", additionalInfo[0]).append("<ul>" + changes + "</ul>");
                                }
                            }

                            li.addClass("expanded");
                            additionalInfo.data("data-retrieved", true, true).stop(true).slideDown(opts.slideSpeed);
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            li.addClass("collapsed");
                        }
                    });
                } else {
                    li.removeClass("collapsed").addClass("expanded");
                    additionalInfo.stop(true, true).slideDown(opts.slideSpeed);
                }
            });

            $("#" + opts.container.attr("id") + " .expanded .toggle-details").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li");
                li.removeClass("expanded").addClass("collapsed");
                $(".additional-information", li[0]).stop(true, true).slideUp(opts.slideSpeed);
            });

            // Trigger the first update
            update();
        }
    }
}(jQuery);


function showAjaxErrorMessage(XMLHttpRequest) {
    AJS.$(".ajaxErrorMessage").html("["+XMLHttpRequest.statusText+"]");
    AJS.$("#ajaxErrorHolder").removeClass("hidden").show();
}

function hideAjaxErrorMessage() {
    AJS.$(".ajaxErrorMessage").empty();
    AJS.$("#ajaxErrorHolder").hide();
}

/**
 * Usage: init(selector, reloadEvent) . Calling init function multiple times on the same page is safe regardless of used selectors.
 *
 * @param selector the jQuery selector used to mark asynchronously executed links
 * @param resetLinkStateEventName (optional, nullable) the event causing the "executed" status of links to be cleared
 * @param onUrlCallFinished (optional) handler to call when url processing is finished
 */
var AsynchronousRequestManager = function($) {
    var IN_PROGRESS_KEY = "isInProgress";
    var registeredResetLinkStateHandlers = {};

    function isInProgress(link) {
        return link.data(IN_PROGRESS_KEY);
    }

    function setInProgress(link, newValue) {
        link.data(IN_PROGRESS_KEY, newValue);
        if (newValue) {
            link.fadeTo("slow", 0.4);
        } else {
            link.fadeTo("slow", 1);
        }
    }

    var onAsynchronousLinkClick = function (event) {
        var $this = $(this);
        if (!isInProgress($this)) {
            $.ajax({
                url: this.href,
                type: $this.hasClass("usePostMethod") ? "POST" : "GET",
                error: function (XMLHttpRequest) {
                    setInProgress($this, false);
                    if (event.data.failureHandler) {
                        event.data.failureHandler();
                    }
                    showAjaxErrorMessage(XMLHttpRequest);
                },
                success: function (htmlOrJson) {
                    if (htmlOrJson.status && htmlOrJson.status == "ERROR") {
                        if (event.data.failureHandler) {
                            event.data.failureHandler(htmlOrJson);
                        }
                    } else {
                        if (event.data.successHandler) {
                            event.data.successHandler();
                        }
                    }
                    setInProgress($this, false);
                }
            });
            setInProgress($this, true);
        }
        event.preventDefault();
    };

    function makePair(first, second) {
        return first + "##" + second;
    }

    return {
        init: function (selector, resetLinkStateEventName, onUrlCallFinished) {
            var $selector = $(selector);
            if (resetLinkStateEventName) {
                var pair = makePair(resetLinkStateEventName, selector);
                if (!(pair in registeredResetLinkStateHandlers)) {
                    $("body").bind(resetLinkStateEventName, function () {
                        $selector.filter(":visible").each(function () {
                            setInProgress($(this), false);
                        });
                    });
                    registeredResetLinkStateHandlers[pair] = true;
                }
            }

            $(document)
                .off("click", selector, onAsynchronousLinkClick)
                .on("click", selector, {
                    successHandler: onUrlCallFinished,
                    failureHandler: onUrlCallFinished
                }, onAsynchronousLinkClick);
        }
    }
}(AJS.$);



/**
 * JobResultSummary page
 */
var JobResultSummaryLiveActivity = function ($) {
    var opts = {
        buildResultKey: null,
        buildLifeCycleState: null,
        container: null,
        getBuildUrl: null,
        reloadUrl: null,
        templates: {
            disabledStopButton: null,
            logTableRow: null,
            progressOverAverage: null,
            progressUnderAverage: null,
            queueDurationDescription: null,
            queuePositionDescription: null,
            updatingSourceFor: null
        }
    },
    linesOfLogToDisplay = 10,
    $linesOfLogToDisplaySelect,
    $logBody,
    $logContainer,
    $logLoading,
    $progressBarContainer,
    $queueDurationDescriptionContainer,
    $queuePositionDescriptionContainer,
    queueDuration,
    updateTimeout,
    update = function () {

        clearTimeout(updateTimeout);

        var ajaxData = $logContainer.is(":visible") ? {
            expand: 'logEntries[-' + linesOfLogToDisplay + ':]',
            'max-results': linesOfLogToDisplay
        } : {};

        $.ajax({
            url: opts.getBuildUrl,
            data: ajaxData,
            dataType: "json",
            contentType: "application/json",
            cache: false,
            success: function (buildResult) {
                if (buildResult.lifeCycleState != opts.buildLifeCycleState) {
                    document.location = opts.reloadUrl;
                    return;
                } else if (buildResult.lifeCycleState == "Pending" || buildResult.lifeCycleState == "Queued") {
                    if (queueDuration != buildResult.queueDuration) {
                        var queueDurationMarkup = AJS.template.load(opts.templates.queueDurationDescription)
                                .fill({ durationDescription: DurationUtils.getPrettyPrint(buildResult.queueDuration)}).toString();
                        $queueDurationDescriptionContainer.html(queueDurationMarkup);
                        $queueDurationDescriptionContainer.show();
                        queueDuration = buildResult.queueDuration;
                    }

                    var queuePositionMarkup = AJS.template.load(opts.templates.queuePositionDescription)
                            .fill({
                                position: buildResult.queue.position + 1,
                                length: buildResult.queue.length
                            }).toString();
                    $queuePositionDescriptionContainer.html(queuePositionMarkup);
                    $queuePositionDescriptionContainer.show();

                } else if (buildResult.lifeCycleState == "InProgress") {
                    if (buildResult.progress) {

                        var pbOptions = {};

                        if (buildResult.buildStartedTime) {
                            pbOptions.value = buildResult.progress.percentageCompleted * 100;
                            if (buildResult.progress.isUnderAverageTime) {
                                pbOptions.text = AJS.template.load(opts.templates.progressUnderAverage).fill({
                                    elapsed: buildResult.progress.prettyBuildTime,
                                    remaining: buildResult.progress.prettyTimeRemainingLong
                                }).toString();
                            } else {
                                pbOptions.text = AJS.template.load(opts.templates.progressOverAverage).fill({
                                    elapsed: buildResult.progress.prettyBuildTime,
                                    remaining: buildResult.progress.prettyTimeRemainingLong
                                }).toString();
                            }
                        } else {
                            pbOptions.value = 0;
                            pbOptions.text = AJS.template.load(opts.templates.updatingSourceFor).fill({
                                prettyVcsUpdateDuration: buildResult.prettyVcsUpdateDuration
                            }).toString();
                        }

                        $progressBarContainer.progressBar(pbOptions);
                    }

                    if (buildResult.logEntries && buildResult.logEntries.logEntry) {

                        var newLogBody = '';

                        for (var i = 0, ii = buildResult.logEntries.logEntry.length; i < ii; i++) {
                            var logEntry = buildResult.logEntries.logEntry[i];
                            newLogBody += AJS.template.load(opts.templates.logTableRow)
                                    .fill({ time: logEntry.formattedDate })
                                    .fillHtml({ log: logEntry.log }).toString();
                        }
                        if ($logBody.html() != newLogBody) {
                            $logBody.html(newLogBody);
                        }
                        if ($logLoading.is(":visible")) {
                            $logLoading.hide();
                            $logBody.parent().removeClass("hidden");
                        }
                    }
                }

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);

            $linesOfLogToDisplaySelect = $("#linesToDisplay");
            $logBody = $("#buildLog tbody");
            $logContainer = $logBody.parent().parent();
            $logLoading = $(".loading", $logContainer[0]);
            $progressBarContainer = $("#pb" + opts.buildResultKey);
            $queueDurationDescriptionContainer = $("#queueDurationDescription");
            $queuePositionDescriptionContainer = $("#queuePositionDescription");

            // Get our default in line with what was set previously
            linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();

            $linesOfLogToDisplaySelect.change(function () {
                linesOfLogToDisplay = $(this).val();
                saveCookie("BAMBOO-MAX-DISPLAY-LINES", linesOfLogToDisplay, 365);
                update();
            });

            if (opts.templates.disabledStopButton)
            {
                var disabledStopHTML = opts.templates.disabledStopButton.toString();
                $("#buildResults a.build-stop").live("click", function (e) {
                    var $el = $(this);
                    $.post(this.href);
                    $el.replaceWith(disabledStopHTML);
                    e.preventDefault();
                });
            }

            // Trigger the first update
            update();
        }
    }
}(jQuery);


var DurationUtils = function() {
    var opts = {
        format: "{value} {unit}",
        units: {
            SEC: ["second", "seconds"],
            MIN: ["minute", "minutes"]
        }
    },
    MILLIS_IN_MINUTE = 60 * 1000,
    MILLIS_IN_SECOND = 1000,
    describeValueAs = function(value, unit) {
        return opts.format.replace("{value}", value).replace("{unit}", value == 1 ? unit[0] : unit[1]);
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);
        },
        getPrettyPrint: function(elapsedTimeMillis) {
            if (elapsedTimeMillis >= MILLIS_IN_MINUTE) {
                return describeValueAs(Math.floor(elapsedTimeMillis / MILLIS_IN_MINUTE), opts.units.MIN)
            } else if (elapsedTimeMillis >= MILLIS_IN_SECOND) {
                return describeValueAs(Math.floor(elapsedTimeMillis / MILLIS_IN_SECOND), opts.units.SEC)
            } else {
                return "< 1 {unit}".replace("{unit}", opts.units.SEC[0]);
            }
        }
    }
}();

/**
 * BuildResultSummary page
 */
var BuildResultSummaryLiveActivity = function ($) {
    var opts = {
        getBuildUrl: null,
        activeJobResultKey: null,
        templates: {
            logMessagePending: null,
            logMessageQueued: null,
            logMessageFinished: null,
            logTableRow: null
        }
    },
    displayLogActivity = function(logBody) {
        $logMessage.hide();
        $logLoading.hide();
        if ($logBody.html() != logBody) {
            $logBody.html(logBody);
        }
        $logBody.parent().show();
        $logContainer.show();
    },
    displayLogLoading = function() {
        $logMessage.hide();
        $logBody.parent().hide();
        $logLoading.show();
        $logContainer.show();
    },
    displayLogMessage = function(template) {
        $logContainer.hide();
        $logMessage.html(AJS.template.load(template).fill({job: jobName})).show();
    },
    $jobResultKeyForLogDisplaySelect,
    jobResultKey,
    jobName,
    linesOfLogToDisplay = 10,
    $linesOfLogToDisplaySelect,
    $logBody,
    $logContainer,
    $logLoading,
    $logMessage,
    updateTimeout,
    update = function () {

        clearTimeout(updateTimeout);

        $.ajax({
            url: opts.getBuildUrl.replace("@KEY@", jobResultKey),
            data: {
                expand: 'logEntries[-' + linesOfLogToDisplay + ':]',
                'max-results': linesOfLogToDisplay
            },
            dataType: "json",
            contentType: "application/json",
            cache: false,
            success: function (buildResult) {
                if (buildResult.lifeCycleState == "Pending") {
                    displayLogMessage(opts.templates.logMessagePending);
                } else if (buildResult.lifeCycleState == "Queued") {
                    displayLogMessage(opts.templates.logMessageQueued);
                } else if (buildResult.lifeCycleState == "InProgress") {
                    if (buildResult.logEntries && typeof(buildResult.logEntries.logEntry) != "undefined") {
                        var newLogBody = '';
                        for (var i = 0, ii = buildResult.logEntries.logEntry.length; i < ii; i++) {
                            var logEntry = buildResult.logEntries.logEntry[i];
                            newLogBody += AJS.template.load(opts.templates.logTableRow)
                                    .fill({ time: logEntry.formattedDate })
                                    .fillHtml({ log: logEntry.log }).toString();
                        }
                        displayLogActivity(newLogBody);
                    } else {
                        displayLogLoading();
                    }
                } else if (buildResult.lifeCycleState == "Finished") {
                    displayLogMessage(opts.templates.logMessageFinished);
                }

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        init: function(options) {
            $.extend(true, opts, options);
            $jobResultKeyForLogDisplaySelect = $("#jobResultKeyForLogDisplay");
            $linesOfLogToDisplaySelect = $("#linesToDisplay");
            $logContainer = $("#buildResultSummaryLogs");
            $logBody = $("table > tbody", $logContainer[0]);
            $logLoading = $(".loading", $logContainer[0]);
            $logMessage = $("#buildResultSummaryLogMessage");

            // Get our default in line with what was set previously
            linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();

            $jobResultKeyForLogDisplaySelect.change(function () {
                jobResultKey = $jobResultKeyForLogDisplaySelect.val();
                jobName = $jobResultKeyForLogDisplaySelect.find("option:selected").text();
                update();
            });

            $linesOfLogToDisplaySelect.change(function () {
                linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();
                saveCookie("BAMBOO-MAX-DISPLAY-LINES", linesOfLogToDisplay, 365);
                update();
            });

            // Trigger the first update
            if (opts.activeJobResultKey) {
                $jobResultKeyForLogDisplaySelect.val(opts.activeJobResultKey);
            }
            $jobResultKeyForLogDisplaySelect.change();
        }
    }
}(jQuery);


var ChainConfiguration = function ($) {
    var opts = {
        $list: null,
        moveStageUrl: null,
        moveJobUrl: null,
        confirmStageMoveUrl: null,
        confirmJobMoveJobUrl: null,
        chainKey: null,
        canReorder: false,
        stageMoveHeader: "Move Stage",
        jobMoveHeader: "Move Job"
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);
            opts.$list.children(":last-child").addClass("last");

            if (!opts.canReorder) {
                return;
            }

            opts.$list.sortable({
                cursor: "move",
                distance: 5,
                handle: "dl",
                start: function (event, ui) {
                    var $self = $(ui.item);
                    $self.data("movedFromPos", $self.prevAll().length);
                },
                update: function (event, ui) {
                    var $self = $(ui.item),
                        revertMove = function(index) {
                            if ((opts.$list.children().length - 1) == $self.data("movedFromPos")) {
                                $self.appendTo(opts.$list).removeData("movedFromPos");
                            } else {
                                $self.insertBefore(opts.$list.children("li:eq(" + ($self.data("movedFromPos") + (($self.data("movedFromPos") > index)?1:0)) + ")")).removeData("movedFromPos");
                            }
                        },
                        showError = function () {
                            var message = arguments.length ? arguments[0] : "There was a problem moving your stage.",
                                errorDialog = new AJS.Dialog(400, 150);
                            errorDialog.addHeader("Stage move failed").addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>').addButton("Close", function (dialog) {
                                dialog.hide();
                            });
                            errorDialog.show();
                            revertMove();
                        },
                        callMoveAction = function() {
                            var stageId = $self.attr("id").split("_")[1],
                                index = $self.prevAll().length;
                            $.ajax({
                                type: "POST",
                                url: opts.moveStageUrl,
                                data: { buildKey: opts.chainKey, stageId: stageId, index: index},
                                success: function (json) {
                                    if (json.status == "ERROR") {
                                        if (json.errors && json.errors.length > 0) {
                                            var message = json.errors.join("<br>");
                                            showError(message);
                                        } else {
                                            showError();
                                        }
                                    } else if (json.status == "CONFIRM") {
                                        var cancelCallback = function (dialog) {
                                            revertMove(index);
                                        };
                                        simpleDialogForm(null, opts.confirmStageMoveUrl + "?buildKey=" + opts.chainKey + "&stageId=" + stageId + "&index=" + index, 600, 500, opts.stageMoveHeader, "ajax", null, cancelCallback, opts.stageMoveHeader);
                                    } else {
                                        opts.$list.children(":last-child").addClass("last").siblings().removeClass("last");
                                    }
                                },
                                error: function (XMLHttpRequest, textStatus, errorThrown) {
                                    showError();
                                },
                                dataType: "json"
                            });
                        };
                    callMoveAction();
                }
            });

            var jobLists = opts.$list.find("> li > div > ul");
            jobLists.children("[id^='job_']").draggable({
                cursor: "move",
                handle: ".handle",
                revert: "invalid",
                revertDuration: 300,
                scope: "jobs",
                start: function (event, ui) {
                    var $self = $(this);
                    $self.data("movedFrom", $self.parent()).data("movedFromPos", $self.prevAll().length);

                    // Add a z-index to the stage when someone drags a job to fix IE7's crappy stacking
                    if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                        $self.closest("li[id^='stage_']").css("zIndex", 1).siblings().css("zIndex", "")
                    }
                }
            });
            jobLists.droppable({
                accept: function (li) {
                    return (this != li.parent()[0]); // prevents being able to drop to the same stage
                },
                activeClass: "ui-state-active",
                drop: function (event, ui) {
                    var $self = ui.draggable,
                        revertMove = function () {
                            var $originalFollowingElement = $self.data("movedFrom").children("li:eq(" + $self.data("movedFromPos") + ")");
                            if ($originalFollowingElement.length == 0)  {
                                $self.appendTo($self.data("movedFrom")).removeData("movedFrom").removeData("movedFromPos");
                            } else  {
                                $self.insertBefore($originalFollowingElement).removeData("movedFrom").removeData("movedFromPos");
                            }
                        },
                        showError = function () {
                            var message = arguments.length ? arguments[0] : "There was a problem moving your Job.",
                                errorDialog = new AJS.Dialog(400, 150);

                            errorDialog.addHeader("Job move failed").addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>').addButton("Close", function (dialog) {
                                 dialog.hide();
                            });
                            errorDialog.show();
                            revertMove();
                        },
                        callMoveAction = function() {
                            var stageId = $self.closest("li[id^='stage_']").attr("id").split("_")[1],
                                jobKey = $self.attr("id").split("_")[1];
                            $.ajax({
                                type: "POST",
                                url: opts.moveJobUrl,
                                data: { buildKey: opts.chainKey, stageId: stageId, jobKey: jobKey },
                                success: function (json) {
                                    if (json.status == "ERROR") {
                                        if (json.errors && json.errors.length > 0) {
                                            var message = json.errors.join("<br>");
                                            showError(message);
                                        } else {
                                            showError();
                                        }
                                    } else if (json.status == "CONFIRM") {
                                        var cancelCallback = function () {
                                            revertMove();
                                        };
                                        simpleDialogForm(null, opts.confirmJobMoveJobUrl + "?buildKey=" + opts.chainKey + "&stageId=" + stageId + "&jobKey=" + jobKey, 600, 500, opts.jobMoveHeader, "ajax", null, cancelCallback, opts.jobMoveHeader);
                                    }
                                },
                                error: function (XMLHttpRequest, textStatus, errorThrown) {
                                    showError();
                                },
                                dataType: "json"
                            });
                        };
                    $self.prependTo(this).css({ left: "", top: "" });
                    callMoveAction();
                },
                hoverClass: "ui-state-hover",
                scope: "jobs"
            });
        }
    }
}(jQuery);

var ArtifactDefinitionEdit = function ($) {
    var opts = {
        html: {
            artifactSharingToggleContentShared: null,
            artifactSharingToggleContentUnshared: null
        },
        i18n: {
            artifact_definition_shareToggle_error: null,
            artifact_definition_shareToggle_error_header: null,
            global_buttons_close: null
        },
        deletePackageItem: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        editPackageItem: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        renameArtifactDefinitionToEnableSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        toggleArtifactDefinitionSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        confirmToggleArtifactDefinitionSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        }
    },
    $artifactDefinitionsTable,
    deleteArtifactDefinitionCallback = function (result) {
        var artifact = result.artifactDefinition;

        (($("tbody > tr", $artifactDefinitionsTable).length == 1) ? $artifactDefinitionsTable : $("#artifactDefinition-" + artifact.id)).remove();
    },
    deleteArtifactDefinitionOnClick = function() {
        var artifactId = this.id.split("-")[1],
            hasDependencies = $(this).hasClass("hasDependencies");

        simpleDialogForm(null,
                         opts.deletePackageItem.actionUrl + "&artifactId=" + artifactId,
                         hasDependencies ? 600 : 400,
                         hasDependencies ? 500 : 200,
                         opts.deletePackageItem.submitLabel,
                         "ajax",
                         deleteArtifactDefinitionCallback,
                         null,
                         opts.deletePackageItem.title,
                         null);
    },
    editArtifactDefinitionOnClick = function() {
        var artifactId = this.id.split("-")[1];

        simpleDialogForm(null,
                         opts.editPackageItem.actionUrl + "&artifactId=" + artifactId,
                         800,
                         600,
                         opts.editPackageItem.submitLabel,
                         "ajax",
                         updateArtifactDefinitionCallback,
                         null,
                         opts.editPackageItem.title,
                         null);
    },
    toggleArtifactDefinitionSharingOnClick = function() {
        var artifactId = this.id.split("-")[1],
            showError = function () {
                var message = arguments.length ? arguments[0] : opts.i18n.artifact_definition_shareToggle_error,
                    errorDialog = new AJS.Dialog(400, 150);
                errorDialog.addHeader(opts.i18n.artifact_definition_shareToggle_error_header)
                        .addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>')
                        .addCancel(opts.i18n.global_buttons_close, function (dialog) { dialog.hide(); })
                        .show();
            };

        AJS.$.ajax({
            type: "POST",
            url: opts.toggleArtifactDefinitionSharing.actionUrl,
            data: { artifactId: artifactId },
            success: function (json) {
                if (json.status == "ERROR") {
                    if (json.errors && json.errors.length) {
                        showError(json.errors.join("<br>"));
                    } else if (json.fieldErrors) {
                        if (json.fieldErrors.name && json.fieldErrors.name.length) {
                            simpleDialogForm(null,
                                             opts.renameArtifactDefinitionToEnableSharing.actionUrl + "&artifactId=" + artifactId,
                                             700, 300,
                                             opts.renameArtifactDefinitionToEnableSharing.submitLabel,
                                             "ajax",
                                             updateArtifactDefinitionCallback, null,
                                             opts.renameArtifactDefinitionToEnableSharing.title);
                        } else {
                            var errorMessages = [];
                            for (var fieldError in json.fieldErrors) {
                                errorMessages.push(json.fieldErrors[fieldError].join("<br>"));
                            }
                            showError(errorMessages.join("<br>"));
                        }
                    } else {
                        showError();
                    }
                } else {
                    if (json.status == "CONFIRM") {
                        simpleDialogForm(null,
                                         opts.confirmToggleArtifactDefinitionSharing.actionUrl + "&artifactId=" + artifactId,
                                         600, 500,
                                         opts.confirmToggleArtifactDefinitionSharing.submitLabel,
                                         "ajax",
                                         updateArtifactDefinitionCallback, null,
                                         opts.confirmToggleArtifactDefinitionSharing.title);
                    } else {
                        updateArtifactDefinitionCallback(json);
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                showError();
            },
            dataType: "json"
        });
    },
    updateArtifactDefinitionCallback = function (result) {
        var artifact = result.artifactDefinition,
            $cells = $("#artifactDefinition-" + artifact.id + " > td");

        $($cells[0]).find("span.artifactName").text(artifact.name);
        $($cells[0]).find("span.icon").attr("class", artifact.sharedArtifact ? "icon icon-artifact-shared" : "icon icon-artifact");

        $($cells[1]).text(artifact.location);
        $($cells[2]).text(artifact.copyPattern);

        $("#toggleArtifactDefinitionSharing-" + artifact.id).html(artifact.sharedArtifact ? opts.html.artifactSharingToggleContentShared : opts.html.artifactSharingToggleContentUnshared);

        $artifactDefinitionsTable.trigger("update").trigger("sorton", [$artifactDefinitionsTable.get(0).config.sortList]);
    };

    return {
        init: function (options) {
            $.extend(true, opts, options);

            $artifactDefinitionsTable = $("#artifactDefinitions");

            // initialize table sorter
            $artifactDefinitionsTable.tablesorter({
                headers: {3:{sorter:false},4:{sorter:false}},
                sortList: [[0,0]]
            });
            $artifactDefinitionsTable.delegate("a.deleteArtifactDefinition", "click", deleteArtifactDefinitionOnClick)
                                     .delegate("a.editArtifactDefinition", "click", editArtifactDefinitionOnClick)
                                     .delegate("a.toggleArtifactDefinitionSharing", "click", toggleArtifactDefinitionSharingOnClick);
        }
    }
}(jQuery);


var LinkedJiraProjects = function ($) {
    var defaults = {
        deleteItem: {
            title: null
        }
    },
    $table,
    deleteItemCallback = function (result) {
        var item = result.linkedJiraProject;
        (($("tbody > tr", $table).length == 1) ? $table : $(BAMBOO.escapeIdToJQuerySelector("#linkedJiraProject-" + item.id))).remove();
    };

    return {
        init: function (options) {
            options = AJS.$.extend(defaults, options);

            $table = $("#linkedJiraProjects");

            // initialize table sorter
            $table.tablesorter({
                headers: {2:{sorter:false}},
                sortList: [[0,0]]
            });

            BAMBOO.simpleDialogForm({
                trigger: '#linkedJiraProjects a.deleteLinkedJiraProject',
                dialogWidth: 400,
                dialogHeight: 200,
                success: deleteItemCallback,
                header: options.deleteItem.title
            });
        }
    }
}(jQuery);


/* Tests Tables */
AJS.$(document).delegate(".tests-table > tbody > tr > .twixie > span", "click", function (e) {
    var $twixie = AJS.$(this),
        $tr = $twixie.closest("tr"),
        $stack = $tr.next(),
        newTwixieText = !$twixie.hasClass("icon-collapse") ? "Collapse" : "Expand"; //negated because we toggle the class later
    $stack[$tr.hasClass("collapsed") ? "show" : "hide"]();
    $tr.toggleClass("collapsed expanded");
    $twixie.toggleClass("icon-collapse icon-expand").attr("title", newTwixieText).html("<span>" + newTwixieText + "</span>");
});
AJS.$(document).delegate(".tests-table-container > .controls li", "click", function (e) {
    var $trigger = AJS.$(this),
        $li = $trigger.closest("li"),
        $table = $trigger.closest(".controls").prevAll(".tests-table");
    if ($li.hasClass("expand-all")) {
        $table.find("tbody > .collapsed .twixie > span").click();
    } else if ($li.hasClass("collapse-all")) {
        $table.find("tbody > .expanded .twixie > span").click();
    }
});


/**
 * Strip given prefix from input.
 * Can handle String and jQuery object input.
 *
 * @param prefix String                   prefix to be stripped from input
 * @param input  String or jQuery object
 */
BAMBOO.stripPrefixFromId = function(prefix, input) {
    if (typeof(input) == 'string') {
        if (input.indexOf(prefix) == 0) {
            return input.slice(prefix.length);
        } else {
            return input;
        }
    } else {
        return this.stripPrefixFromId(prefix, AJS.$(input).attr("id"));
    }
};

/**
 * Unsafe (for jQuery id's) character regex
 * Reference: http://docs.jquery.com/Frequently_Asked_Questions#How_do_I_select_an_element_by_an_ID_that_has_characters_used_in_CSS_notation.3F
 */
BAMBOO.unsafeIdCharacterRegex = /(:|\.)/g;

/**
 * Escape characters in element id to use it as jQuery selector
 * @param id
 */
BAMBOO.escapeIdToJQuerySelector = function(id) {
    return id.replace(BAMBOO.unsafeIdCharacterRegex, '\\$1');
};

BAMBOO.buildAUIMessage = function (messages, type, opts) {
    var defaults = {
            escapeTitle : true
        },
        options = AJS.$.extend(true, defaults, opts),
        msg,
        $dummy = AJS.$('<div/>');
    if (messages.length == 1) {
        msg = (options.escapeTitle ? messages[0] : '<strong>' + messages[0] + '</strong>');
        AJS.messages[type]($dummy, (options.escapeTitle ? {title: msg, closeable: false} : {body: msg, closeable: false}));
    } else if (messages.length > 1) {
        var list = ['<ul>'];
        for (var i = 0, ii = messages.length; i < ii; i++) {
            list.push('<li>', messages[i], '</li>');
        }
        list.push('</ul>');
        AJS.messages[type]($dummy, {body: list.join(''), closeable: false});
    }
    return $dummy.children();
};

BAMBOO.buildAUIErrorMessage = function(errors) {
    return BAMBOO.buildAUIMessage(errors, 'error', {});
};

BAMBOO.buildAUIWarningMessage = function(warnings) {
    return BAMBOO.buildAUIMessage(warnings, 'warning', {});
};

BAMBOO.buildFieldError = function(errors) {
    var $dummy = AJS.$('<div/>');
    for (var i = 0, ii = errors.length; i < ii; i++) {
        $dummy.append(AJS.$('<div class="error"/>').html(errors[i]));
    }
    return $dummy.children();
};

/**
 * Add errors to a form field
 * @param $form
 * @param fieldName
 * @param {Array} errors
 * @param {boolean=} animate - display the error(s) with an animation
 */
BAMBOO.addFieldErrors = function($form, fieldName, errors, animate) {
    var $field = AJS.$('#fieldArea_' + $form.attr('id') + '_' + fieldName.replace(BAMBOO.addFieldErrorsFieldNameRegex, "_")),
        $input = AJS.$('#' + $form.attr('id') + '_' + fieldName.replace(BAMBOO.addFieldErrorsFieldNameRegex, "_")),
        $description = $field.find('.description'),
        $errors = BAMBOO.buildFieldError(errors);

    if (animate) {
        $errors.hide();
    }
    if ($description.length) {
        $description.before($errors);
    } else if ($field.length) {
        $field.append($errors);
    } else {
        $input.after($errors);
    }
    if (animate) {
        $errors.slideDown();
    }
};
BAMBOO.addFieldErrorsFieldNameRegex = /\./g;

BAMBOO.ViewInfoList = function($) {
    var opts = {
            elementSelector: null,
            collapseAll: null,
            expandAll: null,
            target: null,
            i18n: {
                collapse: null,
                expand: null
            }
        },
        $container = null,
        collapseAll = function() {
            $container.find(opts.elementSelector + ".expanded > .summary > a.toggle").click();
        },
        expandAll = function() {
            $container.find(opts.elementSelector + ".collapsed > .summary > a.toggle").click();
        },
        toggle = function() {
            var $toggle = $(this),
                $element = $toggle.closest(opts.elementSelector),
                $icon = $toggle.children("span.icon");

            if ($element.hasClass("collapsed")) {
                $icon.toggleClass("icon-expand icon-collapse").attr({title: opts.i18n.collapse}).children().text(opts.i18n.collapse);
                $element.children(".details").stop(true, true).slideDown(function() {
                    $element.toggleClass("expanded collapsed");
                });
            } else {
                $icon.toggleClass("icon-expand icon-collapse").attr({title: opts.i18n.expand}).children().text(opts.i18n.expand);
                $element.children(".details").stop(true, true).slideUp(function() {
                    $element.toggleClass("expanded collapsed");
                });
            }
        };
    return {
        init: function(options) {
            $.extend(true, opts, options);

            $(function(){
                $container = $(opts.target);
                $container.delegate(opts.elementSelector + " > .summary > a.toggle", "click", toggle);
                if (opts.collapseAll) {
                    $(opts.collapseAll).click(collapseAll);
                }
                if (opts.expandAll) {
                    $(opts.expandAll).click(expandAll);
                }
            });
        }
    }
}(jQuery);


(function ($) {
    var i18nCollapse = AJS.I18n.getText("global.buttons.collapse"),
        i18nExpand = AJS.I18n.getText("global.buttons.expand");

    $(document).delegate(".collapsible-section > .summary > h3, .collapsible-section > .summary > .icon", "click", function (e) {
        var $summary = $(this).parent(),
            $section = $summary.closest(".collapsible-section"),
            $details = $section.children(".collapsible-details"),
            $icon = $summary.children(".icon");

        if ($section.hasClass("collapsed")) {
            $icon.addClass("icon-collapse").removeClass("icon-expand").attr({ title: i18nCollapse }).children().text(i18nCollapse);
            $details.stop(true, true).slideDown(function() {
                $section.removeClass("collapsed");
            });
        } else {
            $icon.addClass("icon-expand").removeClass("icon-collapse").attr({ title: i18nExpand }).children().text(i18nExpand);
            $details.stop(true, true).slideUp(function() {
                $section.addClass("collapsed");
            });
        }
    });
})(AJS.$);

/**
 * TODO: extend this with automatic link adding (which will work also for AJAX loaded forms).
 */
BAMBOO.JdkBuilderSelectWidget = function(options) {
    var opts = {
            dialog: {
                height: 320,
                width: 540
            }
        };

    AJS.$.extend(true, opts, options);

    BAMBOO.simpleDialogForm({
        trigger: options.clickTarget,
        dialogWidth: opts.dialog.width,
        dialogHeight: opts.dialog.height,
        success: function(result) {
            AJS.$(opts.displayTarget).append(AJS.$("<option />", { val: result.capability.label, text: result.capability.label })).val(result.capability.label);
        }
    });
};

AJS.$(function ($) {
    addConfirmationToLinks();

    /* Default options for jQuery's tablesorter plugin */
    // use 'zebra' plugin by default
    $.tablesorter.defaults.widgets = ['zebra'];
    // use AUI compatible classes
    $.tablesorter.defaults.widgetZebra = {css: ['', 'zebra']};

    // Drop down for user profile
    AJS.$("#header > .global > .secondary .aui-dd-parent").dropDown("Standard", { trigger: "span.aui-dd-trigger" });
});

BAMBOO.JdkBuilderSelectWidget({clickTarget: "a.addSharedJdkCapability", displayTarget: "select.jdkSelectWidget"});
BAMBOO.JdkBuilderSelectWidget({clickTarget: "a.addSharedBuilderCapability", displayTarget: "select.builderSelectWidget"});

/**
 * Small jQuery method to check if the element has been clipped (content breaking outside it's bounding box) or not
 */
jQuery.fn.isClipped = function () {
    var $el = this.filter(':first');
    return ($el.prop('scrollWidth') > $el.prop('clientWidth'));
};

BAMBOO.openJiraIssueTransitionDialog = function(e) {
    e.preventDefault();
    var $trigger = AJS.$(this),
            dialog = new AJS.Dialog({
                width: 720,
                height: 350,
                keypressListener: function (e) {
                    if (e.which == jQuery.ui.keyCode.ESCAPE) {
                        dialog.remove();
                    }
                }
            });
    dialog.addHeader("Transition Issue").addCancel("Done", function () {
//      dialog.remove();
        reloadThePage();
    });
    AJS.$.ajax({
        url: $trigger.attr("href"),
        data: { 'bamboo.successReturnMode': 'json', decorator: 'rest', confirm: true },
        success: function (html) {
            var $html = AJS.$(html);

            dialog.addPanel("", $html).show();
            BAMBOO.JIRAISSUETRANSITION.init({
                issueKey: $trigger.attr("issueKey"),
                returnUrl: $trigger.attr("returnUrl")
            });
        },
        cache: false
    });
};

BAMBOO.isFlashInstalled = (function() {
    var flashInstalled = function(a,b){try{a=new ActiveXObject(a+b+'.'+a+b)}catch(e){a=navigator.plugins[a+' '+b]}return!!a}('Shockwave','Flash')
    if (!flashInstalled) {
        AJS.$('html').addClass("no-flash");
    }
    return flashInstalled;
}());

(function ($) {
    $(document).on('click', '.system-error-message-remove', function (e) {
        var $a = $(this);
        e.preventDefault();
        $.post($a.attr('href')).done(function () {
            $a.closest('.system-error-message').remove();
        });
    });
}(AJS.$));
