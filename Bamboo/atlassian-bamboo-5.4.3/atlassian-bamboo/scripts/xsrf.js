AJS.$.ajaxPrefilter(
        function(options, originalOptions, jqXHR) {
            function isMutativeHttpMethod(method) {
                return !(/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
            }
            if (isMutativeHttpMethod(options.type)) {
                options.crossDomain = false;
                jqXHR.setRequestHeader("X-Atlassian-Token", "no-check");
            }
        });

BAMBOO.XsrfUtils = (function ($) {
    function getXsrfTokenFromCookie() {
        return $.cookie('atl.xsrf.token');
    }

    function addXsrfToken($form) {
        $form.append($("<input>", {type: "hidden", name: "atl_token", value: getXsrfTokenFromCookie()}));
    }

    function postOnLinkClick(event) {
        if (event.isDefaultPrevented()) {
            return;
        }

        var $form = $("<form/>", {method: "post", action: this.href});
        addXsrfToken($form);

        $("body").append($form);

        event.preventDefault();
        $form.submit();
    }

    function isOriginCurrentLocation(url) {
        function isUrlEqual(url1, url2) {
            return (url1 == url2 || url1.slice(0, url2.length + 1) == url2 + '/');
        }

        var
                protocol = document.location.protocol,
                hostPort = document.location.host,
                ssHostPort = '//' + hostPort,
                protocolSsHostPort = protocol + ssHostPort;

        if (!url) {
            return false;
        }

        return isUrlEqual(url, protocolSsHostPort) ||
                isUrlEqual(url, ssHostPort) ||
                !(/^(\/\/|http:|https:).*/.test(url)); //not starting with: // or http: or https:
    }

    function addXsrfTokenToFormIfSameOrigin($form) {
        if (isOriginCurrentLocation($form.attr('action'))) {
            addXsrfToken($form);
        }
    }

    function addXsrfTokenProperty(url, object) {
        if (isOriginCurrentLocation(url)) {
            object.atl_token = getXsrfTokenFromCookie();
        }
        return object;
    }

    function addXsrfTokenToForms() {
        function addXsrfTokenSource($form) {
            $form.append($("<input>", {type: "hidden", name: "atl_token_source", value: 'js'})); //this will cause a warning in DEV mode
        }

        $("form").each(function () {
            var
                    $form = $(this),
                    hasNoAtlToken = !$form.find("input[name='atl_token']").length;

            if (hasNoAtlToken) {
                addXsrfTokenToFormIfSameOrigin($form);
                addXsrfTokenSource($form);
            }
        });
    }

    function getAtlTokenQueryParam(url) {
        if (isOriginCurrentLocation(url)) {
            return "atl_token=" + getXsrfTokenFromCookie();
        }
    }

    function registerLinkClickHandler() {
        $(document).on('click', 'a.mutative:not(.requireConfirmation)', postOnLinkClick);
        $(document).on('clickMutativeLink', 'a', postOnLinkClick);
        $(document).on('click', 'a#log-out', postOnLinkClick);
    }

    return {
        registerLinkClickHandler: registerLinkClickHandler,
        addXsrfTokenProperty: addXsrfTokenProperty,
        addXsrfTokenToForm: addXsrfTokenToFormIfSameOrigin,
        addXsrfTokenToForms: addXsrfTokenToForms,
        getAtlTokenQueryParam: getAtlTokenQueryParam
    }
})(AJS.$);


AJS.$(function() {
    BAMBOO.XsrfUtils.addXsrfTokenToForms();
    BAMBOO.XsrfUtils.registerLinkClickHandler();
});