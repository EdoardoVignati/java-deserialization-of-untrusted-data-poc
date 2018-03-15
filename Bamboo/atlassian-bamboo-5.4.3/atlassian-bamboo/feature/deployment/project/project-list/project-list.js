AJS.$.namespace('Bamboo.Feature.DeploymentProjectList');

Bamboo.Feature.DeploymentProjectList = Brace.View.extend({

    initialize: function (options) {
        this.options.bootstrap = options.bootstrap || [];
        this.collection = new Bamboo.Feature.DeploymentProjectList.Collection(
            this.options.bootstrap, {
                fetchUrl: options.fetchUrl
            }
        );

        this.collection.on('reset', _.bind(this.render, this));
        this._updateTimeoutSuccess = options.updateTimeoutSuccess || 20000;
        this._updateTimeoutFailure = options.updateTimeoutFailure || 60000;

        if (!options.bootstrap.length) {
            this.onUpdate();
        }
    },

    render: function () {
        this.$el.html(bamboo.feature.deployment.project.projectList.projectList({
            projectsWithEnvironmentStatuses: this.collection.toJSON(),
            showProject: this.options.showProject,
            currentUrl: this.options.currentUrl
        }));

        this.$el.find('td.deployment > a')
            .tooltip({aria: true});

        return this;
    },

    onUpdate: function () {
        return this.collection.fetch({
            cache: false
        })
            .done(_.bind(this.render, this))
            .fail(_.bind(this.onError, this))
            .always(_.bind(this.onScheduleNext, this));
    },

    onError: function (jqXHR, textStatus, errorThrown) {
        this.$el.children('.icon-loading, .aui-message').remove();
        this.$el.prepend(AJS.messages.warning({
            title: AJS.I18n.getText('error.refresh.noResponse'),
            closeable: false
        }));
    },

    /**
     * Schedules next poll
     * @param {Object} data the data from a successful request, or the jqXHR object for a failed request
     * @param {String} textStatus
     * @param {Object|String} jqXHR the jqXHR object for a successful request, or the errorThrown for a failed request
     */
    onScheduleNext: function (data, textStatus, jqXHR) {
        clearTimeout(this._timeout);

        var delayBeforeUpdate = ((typeof textStatus === 'undefined' || textStatus === 'success') ?
            this._updateTimeoutSuccess : this._updateTimeoutFailure);

        this._timeout = setTimeout(
            _.bind(this.onUpdate, this),
            delayBeforeUpdate
        );
    }

});

Bamboo.Feature.DeploymentProjectList.Collection = Brace.Collection.extend({

    model: BAMBOO.MODEL.DeploymentProjectWithEnvironmentStatuses,

    fetchUrl: [
        BAMBOO.contextPath,
        'rest/api/latest/deploy/dashboard'
    ].join('/'),

    url: function () {
        return this.fetchUrl;
    },

    comparator: function (projectWithEnvironmentStatus) {
        return projectWithEnvironmentStatus.getDeploymentProject().getName().toLowerCase();
    },

    initialize: function (bootstrap, options) {
        if (options.fetchUrl) {
            this.fetchUrl = options.fetchUrl;
        }
    }

});
