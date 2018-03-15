(function ($, BAMBOO) {
    BAMBOO.DEPLOYMENT.Overview = {};

    BAMBOO.DEPLOYMENT.Overview.AddProject = function (data) {
        eve('deployment.project.add', this, data['project']);
    };

}(jQuery, window.BAMBOO = (window.BAMBOO || {})));
