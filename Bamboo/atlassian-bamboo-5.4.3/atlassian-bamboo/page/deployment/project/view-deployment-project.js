(function ($, BAMBOO) {
    BAMBOO.DEPLOYMENT.VIEW = {};

    BAMBOO.DEPLOYMENT.VIEW.init = (function () {
        var hiddenClass = 'hidden';
        $(document).on('click', '#show-all-version-history', function() {
            $('#deployment-project-version-history').find('.' + hiddenClass).removeClass(hiddenClass);
            $(this).remove();
        });
    }());
}(AJS.$, window.BAMBOO = (window.BAMBOO || {})));
