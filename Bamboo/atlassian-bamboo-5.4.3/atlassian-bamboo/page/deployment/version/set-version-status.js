(function ($, BAMBOO)
{

    /**
     *
     * @param options
     * @constructor
     */
    function DeploymentVersion(options)
    {
        this.options = options || {};

        this.versionId = options.versionId;
        this.markApprovedSelector = '.mark-approved';
        this.markBrokenSelector = '.mark-broken';
        this.versionStatusDetailsSelector = '.version-status-details';
        this.versionLozengeContainerSelector = '.version-lozenge-container';
        this.userAndTimeStampContainerSelector = '.detailed-version-info-container';

        this.init(this.options);
    }

    DeploymentVersion.prototype = {
        init: function (options)
        {
            $(document)
                    .on('click', this.markApprovedSelector, $.proxy(this.markApproved, this))
                    .on('click', this.markBrokenSelector, $.proxy(this.markBroken, this));

            BAMBOO.simpleDialogForm({
                trigger: '.delete-deployment-version',
                dialogWidth: 600,
                dialogHeight: 250,
                success: redirectAfterReturningFromDialog
            });
        },
        markApproved: function (e)
        {
            if ($(e.currentTarget).attr('aria-pressed'))
            {
                this.markVersion('APPROVED', false);
            }
            else
            {
                this.markVersion('APPROVED', true);
            }
        },
        markBroken: function (e)
        {
            if ($(e.currentTarget).attr('aria-pressed'))
            {
                this.markVersion('BROKEN', false);
            }
            else
            {
                this.markVersion('BROKEN', true);
            }
        },
        clearButtonStates: function ()
        {
            $(this.markApprovedSelector).removeAttr('aria-pressed');
            $(this.markBrokenSelector).removeAttr('aria-pressed');
        },
        markVersion: function (status, enabled)
        {
            this.clearButtonStates();
            $.ajax({
                       url: AJS.contextPath() + '/rest/api/latest/deploy/version/' + this.versionId + '/status/' + (enabled ? status : 'UNKNOWN'),
                       dataType: 'json',
                       type: 'POST'
                   }).done($.proxy(this.updateVersionStatus, this))
        },
        updateVersionStatus: function (data)
        {
            var $versionLozengeContainer = $(this.versionLozengeContainerSelector);
            $versionLozengeContainer.empty();

            $(widget.status.deploymentVersionStatus({ deploymentVersionState: data.versionState})).appendTo($versionLozengeContainer);

            var $userAndTimeStampContainer = $(this.userAndTimeStampContainerSelector);
            $userAndTimeStampContainer.empty();
            $(widget.status.deploymentVersionStatusInfo({ deploymentVersionState: data.versionState, userName: data.userName, displayName: data.displayName, avatar: data.gravatarUrl})).appendTo($userAndTimeStampContainer);

            if (data.versionState == 'APPROVED' || data.versionState == 'BROKEN') {
                $(this.versionStatusDetailsSelector).removeClass('version-status-hidden');
            }
            else {
                $(this.versionStatusDetailsSelector).addClass('version-status-hidden');
            }

            if (data.versionState == 'APPROVED')
            {
                $(this.markApprovedSelector).attr('aria-pressed', 'true');
            }
            if (data.versionState == 'BROKEN')
            {
                $(this.markBrokenSelector).attr('aria-pressed', 'true');
            }
        }
    };

    BAMBOO.DEPLOYMENT.DeploymentVersion = DeploymentVersion;

}(AJS.$, window.BAMBOO = (window.BAMBOO || {})));
