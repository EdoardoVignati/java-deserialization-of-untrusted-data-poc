/**
 * Namespacing utility
 * @function namespace
 * @return {Boolean}
 */
jQuery.namespace = function(str, noclobber) {
    var i, a = str.split("."), o = window, callthrough = false;
    if (/[^a-zA-Z.]/.test(str)) {
        return false;
    }
    for (i = 0; i < a.length; i++) {
        if (!o[a[i]]) {
            o[a[i]] = {};
            callthrough = true;
        }
        o = o[a[i]];
    }
    if (!!noclobber) {
        return callthrough;
    }

    return true;
};