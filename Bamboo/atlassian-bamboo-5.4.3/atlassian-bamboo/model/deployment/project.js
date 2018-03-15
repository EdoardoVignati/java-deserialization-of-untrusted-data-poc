BAMBOO.MODEL.DeploymentProject = Brace.Model.extend({
                namedAttributes: {
                    name: 'string',
                    key: BAMBOO.MODEL.Key,
                    planKey: BAMBOO.MODEL.Key,
                    description: 'string',
                    environments: Brace.Collection.extend({
                                                              model: BAMBOO.MODEL.DeploymentEnvironment
                                                          }),
                    operations: BAMBOO.MODEL.Operations
                }
            });


BAMBOO.MODEL.DeploymentProjectWithEnvironmentStatuses = Brace.Model.extend({
        namedAttributes: {
            deploymentProject: BAMBOO.MODEL.DeploymentProject,
            environmentStatuses: Brace.Collection.extend({
                 model: BAMBOO.MODEL.DeploymentEnvironmentStatus
             })
        }
});

